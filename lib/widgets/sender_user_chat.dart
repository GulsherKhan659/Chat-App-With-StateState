import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

class SenderUserChat extends StatefulWidget {
  final chatmessage,time,isLike,function,isText;
  SenderUserChat ({this.chatmessage,this.time,this.isLike,this.function,this.isText});

  @override
  _SenderUserChatState createState() => _SenderUserChatState();
}

class _SenderUserChatState extends State<SenderUserChat> {
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  bool _isPlay = true;

  @override
  void initState() {
    super.initState();
    _mPlayer!.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    stopPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    _mPlayer!.closeAudioSession();
    _mPlayer = null;

    super.dispose();
  }

  // -------  Here is the code to playback a remote file -----------------------

  void splay(final url) async {
    await _mPlayer!.startPlayer(
        fromURI:url,

        whenFinished: () {
          setState(() {});
        });
    setState(() {});
  }
  Future<void> stopPlayer() async {
    if (_mPlayer != null) {
      await _mPlayer!.stopPlayer();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(

            margin:EdgeInsets.symmetric(vertical: 10) ,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10),)
            ),
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.time),
                SizedBox(height: 5),
                widget.isText ?

                Text(widget.chatmessage):
                _isPlay? IconButton(

                    onPressed: ()async{
                      print(widget.chatmessage);
                      setState(() {
                        _isPlay=false;
                      });
                      //               await _audio.play(url:chatmessage);
                      // TODO: Apply Audio Player
                      splay(widget.chatmessage);
                    }, icon:Icon(Icons.play_arrow)):
                IconButton(

                    onPressed: ()async{
                      stopPlayer();
                      setState(() {
                        _isPlay = true;
                      });
                    }, icon:Icon(Icons.stop))

              ],
            ),
            ),
          SizedBox(width: 10,),
          IconButton(onPressed:widget.function,
          icon:widget.isLike ?Icon(Icons.favorite,color: Colors.red,):Icon(Icons.favorite_border),
          )

        ],
      ),
    );
  }
}
