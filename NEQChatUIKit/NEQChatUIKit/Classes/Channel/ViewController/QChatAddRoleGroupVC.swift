
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import MJRefresh
import NECoreQChatKit
import NEQChatKit
import UIKit

typealias AddChannelRoleBlock = (_ role: NEQChatChannelRole?) -> Void
public class QChatAddRoleGroupVC: QChatSearchVC {
  public var channel: NEQChatChatChannel?
  private var serverRoles: [NEQChatServerRole]?
  private var channelRoles: [NEQChatChannelRole]?
//    public var didAddChannelRole: AddChannelRoleBlock?
  private var priority: Int?
  private lazy var placeholderView: NEEmptyDataView = .init(
    image: UIImage.ne_imageNamed(name: "rolePlaceholder"),
    content: localizable("has_no_role"),
    frame: CGRect(
      x: 0,
      y: topConstant,
      width: self.view.bounds.size.width,
      height: self.view.bounds.size.height
    )
  )

  override public func viewDidLoad() {
    super.viewDidLoad()
    title = localizable("add_group")
    navigationView.backgroundColor = .white
    navigationView.titleBarBottomLine.isHidden = false

    tableView.register(
      QChatTextArrowCell.self,
      forCellReuseIdentifier: "\(QChatTextArrowCell.self)"
    )
    tableView.mj_header = MJRefreshNormalHeader(
      refreshingTarget: self,
      refreshingAction: #selector(loadData)
    )
    tableView.mj_footer = MJRefreshBackNormalFooter(
      refreshingTarget: self,
      refreshingAction: #selector(loadMore)
    )
    view.addSubview(placeholderView)
    loadData()
  }

