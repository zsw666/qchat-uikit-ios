// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import AVFoundation
import Foundation
import NECoreQChatKit
import NEQChatKit

@objcMembers
public class QChatIdGroupSortViewModel: NSObject {
  let repo = QChatRepo.shared

  var datas = NSMutableArray()

//    var lockData = [IdGroupModel]()

  weak var delegate: ViewModelDelegate?

  var isOwner = false

  func getData(_ serverId: UInt64?) {
    NELog.infoLog(ModuleName + " " + className(), desc: #function + ", serverId:\(serverId ?? 0)")
    var param = NEQChatGetServerRoleParam()
    param.limit = 200
    param.serverId = serverId
    weak var weakSelf = self

    repo.getRoles(param) { error, roles, sets in
      if let err = error {
        weakSelf?.delegate?.dataDidError(err)
      } else {
        weakSelf?.filterData(roles, sets)
      }
    }
  }

  func filterData(_ roles: [NEQChatServerRole]?, _ sets: Set<NSNumber>?) {
    NELog.infoLog(ModuleName + " " + className(), desc: #function + ", roles.count:\(roles?.count ?? 0)")
    weak var weakSelf = self
    roles?.forEach { role in
      if role.type == .everyone {
        return
      }
      let model = QChatIdGroupModel(role)
      model.hasPermission = isOwner
      if let rid = role.roleId, let s = sets, s.contains(NSNumber(value: rid)) == true {
        isOwner = true
      }
      weakSelf?.datas.add(model)
//            if model.hasPermission == true {
//                weakSelf?.datas.add(model)
//            }else {
//                weakSelf?.lockData.append(model)
//            }
    }
    weakSelf?.delegate?.dataDidChange()
  }

  func removeRole(_ serverId: UInt64?, _ roleId: UInt64?, _ model: QChatIdGroupModel,
                  _ completion: @escaping () -> Void) {
    NELog.infoLog(ModuleName + " " + className(), desc: #function + ", serverId:\(serverId ?? 0)")
    var param = NEQChatDeleteServerRoleParam()
    param.serverId = serverId
    param.roleId = roleId
    weak var weakSelf = self
    repo.deleteRoles(param) { error in
      if let err = error {
        weakSelf?.delegate?.dataDidError(err)
      } else {
        weakSelf?.datas.remove(model)
        weakSelf?.delegate?.dataDidChange()
        completion()
      }
    }
  }

  func saveSort(_ serverId: UInt64?, _ completion: @escaping () -> Void) {
    NELog.infoLog(ModuleName + " " + className(), desc: #function + ", serverId:\(serverId ?? 0)")
    var startIndex = 0

    var startSort = false
    var last: QChatIdGroupModel?
    var items = [NEQChatUpdateServerRolePriorityItem]()

    var min: Int?

    for data in datas {
      if let model = data as? QChatIdGroupModel, model.hasPermission == true {
        print("model p : ", model.role?.priority as Any)
        if let m = min, let p = model.role?.priority {
          if m > p {
            min = p
          }
        } else {
          min = model.role?.priority
        }
      }
    }

    print("print min : ", min as Any)

    for index in 0 ..< datas.count {
      if let m = datas[index] as? QChatIdGroupModel, let r = m.role {
        if startSort == false, m.hasPermission == true {
          startSort = true
          if let m = min {
            startIndex = m
          }
        }
        if startSort == false {
        } else {
          let item = NEQChatUpdateServerRolePriorityItem(r, startIndex)
          items.append(item)
          startIndex += 1
          print("item priority : ", startIndex)
        }
        last = m
        print("item name : ", m.idName as Any)
      }
    }

    var param = NEQChatUpdateServerRolePrioritiesParam()
    param.updateItems = items
    param.serverId = serverId
    weak var weakSelf = self

    if items.count <= 1 {
      completion()
      return
    }

    repo.updateServerRolePriorities(param) { error in
      if let err = error {
        weakSelf?.delegate?.dataDidError(err)
      } else {
        completion()
      }
    }
  }
}
