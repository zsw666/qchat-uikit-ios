// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import CoreMedia
import Foundation
import NECoreQChatKit
import NEQChatKit

@objcMembers
public class QChatMemberManagerViewModel: NSObject {
  var datas = [QChatUserInfo]()

  var delegate: ViewModelDelegate?

  let repo = QChatRepo.shared

  let limit = 20

  private let className = "QChatMemberManagerViewModel"

  override init() {}

  func getData(_ sid: UInt64?, _ rid: UInt64?, _ refresh: Bool = false) {
    NELog.infoLog(ModuleName + " " + className, desc: #function + ", sid:\(sid ?? 0)")
    var param = NEQChatGetServerRoleMembersParam()
    param.limit = limit
    param.serverId = sid
    param.roleId = rid
    if let last = datas.last, let accid = last.accid, let createTime = last.createTime,
       refresh == false {
      param.accid = accid
      param.timeTag = createTime
      print("load more : ", param)
    } else {
      param.accid = ""
      param.timeTag = 0
      print("first refresh : ", param)
    }
    weak var weakSelf = self
    repo.getServerRoleMembers(param) { error, members in
      if let err = error {
        weakSelf?.delegate?.dataDidError(err)
      } else {
        if refresh == true {
          weakSelf?.datas.removeAll()
        }
        for member in members {
          let user = QChatUserInfo(member)
          weakSelf?.datas.append(user)
        }
        weakSelf?.delegate?.dataDidChange()
        if let count = weakSelf?.limit, members.count < count {
          weakSelf?.delegate?.dataNoMore?()
        }
      }
    }
  }

  func addMembers(_ users: [QChatUserInfo], _ serverId: UInt64?, _ roleId: UInt64?,
                  _ completion: @escaping (Int) -> Void) {
    NELog.infoLog(ModuleName + " " + className, desc: #function + ", users.count:\(users.count)")
    var param = NEQChatAddServerRoleMemberParam()
    param.serverId = serverId
    param.roleId = roleId
    var accids = [String]()
    for user in users {
      if let accid = user.serverMember?.accid {
        accids.append(accid)
      }
    }
    param.accountArray = accids
    weak var weakSelf = self

    repo.addRoleMember(param) { error, successAccids, failedAccids in
      print("add role member result : ", error as Any)
      if let err = error {
        weakSelf?.delegate?.dataDidError(err)
      } else {
        weakSelf?.getData(serverId, roleId, true)

//                print("add members success accids : ", successAccids)
//                var dic = [String: QChatUserInfo]()
//                users.forEach { user in
//                    print("for each role member : ", user.serverMember as Any)
//                    if let accid = user.serverMember?.accid {
//                        dic[accid] = user
//                    }
//                }
//                successAccids.forEach { accid in
//                    if let user = dic[accid] {
//                        print("add data user ", user)
//                        weakSelf?.datas.append(user)
//                    }
//                }
//                weakSelf?.delegate?.dataDidChange()
        completion(successAccids.count)
      }
    }
  }

  func remove(_ user: QChatUserInfo, _ serverId: UInt64?, _ rid: UInt64?,
              _ completion: @escaping (Int) -> Void) {
    NELog.infoLog(ModuleName + " " + className, desc: #function + ", serverId:\(user.serverId ?? 0)")
    var param = NEQChatRemoveServerRoleMemberParam()
    param.serverId = serverId
    param.roleId = rid
    weak var weakSelf = self
    if let accid = user.accid {
      param.accountArray = [accid]
      repo.deleateRoleMember(param) { error, successAccids, failedAccids in
        if let err = error {
          weakSelf?.delegate?.dataDidError(err)
        } else {
          completion(failedAccids.count)
        }
      }
    } else {}
  }
}
