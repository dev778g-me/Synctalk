import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Signaling {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? _roomId;
  Map<String, dynamic> _configurationServer = {
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

  final Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };

  late RTCPeerConnection _rtcPeerConnection;
  late MediaStream _localStream;
  late Function(MediaStream stream) onLocalStream;
  late Function(MediaStream stream) onAddRemoteStream;
  late Function() onRemoveRemoteStream;
  late Function() onDisconnect;

  Future<String?> createRoom() async {
    final roomRef = db.collection('rooms').doc();
    _roomId = roomRef.id;

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    });
    onLocalStream.call(_localStream);

    _rtcPeerConnection = await createPeerConnection(_configurationServer);

    registerPeerConnectionListeners();

    _localStream.getTracks().forEach((track) {
      _rtcPeerConnection.addTrack(track, _localStream);
    });

    // Code for collecting ICE candidates below
    final callerCandidatesCollection = roomRef.collection('callerCandidates');

    _rtcPeerConnection.onIceCandidate = ((candidate) {
      if (candidate == null) {
        print('Got final candidate!');
        return;
      }
      final candidateMap = candidate.toMap();
      print('Got candidate: $candidateMap');
      callerCandidatesCollection.add(candidateMap);
    });
    // Code for collecting ICE candidates above

    // Code for creating a room below
    final offer = await _rtcPeerConnection.createOffer(offerSdpConstraints);
    await _rtcPeerConnection.setLocalDescription(offer);
    print('Created offer: ${offer.toMap()}');

    final roomWithOffer = {
      'offer': offer.toMap(),
    };
    await roomRef.set(roomWithOffer);
    print('New room created with SDP offer. Room ID: ${roomRef.id}');
    // Code for creating a room above

    _rtcPeerConnection.onTrack = (RTCTrackEvent event) {
      onAddRemoteStream.call(event.streams[0]);
      print('Got remote track: ${event.streams[0]}');
    };

    // Listening for remote session description below
    roomRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (data != null && data.containsKey('answer')) {
        print('Got remote description: ${data["answer"]}');
        final rtcSessionDescription = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );
        await _rtcPeerConnection.setRemoteDescription(rtcSessionDescription);
      }
    });
    // Listening for remote session description above

    // Listen for remote ICE candidates below
    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) async {
      snapshot.docChanges.forEach((change) async {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          print('Got new remote ICE candidate: $data');
          await _rtcPeerConnection.addCandidate(RTCIceCandidate(
            data?['candidate'],
            data?['sdpMid'],
            data?['sdpMlineIndex'],
          ));
        }
      });
    });
    // Listen for remote ICE candidates above

    return _roomId;
  }

  Future<void> joinRoomById(String roomId) async {
    _roomId = roomId;
    print('Join room: $_roomId');
    final roomRef = db.collection('rooms').doc(_roomId);
    final roomSnapshot = await roomRef.get();
    print('Got room: ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $_configurationServer');

      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': {
          'facingMode': 'user',
        },
      });
      onLocalStream.call(_localStream);

      _rtcPeerConnection = await createPeerConnection(_configurationServer);
      registerPeerConnectionListeners();
      _localStream.getTracks().forEach((MediaStreamTrack track) {
        _rtcPeerConnection.addTrack(track, _localStream);
      });

      // Code for collecting ICE candidates below
      final calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      _rtcPeerConnection.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate != null) {
          print('Got final candidate!');
          return;
        }
        print('Got candidate: ${candidate.candidate}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidates above

      _rtcPeerConnection.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        if (event.track.kind == 'video')
          onAddRemoteStream.call(event.streams[0]);
      };

      // Code for creating SDP answer below
      final offer = roomSnapshot.data()?['offer'];
      print('Got offer: $offer');
      await _rtcPeerConnection.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']));
      final RTCSessionDescription answer =
          await _rtcPeerConnection.createAnswer(offerSdpConstraints);
      print('Created answer: ${answer.toMap()}');
      await _rtcPeerConnection.setLocalDescription(answer);

      final roomWithAnswer = {
        'answer': answer.toMap(),
      };
      await roomRef.update(roomWithAnswer);
      // Code for creating SDP answer above

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) async {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data();
            print('Got new remote ICE candidate: $data');
            await _rtcPeerConnection.addCandidate(RTCIceCandidate(
              data?['candidate'],
              data?['sdpMid'],
              data?['sdpMlineIndex'],
            ));
          }
        });
      });
      // Listening for remote ICE candidates above
    }
  }

  void muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream.getAudioTracks()[0].enabled;
      _localStream.getAudioTracks()[0].enabled = !enabled;
    }
  }

  Future<void> hungUp() async {
    _localStream.getTracks().forEach((track) {
      track.stop();
    });

    onRemoveRemoteStream();

    if (_rtcPeerConnection != null) {
      _rtcPeerConnection.close();
    }

    // Delete room on hangup
    if (_roomId != null) {
      final roomRef = db.collection('rooms').doc(_roomId);
      final calleeCandidates =
          await roomRef.collection('calleeCandidates').get();
      calleeCandidates.docs.forEach((candidate) async {
        await candidate.reference.delete();
      });
      final callerCandidates =
          await roomRef.collection('callerCandidates').get();
      callerCandidates.docs.forEach((candidate) async {
        await candidate.reference.delete();
      });
      await roomRef.delete();
    }
  }

  void registerPeerConnectionListeners() {
    _rtcPeerConnection.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    _rtcPeerConnection.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        _localStream.getTracks().forEach((track) {
          track.stop();
        });

        onRemoveRemoteStream();

        if (_rtcPeerConnection != null) {
          _rtcPeerConnection.close();
        }

        onDisconnect();
      }
    };

    _rtcPeerConnection.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    _rtcPeerConnection.onIceConnectionState = (RTCIceConnectionState state) {
      print('ICE connection state change: $state');
    };
  }
}
