// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatefulWidget {
  String callId;

  CallPage({
    super.key,
    required this.callId,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  int appId = 1918440318;

  String appsign =
      "3e0dcfb42db32a10089700b33397ef0ecbe5b35294c57303454a6c732df885b7";

  final userid = Random().nextInt(100000);

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        onDispose: () {},
        appID: appId,
        callID: widget.callId,
        userID: userid.toString(),
        userName: "userName$userid",
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall());
  }
}
