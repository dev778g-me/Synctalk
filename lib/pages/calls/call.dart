import 'package:chat/calls/webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  Signaling signaling = Signaling();
  final RTCVideoRenderer _localrendrer = RTCVideoRenderer();
  final RTCVideoRenderer _remoterendeer = RTCVideoRenderer();
  String? roomid;
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  @override
  void initState() {
    _localrendrer.initialize().then((_) {
      setState(() {});
    }).catchError((error) {
      print('Error while initializing the local renderer: $error');
    });
    _remoterendeer.initialize().then((_) {
      setState(() {});
    }).catchError((errorz) {
      print('Erroe while initializing remote rerndre : $errorz');
    });
    signaling.openusermedia(_localrendrer, _remoterendeer);

    signaling.onAddRemoteStream = ((stream) {
      _remoterendeer.srcObject = stream;
      if (mounted) {
        setState(() {});
      }

      super.initState();
    });
  }

  @override
  void dispose() {
    _localrendrer.dispose();
    _remoterendeer.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('calling'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    signaling.openusermedia(_localrendrer, _remoterendeer);
                    setState(() {});
                  },
                  child: const Icon(Icons.camera_alt)),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                  onPressed: () async {
                    roomid = await signaling.createroom(_remoterendeer);
                    textEditingController.text = roomid!;
                    setState(() {});
                  },
                  child: const Icon(Icons.add_call)),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  // Add roomId
                  signaling.joinRoom(
                    textEditingController.text.trim(),
                    _remoterendeer,
                  );
                },
                child: const Text("Join room"),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                  onPressed: () {
                    signaling.hangup(_localrendrer);
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.call_end))
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localrendrer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoterendeer)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }
}
