import 'package:chat/pages/calls/service/webrtcsignaling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final Signaling _signaling = Signaling();
  final TextEditingController _callIdController = TextEditingController();
  String _currentCallId = '';
  bool _isInCall = false;

  @override
  void initState() {
    super.initState();
    _signaling.init();
  }

  @override
  void dispose() {
    _signaling.dispose();
    super.dispose();
  }

  void _startCall() async {
    try {
      await _signaling.createOffer();
      setState(() {
        ;
        _isInCall = true;
      });
    } catch (e) {
      print('Error starting call: $e');
    }
  }

  void _joinCall() {
    if (_callIdController.text.isEmpty) return;
    _signaling.joinCall(_callIdController.text);
    setState(() {
      _isInCall = true;
    });
  }

  void _endCall() {
    _signaling.dispose();
    setState(() {
      _isInCall = false;
      _currentCallId = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore WebRTC Call'),
      ),
      body: _isInCall ? _inCallUI() : _preCallUI(),
    );
  }

  Widget _preCallUI() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _startCall,
            child: Text('Start New Call'),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
          ),
          SizedBox(height: 30),
          Text('OR', style: TextStyle(fontSize: 18)),
          SizedBox(height: 30),
          TextField(
            controller: _callIdController,
            decoration: InputDecoration(
              labelText: 'Enter Call ID',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _joinCall,
            child: Text('Join Call'),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
          ),
        ],
      ),
    );
  }

  Widget _inCallUI() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              RTCVideoView(_signaling.remoteRenderer),
              Positioned(
                right: 20,
                top: 20,
                child: Container(
                  width: 120,
                  height: 180,
                  child: RTCVideoView(_signaling.localRenderer),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text('Call ID: $_currentCallId', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _endCall,
                child: Text('End Call'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
