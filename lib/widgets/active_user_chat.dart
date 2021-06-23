import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
class ActiveUserChat extends StatefulWidget {
  final chatmessage,time,isText;
  ActiveUserChat ({this.chatmessage,this.time,this.isText});

  @override
  _ActiveUserChatState createState() => _ActiveUserChatState();
}

class _ActiveUserChatState extends State<ActiveUserChat> {
  @override
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
  Widget build(BuildContext context) {
  //AudioRecordPlayer _audio = AudioRecordPlayer();
    return Container(
      alignment: Alignment.centerRight,
      child: Container(

      margin:EdgeInsets.symmetric(vertical: 10) ,
      width: 250,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),)
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
    );
  print(widget.chatmessage);
  }
}
