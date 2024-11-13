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
      if (candidate != null) {
        //TODO
      }
    };
    _peerConnection!.onAddStream = (stream) {
      _remoterenderer.srcObject = stream;
    };
    _peerConnection!.addStream(_localstream!);
  }
}
