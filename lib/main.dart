import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _offer = false;
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;
  final _localRenderer = new RTCVideoRenderer();
  final _remoteRenderer = new RTCVideoRenderer();
  TextEditingController sdpController = new TextEditingController();

  @override
  void initState() {
    initRenderes();
    // _createPeerConnection().then((pc) {
    //   _peerConnection = pc;
    // });
    _getUserMedia();
    super.initState();
  }

  initRenderes() async {
    await _localRenderer.initialize();
  }

  // _createPeerConnection() async {
  //   Map<String, dynamic> configuration = {
  //     'iceServers': [
  //       {'url': 'stun:stun.l.google.com:19302'},
  //     ]
  //   };

  //   final Map<String, dynamic> offerSdpConstraints = {
  //     'mandatory': {
  //       "OfferToReceiveAudio": true,
  //       "OfferToReceivevideo": true,
  //     },
  //   };

  //   _localStream = await _getUserMedia();

  //   RtcPeerConnection pc =
  //       await createPeerConnection(configuration, offerSdpConstraints);

  //   pc.addStream(_localStream);

  //   pc.onIceCandidate = (e) {
  //     if(e.candidate != null){
  //       printf(json.encode)
  //     }
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = stream;
  }

  SizedBox videoRenderer() => SizedBox(
        height: 210,
        child: Row(
          children: [
            Flexible(
              child: Container(
                key: Key('local'),
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                decoration: BoxDecoration(color: Colors.black),
                child: RTCVideoView(
                  _localRenderer,
                  mirror: true,
                ),
              ),
            ),
            Flexible(
              child: Container(
                key: Key('romte'),
                margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                decoration: BoxDecoration(color: Colors.black),
                child: RTCVideoView(
                  _remoteRenderer,
                ),
              ),
            ),
          ],
        ),
      );

  Row offerAndAnswerButton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: null,
            child: Text('Offer'),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('Answer'),
          ),
        ],
      );

  Padding sdpCandidateTF() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: sdpController,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),
      );

  Row sdpCandidateButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: null, //_setRemoteDescription,
            child: Text('Set Remote DESC'),
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('Set Candidte'),
          )
        ],
      );

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("WebRTC"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: [
              videoRenderer(),
              offerAndAnswerButton(),
              sdpCandidateTF(),
              sdpCandidateButtons(),
            ],
          ),
        ));
  }
}
