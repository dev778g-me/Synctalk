// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// class Signaling {
//   final configuration = {
//     'iceServers': [
//       {'urls': 'stun:stun.l.google.com:19302'},
//     ],
//   };

//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   RTCPeerConnection? _peerConnection;

//   // Firestore instance and references
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late DocumentReference _callDoc; // Firestore document for the call
//   String? _callId; // Unique ID for the call session

//   Future<void> init() async {
//     await _localRenderer.initialize();
//     await _remoteRenderer.initialize();
//   }

//   RTCVideoRenderer get localRenderer => _localRenderer;
//   RTCVideoRenderer get remoteRenderer => _remoteRenderer;

//   // Create a peer connection with WebRTC
//   Future<RTCPeerConnection> createPeerConnection(
//       Map<String, List<Map<String, String>>> configuration) async {
//     final configuration = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//       ],
//     };

//     final peerConnection = await createPeerConnection(configuration);

//     // Send ICE candidates to Firestore
//     peerConnection.onIceCandidate = (candidate) {
//       if (_callId != null) {
//         _firestore
//             .collection('calls')
//             .doc(_callId)
//             .collection('iceCandidates')
//             .add(candidate.toMap());
//       }
//     };

//     peerConnection.onAddStream = (stream) {
//       _remoteRenderer.srcObject = stream;
//     };

//     return peerConnection;
//   }

//   // Start a new call (creates a Firestore document)
//   Future<void> createOffer() async {
//     _callId = DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID
//     _callDoc = _firestore.collection('calls').doc(_callId);

//     _peerConnection = await createPeerConnection(configuration);

//     // Get local media stream (audio/video)
//     final localStream = await navigator.mediaDevices.getUserMedia({
//       'audio': true,
//       'video': true,
//     });
//     _localRenderer.srcObject = localStream;
//     _peerConnection!.addStream(localStream);

//     // Create offer and send to Firestore
//     final offer = await _peerConnection!.createOffer();
//     await _peerConnection!.setLocalDescription(offer);

//     await _callDoc.set({
//       'offer': {'sdp': offer.sdp, 'type': offer.type},
//       'callerId': _callId,
//     });

//     // Listen for answers and ICE candidates
//     listenForAnswer();
//     listenForRemoteIceCandidates();
//   }

//   // Join an existing call using a call ID
//   Future<void> joinCall(String callId) async {
//     _callId = callId;
//     _callDoc = _firestore.collection('calls').doc(_callId);

//     _peerConnection = await createPeerConnection(configuration);

//     // Listen for the offer from Firestore
//     final offerSnapshot = await _callDoc.get();
//     final offerData = offerSnapshot.data() as Map<String, dynamic>;
//     final offer = RTCSessionDescription(
//       offerData['offer']['sdp'],
//       offerData['offer']['type'],
//     );

//     await _peerConnection!.setRemoteDescription(offer);

//     // Create answer and send to Firestore
//     final answer = await _peerConnection!.createAnswer();
//     await _peerConnection!.setLocalDescription(answer);

//     await _callDoc.update({
//       'answer': {'sdp': answer.sdp, 'type': answer.type},
//     });

//     // Listen for ICE candidates
//     listenForRemoteIceCandidates();
//   }

//   // Listen for incoming answers
//   void listenForAnswer() {
//     _callDoc.snapshots().listen((snapshot) async {
//       final data = snapshot.data() as Map<String, dynamic>;
//       if (data.containsKey('answer')) {
//         final answer = RTCSessionDescription(
//           data['answer']['sdp'],
//           data['answer']['type'],
//         );
//         await _peerConnection!.setRemoteDescription(answer);
//       }
//     });
//   }

//   // Listen for remote ICE candidates
//   void listenForRemoteIceCandidates() {
//     _callDoc.collection('iceCandidates').snapshots().listen((snapshot) {
//       for (final doc in snapshot.docs) {
//         final data = doc.data();
//         final candidate = RTCIceCandidate(
//           data['candidate'],
//           data['sdpMid'],
//           data['sdpMLineIndex'],
//         );
//         _peerConnection!.addCandidate(candidate);
//       }
//     });
//   }

//   void dispose() {
//     _peerConnection?.close();
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     if (_callId != null) {
//       _firestore.collection('calls').doc(_callId).delete(); // Cleanup
//     }
//   }
// }