  init(channel: NEQChatChatChannel?) {
    super.init(nibName: nil, bundle: nil)
    self.channel = channel
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func loadData() {
    priority = 0
    // 加载server的身份组
    var param = NEQChatGetServerRoleParam()
    param.serverId = channel?.serverId
    param.limit = 50
    param.priority = priority
    print("thread:\(Thread.current)")
    QChatRoleProvider.shared.getRoles(param) { [weak self] error, roles, sets in
      if let err = error as NSError? {
        switch err.code {
        case errorCode_NetWorkError:
          self?.showToast(localizable("network_error"))
        case errorCode_NoPermission:
          self?.showToast(localizable("no_permession"))
        default:
          self?.showToast(err.localizedDescription)
        }
        // 空白页
        self?.placeholderView.isHidden = false
      } else {
        if let roleArray = roles, !roleArray.isEmpty {
          self?.priority = roleArray.last?.priority
          if let sid = self?.channel?.serverId, let cid = self?.channel?.channelId {
            // 过滤掉已经存在在channel中的身份组
            var ids = [UInt64]()
            for role in roleArray {
              if let id = role.roleId {
                ids.append(id)
              }
            }
            let param = NEQChatGetExistingChannelRolesByServerRoleIdsParam(
              serverId: sid,
              channelId: cid,
              roleIds: ids
            )
            QChatRoleProvider.shared
              .getExistingChannelRoles(param: param) { error, channelRoles in
                if let existRoles = channelRoles, !existRoles.isEmpty {
                  var tmp = [NEQChatServerRole]()
                  print("roleArray: \(roleArray)")
                  for role in roleArray {
                    if existRoles.contains(where: { existRole in
                      role.roleId == existRole.parentRoleId
                    }) {
                    } else {
                      tmp.append(role)
                    }
                  }
                  self?.serverRoles = tmp
                  self?.placeholderView.isHidden = !tmp.isEmpty

                } else {
                  self?.serverRoles = roleArray
                  self?.placeholderView.isHidden = !roleArray.isEmpty
                }
                self?.tableView.mj_footer?.resetNoMoreData()
                self?.tableView.mj_header?.endRefreshing()
                self?.tableView.reloadData()
              }
          } else {
            self?.serverRoles = roleArray
            self?.tableView.mj_footer?.resetNoMoreData()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.reloadData()
          }
        } else {
          // 空白页
          self?.placeholderView.isHidden = false
        }
      }
    }
  }

  @objc func loadMore() {
    // 加载server的身份组
    var param = NEQChatGetServerRoleParam()
    param.serverId = channel?.serverId
    param.limit = 50
    param.priority = priority
    QChatRoleProvider.shared.getRoles(param) { [weak self] error, roles, sets in
      if let err = error as NSError? {
        switch err.code {
        case errorCode_NetWorkError:
          self?.showToast(localizable("network_error"))
        case errorCode_NoPermission:
          self?.showToast(localizable("no_permession"))
        default:
          self?.showToast(err.localizedDescription)
        }
      } else {
        if let roleArray = roles, !roleArray.isEmpty {
          self?.priority = roleArray.last?.priority
          if let sid = self?.channel?.serverId, let cid = self?.channel?.channelId {
            // 过滤掉已经存在在channel中的身份组
            var ids = [UInt64]()
            for role in roleArray {
              if let id = role.roleId {
                ids.append(id)
              }
            }
            let param = NEQChatGetExistingChannelRolesByServerRoleIdsParam(
              serverId: sid,
              channelId: cid,
              roleIds: ids
            )
            QChatRoleProvider.shared
              .getExistingChannelRoles(param: param) { error, channelRoles in
                if let existRoles = channelRoles, !existRoles.isEmpty {
                  for role in roleArray {
                    if existRoles.contains(where: { existRole in
                      role.roleId == existRole.parentRoleId
                    }) {
                    } else {
                      self?.serverRoles?.append(role)
                    }
                  }
                } else {
                  for role in roleArray {
                    self?.serverRoles?.append(role)
                  }
                }

                self?.placeholderView.isHidden = true
                self?.tableView.mj_footer?.endRefreshing()
                self?.tableView.reloadData()
              }
          } else {
            for role in roleArray {
              self?.serverRoles?.append(role)
            }
            self?.placeholderView.isHidden = true
            self?.tableView.mj_footer?.endRefreshing()
            self?.tableView.reloadData()
          }

        } else {
          self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
      }
    }
  }

  override public func tableView(_ tableView: UITableView,
                                 numberOfRowsInSection section: Int) -> Int {
    serverRoles?.count ?? 0
  }

  override public func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "\(QChatTextArrowCell.self)",
      for: indexPath
    ) as! QChatTextArrowCell
    cell.backgroundColor = .white
    cell.titleLabel.text = serverRoles?[indexPath.row].name
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let role = serverRoles?[indexPath.row]
    guard let sId = channel?.serverId, let cId = channel?.channelId,
          let roleId = role?.roleId else {
      return
    }
    // 1.添加到话题下
    let param = NEQChatAddChannelRoleParam(serverId: sId, channelId: cId, parentRoleId: roleId)
    QChatRoleProvider.shared.addChannelRole(param: param) { [weak self] error, cRole in
      if let err = error as NSError? {
        switch err.code {
        case errorCode_NetWorkError:
          self?.showToast(localizable("network_error"))
        case errorCode_NoPermission:
          self?.showToast(localizable("no_permession"))
        case errorCode_NoExist:
          self?.showToast(localizable("role_not_exist"))
        case errorCode_Existed:
          self?.showToast(localizable("role_has_exist"))
        default:
          self?.showToast(err.localizedDescription)
        }
      } else {
        // 2.跳转到身份组权限设置
        self?.navigationController?.pushViewController(
          QChatGroupPermissionSettingVC(cRole: cRole),
          animated: true
        )
        // 3.此页面移除该数据并刷新
        self?.serverRoles?.remove(at: indexPath.row)
        if self?.serverRoles?.count ?? 0 > 0 {
          self?.placeholderView.isHidden = true
          self?.tableView.reloadData()
        } else {
          self?.placeholderView.isHidden = false
        }
//                if let block = self?.didAddChannelRole {
//                    block(cRole)
//                }
      }
    }
  }
}
