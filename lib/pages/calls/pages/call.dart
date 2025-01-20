import 'package:chat/pages/calls/service/webrtcsignaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallPage extends StatefulWidget {
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  Webrtcsignaling? signaling;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool inCalling = false;
  String? roomId;
  late TextEditingController _joinRoomTextEditingController;

  @override
  void initState() {
    _joinRoomTextEditingController = TextEditingController();
    _connect();
    super.initState();
  }

  void _connect() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    if (signaling == null) {
      signaling = Webrtcsignaling();

      signaling?.onLocalstream = ((stream) {
        localRenderer.srcObject = stream;
      });

      signaling?.onAddRemotestream = ((stream) {
        remoteRenderer.srcObject = stream;
      });

      signaling?.onRemoveRemoteStream = (() {
        remoteRenderer.srcObject = null;
      });

      signaling?.onDisconnect = (() {
        setState(() {
          inCalling = false;
          roomId = null;
        });
      });
    }
  }

  @override
  deactivate() {
    super.deactivate();
    localRenderer.dispose();
    remoteRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase WebRTC'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: inCalling
          ? SizedBox(
              width: 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () async {
                      await signaling?.hangUp();
                      setState(() {
                        roomId = null;
                        inCalling = false;
                      });
                    },
                    tooltip: 'Hangup',
                    child: Icon(Icons.call_end),
                    backgroundColor: Colors.red.shade700,
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.mic_off),
                    onPressed: signaling?.muteMic,
                    tooltip: 'Mute Mic',
                  )
                ],
              ),
            )
          : null,
      body: inCalling
          ? Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RTCVideoView(remoteRenderer),
                    decoration: BoxDecoration(color: Colors.black54),
                  ),
                  Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: Container(
                      width: 120.0,
                      height: 90.0,
                      child: RTCVideoView(localRenderer, mirror: true),
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 36.0,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color?>(
                            Theme.of(context).primaryColor),
                        foregroundColor:
                            MaterialStateProperty.all<Color?>(Colors.white),
                      ),
                      label: Text('CREATE ROOM'),
                      icon: Icon(Icons.group_add),
                      onPressed: () async {
                        final _roomId = await signaling?.createRoom();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Current room is'),
                            content: Row(
                              children: [
                                Text(_roomId!),
                                SizedBox(width: 8.0),
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: _roomId));
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                        setState(() {
                          roomId = _roomId;
                          inCalling = true;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    height: 36.0,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color?>(
                            Theme.of(context).primaryColor),
                        foregroundColor:
                            MaterialStateProperty.all<Color?>(Colors.white),
                      ),
                      label: Text('JOIN ROOM'),
                      icon: Icon(Icons.people),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Join room'),
                            content: Column(
                              children: [
                                Text('Enter ID for room to join:'),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 200.0,
                                  child: TextField(
                                    controller: _joinRoomTextEditingController,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: Text('CANCEL'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('JOIN'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                        if (_joinRoomTextEditingController.text.isNotEmpty) {
                          await signaling?.joinRoombyId(
                              _joinRoomTextEditingController.text);
                          setState(() {
                            inCalling = true;
                            roomId = _joinRoomTextEditingController.text;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
