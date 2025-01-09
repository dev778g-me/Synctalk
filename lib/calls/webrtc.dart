// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef void StreamStateCallback(MediaStream stream);

class Signaling {
  Map<String, dynamic> configuration = {
    "iceServers": [
      {
        "urls": [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };
  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print("ice conncetion state changed : $state");
    };
    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('connection state changed : $state');
    };
    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('signaling state changed : $state');
    };
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print("ice conncetion state changed : $state");
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("add remote stream : ${stream}");
      if (peerConnection == null) {
        print("Error: peerConnection is null");
      }

      onAddRemoteStream?.call(stream);
      remotestream = stream;
    };
  }

  RTCPeerConnection? peerConnection;
  MediaStream? localstream;
  MediaStream? remotestream;
  String? roomid;
  String? currentroomtext;

  // Define the callback using the StreamStateCallback type
  StreamStateCallback? onAddRemoteStream;

  Future<String> createroom(RTCVideoRenderer remoterenderer) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomref = db.collection('rooms').doc();
    debugPrint("Create PeerConnection with configuratio : $configuration");
    peerConnection = await createPeerConnection(configuration);
    registerPeerConnectionListeners();
    localstream?.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localstream!);
    });

    //code for collecting ice candidates
    //1.create a firestore refrence for ice candidates
    var CallerCandidatesCollection = roomref.collection('callerCandidates');
    //2.set up ice candidate handler for caller
    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      print("got candidate :${candidate.toMap()}");
      //3.add ice candidate to firestore
      CallerCandidatesCollection.add(candidate.toMap());
    };
    //finish code for collecting ice candidate

    //code for creating room
    //1.create session description offer (sdp offer)
    RTCSessionDescription offer = await peerConnection!.createOffer();
    //2. set the offer as a local description
    await peerConnection!.setLocalDescription(offer);
    print('created offer:$offer');
    //3.create a room in firestore
    Map<String, dynamic> roomwithoffer = {"offer": offer.toMap()};
    //4.store the room in firestore
    await roomref.set(roomwithoffer);
    //5.get and store the room id
    var roomId = roomref.id;
    print("room created with sdk offer RoomID :$roomId");
    //6.update the room text in the ui
    currentroomtext = "cuurrent room is $roomId - you are the caller ";
    //created room
    peerConnection?.onTrack = (RTCTrackEvent event) {
      //logging the recived remote work
      print('got a remote track : ${event.streams[0]}');
      //itterete each track from the remote stream
      event.streams[0].getTracks().forEach((track) {
        //add the track to the remote stream
        remotestream?.addTrack(track);
      });
    };
    roomref.snapshots().listen((snapshot) async {
      //1.log the updated room data
      print('got the updated room : ${snapshot.data()}');
      //2.convert sanpshot into a map
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      //3.check if remote description is set and answer is present
      if (peerConnection?.getRemoteDescription() != null &&
          data["answer"] != null) {
        //4.create rtcsession description from the answer
        var answer = RTCSessionDescription(
            data['answer']['sdp'], data["answer"]['type']);
        print('someone tried to connect ');
        await peerConnection?.setRemoteDescription(answer);
      }
    });

    //listning to ice candidates
    //1.listen to firestore document
    roomref.collection("calleeid").snapshots().listen((snapshot) {
      //2.the docs change function list all the changes and for each loop itreates though the changes

      snapshot.docChanges.forEach((change) {
        //3.cheak the change type is added or not which indiactes a new ice candidate has been added
        if (change.type == DocumentChangeType.added) {
          //4.extracting the candidates data
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;

          print('got an ice candidate : ${jsonEncode(data)}');
          //5.adding icecandidates to peer conection
          peerConnection!.addCandidate(RTCIceCandidate(
              data["candidate"], data["sdpMid"], data['sdpMLineIndex']));
        }
      });
    });
    return roomId;
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remotevideo) async {
    //instance for firestore database
    FirebaseFirestore db = FirebaseFirestore.instance;
    print(roomId);
    DocumentReference roomref = db.collection('rooms').doc("$roomId");
    var roomSnapshot = await roomref.get();
    print('got room : ${roomSnapshot.exists}');
    if (!roomSnapshot.exists) {
      print('room does not exist');
      return;
    }
    if (roomSnapshot.exists) {
      peerConnection = await createPeerConnection(configuration);

      print("create peerconnection with configuration : $configuration");
      if (peerConnection != null) {
        registerPeerConnectionListeners();
      } else {
        print('connection is null ');
        return;
      }

//local stream means the local media obtained
//each media track will be added to the peerconnection using add track
      localstream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localstream!);
      });
      var callecandidatecollection = roomref.collection('callecandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          print('on icecandidate : complete');
          return;
        }
        print("on candidate : ${candidate.toMap()}");
        callecandidatecollection.add(candidate.toMap());
      };
      //code for collecting ice candidate
      //the on track event fires whenever a new media track is received from the remote peer
//the rtctrckevent provides details about the incoming media
      peerConnection?.onTrack = (RTCTrackEvent event) {
        //logs the  first media recieved
        print('got remote track : ${event.streams[0].toString()}');
        //itrates though all media tracks in the first stream
        event.streams[0].getTracks().forEach((track) {
          print('Add a track to remote stream :$track');
          remotestream?.addTrack(track);
          print('added track');
        });
      };
      //code for creating sdp answer below
      //retrives the room snapshot data sent by other peer
      var data = roomSnapshot.data() as Map<String, dynamic>;
      print('got offer : $data');
      //the offer contain the sdp offer from the firestore
      var offer = data["offer"];
      //seting remote description with offer
      await peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']));
      //creating answer
      var answer = await peerConnection!.createAnswer();
      print('created answer : $answer');
      //sdp answer is set as local description
      await peerConnection!.setLocalDescription(answer);
      //updating the room with answer
      Map<String, dynamic> roomwithanswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomref.update(roomwithanswer);
      //fininished creating answer
      //listing for remote ice candidates below
      //this setups a listener for firestore callerCandidate collection whenever a document is added modified or removed on this collection the listener is triggered

      roomref.collection('callerCandidates').snapshots().listen((snapshot) {
        //the docs change property contains all the changes
        snapshot.docChanges.forEach((document) {
//getting data od candidate
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('got new ice candidate:$data');
          peerConnection!.addCandidate(
            RTCIceCandidate(
                data['candidate'], data['sdpMid'], data['sdpMLineIndex']),
          );
        });
      });
    }
    //code for collecting ice candidates
  }

  Future<void> openusermedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    var stream = await navigator.mediaDevices
        .getUserMedia({"audio": true, "video": true});

    //the local video renderer is conected to the local stream
    localVideo.srcObject = stream;
    localstream = stream;
    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  Future<void> hangup(RTCVideoRenderer localVideo) async {
    //stop local media tracks
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });
    //stop remote stream tracks
    if (remotestream != null) {
      remotestream!.getTracks().forEach((track) {
        track.stop();
      });
    }
    if (peerConnection != null) {
      peerConnection!.close();
    }
    if (roomid != null) {
      var db = FirebaseFirestore.instance;
      var roomref = db.collection('rooms').doc(roomid);

      //deleting data from callecandiadte collection from firestore
      var calleCandidates = await roomref.collection('calleCandidates').get();
      calleCandidates.docs.forEach((document) => document.reference.delete);
      //deleting data from callercandidate collection from firestore
      var callerCandidates = await roomref.collection('callerCandidates').get();
      callerCandidates.docs.forEach((document) {
        document.reference.delete();
      });
      await roomref.delete();
    }
    localstream!.dispose();
    remotestream!.dispose();
  }
}
