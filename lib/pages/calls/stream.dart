import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class Streamcall extends StatefulWidget {
  const Streamcall({super.key});

  @override
  State<Streamcall> createState() => _StreamcallState();
}

class _StreamcallState extends State<Streamcall> {
  final clent = StreamVideo('mmhfdzb5evj2',
      user: User.regular(userId: 'userId', role: 'admin', name: 'dev'),
      userToken:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL1Bsb19Lb29uIiwidXNlcl9pZCI6IlBsb19Lb29uIiwidmFsaWRpdHlfaW5fc2Vjb25kcyI6NjA0ODAwLCJpYXQiOjE3MzcyMzIwMjQsImV4cCI6MTczNzgzNjgyNH0.NUE_FqL0Tqbc56OkFM47V2CSn7fq-fKupnfzECjB13g');

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
