# NEQChatKit & NEQChatUIKit Changelog

## 9.4.0(2023-03-08)
### Behavior changes
* 圈组聊天详情页支持优先使用本地缓存数据，本地无消息缓存再拉远端数据。
### Bug Fixes
* 修复圈组加入别人服务器输入超长数字搜索崩溃的问题。
* 修复圈组身份组名称过长，身份组权限设置页标题展示不完整的问题。
* 修复圈组创建服务器，服务器名称输入空格也可以创建成功的问题。
* 修复圈组创建身份组输入纯空格也可以创建成功的问题。
* 修复圈组创建频道频道名称全为空格可以创建成功的问题。
* 修复圈组限制字数的输入框输入连续输入长文字，会限制输入的问题。
* 修复圈组服务器成员昵称最大字符长度未设置的问题。
* 修复圈组创建身份组不输入身份组名称创建按钮高亮的问题。
* 修复圈组频道成员列表页，成员服务器昵称超长展示异常的问题。
* 修复圈组播放语音消息过程中离开当前页面语音消息未停止的问题。
* 修复圈组频道权限设置页面成员服务器昵称超长显示溢出的问题。
* 修复圈组频道权限设置页面添加成员，成员列表展示服务器版主的问题。
* 修复圈组无网络添加服务器成员无任何提示的问题。
* 修复圈组无权限邀请他人进服务器无提示的问题 。
* 修复圈组创建身份组快速点击创建按钮，创建出重复身份组的问题。
* 修复 频道详情页操作过拍照&打开相册后，再断网，详情页不显示断网红字提示的问题。
* 修复圈组频道聊天页面断网重连过程多次点击图片消息icon，连网成功后无网络提示不消失的问题。
* 修复圈组服务器频道超多上拉后最后两个频道被遮挡的问题。
* 修复圈组身份组成员添加页面无成员时无占位图的问题。
* 修复圈组服务器成员列表页，成员所在身份组名字较长展示异常的问题。
* 修复修复圈组频道，权限配置页身份组超过5个时，查看更多后面没显示总个数的问题。
* 修复圈组无网络操作各权限开关提示：请求过程超时的问题，改为：当前网络错误。
* 修复圈组无权限设置频道权限进入频道权限设置页面展示多出身份组标题的问题。
* 修复圈组无权限创建频道，不停点击创建按钮自动退回到频道列表页的问题。
* 修复圈组创建服务器输入超长服务器名称后点击输入框其他位置，输入内容溢出输入框的问题。
* 修复频道成员页面及频道权限设置页面成员列表栏展示异常（底部横线）的问题。
* 关闭麦克风权限发送语音消息提示文案由 toast 弹窗改为 alert 弹窗。
* 修复圈组聊天页面消息与输入框展示连在一起的问题。
* 修复圈组添加身份组成员页面断网后点击确认返回上一页连网后一直显示loading状态的问题。
* 修复圈组版主删除频道，频道成员在频道聊天页面或频道设置页面，频道成员未自动退回到server列表页面的问题。
* 修复圈组普通成员无修改自己服务器成员信息权限也可以修改自己的服务器成员信息的问题。
* 修复频道聊天页，成员没有权限情况下发送图片，弹窗点击确认后，聊天页面展示消息发送时间的问题。
* 修复圈组成员名片身份组名称超长展示异常的问题。
* 修复偶现创建服务器时创建出重复频道的问题。
* 修复圈组频道权限编辑页面删除身份组报错的问题。

## 9.3.1(2023-1-05)
*   - FIXED    修复 NEMapKit 组件的已知问题。

## 9.3.0(2022-12-05)
*   - NEW    新增地理位置消息功能，具体实现方法参见实现地理位置消息功能。
*   - NEW    新增文件消息功能（升级后可直接使用）。
*   - FIXED    修复更新讨论组/高级群头像失败的问题。
*   - FIXED    修复发送视频消息未显示首帧的问题。
*   - FIXED    修复表情和文案不一致的问题。
*   - FIXED    修复“正在输入中”的显示问题。
*   - FIXED    修复群聊消息已读按钮失效的问题。
*   - FIXED    修复其他已知问题。

## 9.2.11(2022-11-17)
*   - UPDATE   NIM SDK 版本升级到 V9.6.4    
*   - FIXED    修复好友名片中未显示基本信息的问题。
*   - FIXED    修复视频消息加载问题。
*   - FIXED    修复更新自己群昵称失败的问题。
*   - FIXED    修复加入他人圈组服务器的按钮失效问题。
*   - FIXED    修复圈组频道成员列表和频道黑白名单成员列表的展示问题。
*   - FIXED    修复无法退出图片详情页的问题。
*   - FIXED    修复历史图片未展示缩略图的问题。
*   - FIXED    修复黑名单成员列表头像与好友头像不一致的问题。
*   - FIXED    修复其他已知问题。


## 9.2.10(02-November-2022)
*   - FIXED    修复xcode 14编译错误问题

## 9.2.9(25-August-2022)
*   - NEW      iOS新增自定义用户信息功能。
*   - changed  IMKitEngine类中功能迁移至IMKitClient
*   - FIXED    修复OC工程调用UI库失败问题
*   - FIXED    统一接口层API
*   - FIXED    修复已知bug

## 9.2.8(19-September-2022)
*   - NEW    多语言能力支持
*   - FIXED  相机权限修改
*   - FIXED  历史遗留bug修改

## 9.2.7(25-August-2022)
*   - FIXED  修复 Swift 版本编译问题。
*   - FIXED  修复相册选择图片时图片展示问题。
*   - FIXED  修复圈组频道身份组权限信息展示问题。

## 9.2.6-rc01(02-August-2022)
*   - FIXED  修复导航控制器push 页面 页面卡顿问题

## 9.2.6-rc01(02-August-2022)
*   - FIXED  修复导航控制器push 页面 页面卡顿问题
*   - FIXED  修改错误emoji表情问题。
*   - FIXED  统一log命名->NELog
*   - FIXED  好友名片页去掉消息提醒开关
*   - FIXED  修复app端修改群组头像 web端不能展示问题
*   - FIXED  统一podspec依赖，三方库不设置固定版本
*   - NEW    添加Conversationrepo chatrepo 注解
*   - NEW    新增userInfoProvider功能类

## 9.2.4(28-June-2022)
*   - FIXED  修复客户反馈chat页面，无消息时下拉崩溃，新建群组下拉消息重复。
*   - FIXED  router路由对齐，contact主页面设置open。
*   - FIXED  修改Toast提示信息位置
*   - NEW    补充自定义消息逻辑

## 9.2.1(20-July-2022)
    - FIXED  低版本xcode编译低版本的包（xcode 13.2.1）

## 9.0.2(29-May-2022)
*   - FIXED  修复NEConversationUIKit,NEChatUIKit,NETeamUIKit,NEQChatUIKit,NEContactUIKit中作用域问题。

## 9.0.1(19-May-2022)
*   - NEW  我的->个人信息页 新增copy账号功能
*   - FIXED 修复头像被压缩问题
*   - FIXED 发送视屏压缩模糊问题修复
*   - FIXED 修复搜索框背景色,高度问题，修复会话列表首页弹窗阴影过重问题，修复alert弹窗色值问题，修复通讯录icon失真问题...
*   - FIXED 更新会话列表logo&title
*   - FIXED 修复圈组聊天页键盘偶现不能弹起问题。
*   - FIXED 修复图片预览被压缩变形问题

## 9.0.0(09-May-2022)
*   - NEW  swift新版本IM发布,包含消息，圈组，通讯录，我的版块。