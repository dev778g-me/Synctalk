// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Webrtcsignaling {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? _roomId;

  final Map<String, dynamic> _configurationServer = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
        ]
      },
    ],
    'sdpSemantics': 'unified-plan',
  };

  final Map<String, dynamic> offersdpConstraints = {
    "mandatory": {
      "offerToReceiveAudio": true,
      "offerToReciveVideo": true,
    },
    "optional": [],
  };

  late RTCPeerConnection _rtcPeerConnection;
  late MediaStream _localStream;
  late Function(MediaStream stream) onLocalstream;
  late Function(MediaStream stream) onAddRemotestream;
  late Function() onRemoveRemoteStream;
  late Function() onDisconnect;

  //creating room

  Future<String?> createRoom() async {
    final roomRef = db.collection('rooms').doc();
    _roomId = roomRef.id;
    _localStream = await navigator.mediaDevices.getUserMedia({
      "audio": true,
      "video": {"facingMode": "user"}
    });
    onLocalstream.call(_localStream);

    _rtcPeerConnection = await createPeerConnection(_configurationServer);
    registerPeerconnectionListners();

    _localStream.getTracks().forEach((track) {
      _rtcPeerConnection.addTrack(track, _localStream);
    });

    //code for collecting ice candidates below
    final callerCandidatesCollection = roomRef.collection('callerCandidates');

    _rtcPeerConnection.onIceCandidate = ((candidate) {
      if (candidate == null) {
        debugPrint('got final candidate ');
        return;
      }

      final candidateMap = candidate.toMap();
      debugPrint("got candidate map : $candidateMap");
      callerCandidatesCollection.add(candidateMap);
      //code for collectin ice candidate above
    });

    //code for creating a room below
    final offer = await _rtcPeerConnection.createOffer();
    await _rtcPeerConnection.setLocalDescription(offer);

    debugPrint('Created offer : ${offer.toMap()}');

    final roomWithOffer = {"offer": offer.toMap()};

    await roomRef.set(roomWithOffer);
    debugPrint('New room created with SDP offer Roomid : ${roomRef.id}');
    //code for creating a room above
    _rtcPeerConnection.onTrack = (RTCTrackEvent event) {
      onAddRemotestream.call(event.streams[0]);
      debugPrint('Got remote track : ${event.streams[0]}');
    };

    //listen for remote session desc below
    roomRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (data != null && data.containsKey('answer')) {
        debugPrint("got remote description : ${data["answer"]}");

        final rtcsessiondescription = RTCSessionDescription(
            data["answer"]["sdp"], data["answer"]["type"]);

        await _rtcPeerConnection.setRemoteDescription(rtcsessiondescription);
      }
    });
    // Listening for remote session description above

    //listning for remote ice candidates

    roomRef.collection('calleCandidates').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) async {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          debugPrint("Got remote ICE  candidates : $data");
          await _rtcPeerConnection.addCandidate(RTCIceCandidate(
              data?['candidate'], data?['sdpMid'], data?['sdpMLineIndex']));
        }
      });
    });
    //listning for remote ice candidates above

    return _roomId;
  }

  Future<void> joinRoombyId(String roomId) async {
    _roomId = roomId;
    debugPrint("join room $roomId");

    final roomRef = db.collection('rooms').doc(_roomId);
    final roomSnapshot = await roomRef.get();
    debugPrint("Got room : ${roomSnapshot.exists}");

    if (roomSnapshot.exists) {
      debugPrint(
          'Create Peerconnection with configuration : $_configurationServer');
      _localStream = await navigator.mediaDevices.getUserMedia({
        "audio": true,
        "video": {"facingMode": "user"}
      });
      onLocalstream.call(_localStream);

      _rtcPeerConnection = await createPeerConnection(_configurationServer);
      registerPeerconnectionListners();
      _localStream.getTracks().forEach((MediaStreamTrack track) {
        _rtcPeerConnection.addTrack(track, _localStream);
      });

      //code for collecting ice candidates below
      final calleeCandidatesCollection = roomRef.collection("calleeCandidates");
      _rtcPeerConnection.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate != null) {
          debugPrint("got final candidate");
          return;
        }
        debugPrint("Got Candidate : ${candidate.candidate}");
        calleeCandidatesCollection.add(candidate.toMap());
      };
      //code for collecting ice candidates above

      _rtcPeerConnection.onTrack = (RTCTrackEvent event) {
        if (event.track.kind == "video") {
          onAddRemotestream.call(event.streams[0]);
        }
      };

      //code for creating SDP answer below
      final offer = roomSnapshot.data()?["offer"];
      debugPrint("got offer : $offer");
      await _rtcPeerConnection.setRemoteDescription(
          RTCSessionDescription(offer["sdp"], offer["type"]));
      final RTCSessionDescription answer =
          await _rtcPeerConnection.createAnswer(offersdpConstraints);

      debugPrint("created Answer : ${answer.toMap()}");
      await _rtcPeerConnection.setLocalDescription(answer);
      final roomWithAnswer = {'answer': answer.toMap()};
      await roomRef.update(roomWithAnswer);

      //code for creating SDp answer above

      //listning for remote ice candidates below
      roomRef.collection("callerCandidates").snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) async {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data();
            debugPrint('Got remote ice candidate : $data');
            await _rtcPeerConnection.addCandidate(RTCIceCandidate(
                data?['candidate'], data?['sdpMid'], data?['sdpMLineIndex']));
          }
        });
      });
      //listning for remote ice candidates above
    }
  }

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream.getAudioTracks()[0].enabled;
      _localStream.getAudioTracks()[0].enabled = !enabled;
    }
  }

  Future<void> hangUp() async {
    _localStream.getTracks().forEach((track) {
      track.stop();
    });
    onRemoveRemoteStream();

    if (_rtcPeerConnection != null) {
      _rtcPeerConnection.close();
    }

    if (_rtcPeerConnection != null) {
      final roomRef = db.collection("rooms").doc(_roomId);
      final callecandidates =
          await roomRef.collection('calleeCandidates').get();
      callecandidates.docs.forEach((candidate) async {
        await candidate.reference.delete();
      });

      final callercandidates =
          await roomRef.collection('callerCandidates').get();
      callercandidates.docs.forEach((change) async {
        await change.reference.delete();
      });
      await roomRef.delete();
    }
  }

  void registerPeerconnectionListners() {
    _rtcPeerConnection.onIceGatheringState = (RTCIceGatheringState state) {
      debugPrint('Ice gathering State Changed $state');
    };

    _rtcPeerConnection.onConnectionState = (RTCPeerConnectionState state) {
      debugPrint("Connection State Changed $state");
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        _localStream.getTracks().forEach((track) {
          track.stop();
        });

        onRemoveRemoteStream();

        // ignore: unnecessary_null_comparison
        if (_rtcPeerConnection != null) {
          _rtcPeerConnection.close();
        }

        onDisconnect();
      }
    };

    _rtcPeerConnection.onSignalingState = (RTCSignalingState state) {
      debugPrint("Signaling state change : $state");
    };

    _rtcPeerConnection.onIceConnectionState = (RTCIceConnectionState state) {
      debugPrint("ICE Conection state change : $state");
    };
  }
}
