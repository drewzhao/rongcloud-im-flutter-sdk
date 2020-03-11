import 'package:flutter/material.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatDebugPage extends StatefulWidget {
  final Map arguments;

  ChatDebugPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ChatDebugPageState(arguments: this.arguments);
}

class _ChatDebugPageState extends State<ChatDebugPage> {
  Map arguments;
  List titles;
  int conversationType;
  String targetId;
  bool isPrivate;

  _ChatDebugPageState({this.arguments});
  @override
  void initState() {
    super.initState();
    conversationType = arguments["coversationType"];
    targetId = arguments["targetId"];

    if (conversationType == RCConversationType.Private) {
      isPrivate = true;
      titles = [
        "加入黑名单",
        "移除黑名单",
        "查看黑名单状态",
        "获取黑名单列表",
        "设置免打扰",
        "取消免打扰",
        "查看免打扰",
      ];
    } else if (conversationType == RCConversationType.Group) {
      isPrivate = false;
      titles = [
        "设置免打扰",
        "取消免打扰",
        "查看免打扰",
      ];
    }
  }

  void _didTap(int index) {
    print("did tap debug " + titles[index]);
    switch (index) {
      case 0:
        isPrivate ? _addBlackList() : _setConStatusEnable();
        break;
      case 1:
        isPrivate ? _removeBalckList() : _setConStatusDisanable();
        break;
      case 2:
        isPrivate ? _getBlackStatus() : _getConStatus();
        break;
      case 3:
        isPrivate ? _getBlackList() : _getBlackList();
        break;
      case 4:
        _setConStatusEnable();
        break;
      case 5:
        _setConStatusDisanable();
        break;
      case 6:
        _getConStatus();
        break;
    }
  }

  void _addBlackList() {
    print("_addBlackList");
    RongcloudImPlugin.addToBlackList(targetId, (int code) {
      String toast = code == 0 ? "加入黑名单成功" : "加入黑名单失败， $code";
      print(toast);
      Fluttertoast.showToast(msg: toast);
    });
  }

  void _removeBalckList() {
    print("_removeBalckList");
    RongcloudImPlugin.removeFromBlackList(targetId, (int code) {
      String toast = code == 0 ? "取消黑名单成功" : "取消黑名单失败，错误码: $code";
      print(toast);
      Fluttertoast.showToast(msg: toast);
    });
  }

  void _getBlackStatus() {
    print("_getBlackStatus");
    RongcloudImPlugin.getBlackListStatus(targetId, (int blackStatus, int code) {
      if (0 == code) {
        if (RCBlackListStatus.In == blackStatus) {
          print("用户:" + targetId + " 在黑名单中");
          Fluttertoast.showToast(msg: "用户:" + targetId + " 在黑名单中");
        } else {
          print("用户:" + targetId + " 不在黑名单中");
          Fluttertoast.showToast(msg: "用户:" + targetId + " 不在黑名单中");
        }
      } else {
        print("用户:" + targetId + " 黑名单状态查询失败" + code.toString());
        Fluttertoast.showToast(
            msg: "用户:" + targetId + " 黑名单状态查询失败" + code.toString());
      }
    });
  }

  void _getBlackList() {
    print("_getBlackList");
    RongcloudImPlugin.getBlackList((List/*<String>*/ userIdList, int code) {
      Fluttertoast.showToast(
          msg: "获取黑名单列表:\n userId 列表:" + userIdList.toString() + (code == 0 ? "" : "\n获取失败，错误码 code:" + code.toString()), timeInSecForIos: 2);
      userIdList.forEach((userId) {
        print("userId:" + userId);
      });
    });
  }

  void _setConStatusEnable() {
    RongcloudImPlugin.setConversationNotificationStatus(
        RCConversationType.Private, targetId, true, (int status, int code) {
      print("setConversationNotificationStatus1 status " + status.toString());
      String text = code == 0 ? "设置免打扰成功" : "设置免打扰失败，错误码: $code";
      Fluttertoast.showToast(msg: text);
    });
  }

  void _setConStatusDisanable() {
    RongcloudImPlugin.setConversationNotificationStatus(
        RCConversationType.Private, targetId, false, (int status, int code) {
      print("setConversationNotificationStatus2 status " + status.toString());
      String text = code == 0 ? "取消免打扰成功" : "取消免打扰失败，错误码: $code";
      Fluttertoast.showToast(msg: text);
    });
  }

  void _getConStatus() {
    RongcloudImPlugin.getConversationNotificationStatus(
        RCConversationType.Private, targetId, (int status, int code) {
      String toast = "getConversationNotificationStatus3 免打扰状态:" + (status == 0? "免打扰":"有消息提醒");
      print(toast);
      Fluttertoast.showToast(msg: toast);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Debug"),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: titles.length,
        itemBuilder: (BuildContext context, int index) {
          return MaterialButton(
            onPressed: () {
              _didTap(index);
            },
            child: Text(titles[index]),
            color: Colors.blue,
          );
        },
      ),
    );
  }
}
