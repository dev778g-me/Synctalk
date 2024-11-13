import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Webrtc {
  final _localrenderer = RTCVideoRenderer(); //local video renderer
  final _remoterenderer = RTCVideoRenderer(); //remote video renderer
  RTCPeerConnection?
      _peerConnection; //peer connection responsiable for excahnging media
  MediaStream?
      _localstream; //local media stream   will contain the audio and video stream captured from the user’s device
  Future<void> initrenders() async {
    // initializes local and remote video renderers
    await _localrenderer.initialize();
    //initialize() sets up rtc videorenderer instance to get ready to rendder video
    //this function needs to be called before attaching any video streams
    await _remoterenderer.initialize();
  }

  Future<void> startlocalstream() async {
    _localstream = await navigator.mediaDevices.getUserMedia({
      "audio": true,
      "video": true,
    }); // funtion of webrtc that access user media devices such as camera mic
    _localrenderer.srcObject = _localstream;
  }

  Future<void> createpeerconnection() async {
    _peerConnection = await createPeerConnection({
      "iceServers": [
        {'url': 'stun:stun.l.google.com:19302'}
      ]
    });
    _peerConnection!.onIceCandidate = (candidate) {
      // ignore: unnecessary_null_comparison
      if (candidate != null) {
        //dIceCandidateToFirebase(candidate);
      }
    };
    _peerConnection!.onAddStream = (stream) {
      _remoterenderer.srcObject = stream;
    };
    _peerConnection!.addStream(_localstream!);
  }

  Future<void> createoffer() async {
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    _peerConnection!.setLocalDescription(offer);
    await FirebaseFirestore.instance.collection("calls").doc("first").set({
      "offer": {"type": offer.type, "sdp": offer.sdp}
    });
  }

  Future<void> listenoffer() async {
    FirebaseFirestore.instance
        .collection('calls')
        .doc("first")
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists && snapshot.data()!["offer"] != null) {
        var offer = snapshot.data()!['offer'];

        RTCSessionDescription remoteoffer =
            RTCSessionDescription(offer["sdp"], offer["type"]);
        RTCSessionDescription answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        await FirebaseFirestore.instance
            .collection('calls')
            .doc("first")
            .update({
          "answer": {
            "type": answer.type,
            "sdp": answer.sdp,
          }
        });
      }
    });
  }

  Future<void> listenforanswer() async {
    FirebaseFirestore.instance
        .collection('calls')
        .doc('first')
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists && snapshot.data()!["answer"] != null) {
        var answer = snapshot.data()!['answer'];
        RTCSessionDescription remoteanswar =
            RTCSessionDescription(answer['sdp'], answer['type']);
        _peerConnection!.setRemoteDescription(remoteanswar);
      }
    });
  }

  Future<void> addIcecandidatetofirebase(RTCIceCandidate candidate) async {
    await FirebaseFirestore.instance
        .collection("calls")
        .doc("first")
        .collection("ice")
        .add({
      "candidate ": candidate.candidate,
      "sdpmin": candidate.sdpMid,
      "sdpmaxlineindex": candidate.sdpMLineIndex,
    });
  }
}
