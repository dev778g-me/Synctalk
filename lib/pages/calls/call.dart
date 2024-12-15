import 'package:chat/calls/webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

final Callswebrtc webrtc = Callswebrtc();

class _CallState extends State<Call> {
  @override
  void initState() {
    super.initState();
    webrtc.initrenders();
    webrtc.startlocalstream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: RTCVideoView(
            webrtc.localRenderer,
            mirror: true,
          )),
          Expanded(child: RTCVideoView(webrtc.remoteRenderer)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await webrtc.createpeerconnection();
                  await webrtc.createoffer(); // Step 2: Peer A creates an offer
                  await webrtc
                      .listenforanswer(); // Step 5: Peer A listens for Peer B's answer
                },
                child: Text('Start Call (Peer A)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await webrtc.createpeerconnection();
                  await webrtc
                      .listenoffer(); // Step 3: Peer B listens for offer
                  await webrtc
                      .listenforicecandidate(); // Step 6: Exchange ICE Candidates
                },
                child: Text('Join Call (Peer B)'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
