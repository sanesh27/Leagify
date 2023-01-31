import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leagify/services/api_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MatchDetails extends StatefulWidget {
  const MatchDetails({Key? key, required this.matchId}) : super(key: key);
  final int matchId;

  @override
  State<MatchDetails> createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  String videoURL = 'https://youtu.be/pOk9WMe0USQ';
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _getVideoURL();
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(builder: (context, constraints) {
        double height = constraints.maxHeight;
        double width = constraints.maxWidth;
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.arrow_back_ios)),
                ),

                Expanded(
                  flex: 6,
                  child: FutureBuilder(
                      future: _getVideoURL(),
                      builder: (context, snapshot){

                        if (snapshot.hasData) {
                          return YoutubePlayer(
                            aspectRatio: (height - 20)/width,
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            onReady: () {
                              // _controller.seekTo(Duration(seconds: 100));
                              // setState(() {
                              //   _controller.load(_getVideoURL(),startAt: 100);
                              //   _controller.play();



                            });

        }
                         else {
                          return const Center(
                              child: Text('No Match Details Yet'));
                        }
                      }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _getVideoURL() async {
    videoURL = await APIService.getMatchDetails(widget.matchId);
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(

          autoPlay: false,
        ));
    return videoURL;
  }
}
