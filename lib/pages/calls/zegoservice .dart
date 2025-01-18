// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';

// class Zegoservice {
//   int appID = 1799959270;
//   String appSign =
//       "4944212df9ff33cfe9a80cdc8fb122d6a598d9549bb013e47a3376af56ebe9bf";

// //create zego engine

//   Future<void> createEngine() async {
//     WidgetsFlutterBinding.ensureInitialized();

//     await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
//         appID, ZegoScenario.Default,
//         appSign: kIsWeb ? null : appSign));
//   }

//   //set up an event handler
//   void startLIstenEvent() {
//     //callback for updates on the status of other users in the room
//     //when user log in or log out the room
//     ZegoExpressEngine.onRoomUserUpdate =
//         (roomid, updatetype, List<ZegoUser> stremlist) {
//       debugPrint(
//           'onRoomStreamUpdate: roomID: $roomid, updateType: $updatetype, streamList: ${stremlist.map((e) => e.userID)}');

//       if (updatetype == ZegoUpdateType.Add) {
//         for (final stream in stremlist) {
//           ZegoExpressEngine.instance.startPlayingStream(stream.userID);
//         }
//       } else {
//         for (final stream in stremlist) {
//           ZegoExpressEngine.instance.stopPlayingStream(stream.userID);
//         }
//       }
//     };

//     //callback for update on the current user room connection
//     ZegoExpressEngine.onRoomStateUpdate =
//         (roomID, state, errorCode, extendedData) {
//       debugPrint(
//           'onRoomStateupdate = : $roomID, state : ${state.name},errorcode : $errorCode,extendeddata : $extendedData ');
//     };
//     ZegoExpressEngine.onPublisherStateUpdate =
//         (streamID, state, errorCode, extendedData) {
//       debugPrint(
//           'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//     };

//     void stopListenEvent() {
//       ZegoExpressEngine.onRoomUserUpdate = null;
//       ZegoExpressEngine.onRoomStreamUpdate = null;
//       ZegoExpressEngine.onRoomStateUpdate = null;
//       ZegoExpressEngine.onPublisherStateUpdate = null;
//     }
//   }
// Future<ZegoRoomLoginResult> loginroom ()async{
// final user = ZegoUser(widget., userName)
// }

// }
