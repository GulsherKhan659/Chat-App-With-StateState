import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data_resourse/send_and_recive_messages.dart';
import '../data_resourse/send_and_recive_user.dart';
import '../model/message_model_class.dart';
import '../services/audio_record.dart';
import '../util/date_time_format.dart';
import '../widgets/sender_user_chat.dart';
import 'active_user_chat.dart';
class ChatMessageDisplayCard extends StatefulWidget {
  final  reciverId,reciverName;
  ChatMessageDisplayCard({this.reciverId,this.reciverName});

  @override
  _ChatMessageDisplayCardState createState() => _ChatMessageDisplayCardState();
}

class _ChatMessageDisplayCardState extends State<ChatMessageDisplayCard> {
    TextEditingController _sendMessagesController = TextEditingController();

    @override
  Widget build(BuildContext context) {


    final sender = SendAndReciveDataFromFireStore.data[0];

    /// Variable is create just to check which user is online
    final _currentUserId = sender.id.toString();


    /// Method  to check who is open the app
    // ignore: close_sinks


    _ifSenderOpenChat(){
      return FirebaseFirestore.instance.collection("messages")

          .where("reciverId",isEqualTo: widget.reciverId)
          .where("senderId",isEqualTo: _currentUserId)
          .orderBy("time",descending: false)
          .snapshots();

     }
    _ifReciverOpenChat() {
      return FirebaseFirestore.instance.collection("messages")

          .where("reciverId",isEqualTo: _currentUserId)
          .where("senderId",isEqualTo: widget.reciverId)
          .orderBy("time",descending: false)
          .snapshots();

    }


    List<Message> _getData=[];

    return ClipRRect(
      borderRadius:BorderRadius.only(topLeft:Radius.circular(30),topRight:Radius.circular(30),),
     child: Container(
       height: double.infinity,
       width: double.infinity,
   color:Colors.white,
       child: Column(children: [
         Expanded(
            child:StreamBuilder(
                stream: _ifSenderOpenChat(),
                builder: (context,AsyncSnapshot<QuerySnapshot>snapshot1){
                  if(snapshot1.hasData){
                   var data1 = snapshot1.data!.docs;
                   data1.forEach((item) {
                     Message message = Message.fromJson(json:item.data());
                     var i = _getData.indexWhere((x) => x.time == message.time);
                     if (i <= -1) {
                       _getData.add(message);
                       _getData.sort((a, b) => a.time.compareTo(b.time));
                     }
                   });

    //               _saveBothChats.addAll(getData);

                   return StreamBuilder(
                     stream: _ifReciverOpenChat(),
                      builder: (context,AsyncSnapshot<QuerySnapshot>snapshot2) {
                       if(snapshot2.hasData){
                       var data2 = snapshot2.data!.docs;
                       data2.forEach((item) {
                         Message message = Message.fromJson(json:item.data());
                         var i = _getData.indexWhere((x) => x.time == message.time);
                         if (i <= -1) {
                           _getData.add(message);
                           _getData.sort((a, b) => a.time.compareTo(b.time));
                         }
                       });

                       if(_getData.length > 0){

                        return ListView.builder(
                        reverse: false,
                          itemCount: _getData.length,
                          itemBuilder: (context,index){
                          var message = _getData[index];
                        /// User To Format date Time
                        var time = FormatDate.converTimestampToDateTime(
                            timeStamp: message.time
                          );
                        if(message.senderId != _currentUserId) {

                  return SenderUserChat(
                       function: (){},
                        isText: message.isText,
                       isLike:message.isLiked,
                        chatmessage: message.text,
                       time:time,
                       );

         }
                 return ActiveUserChat(
                            isText:message.isText,
                            chatmessage:message.text ,
                            time:"$time" ,
                           );

                          });
                       }else{
                         return Container();
                       }
                     }else{
                         return Container();
                       }}
                   );


                 }else{
                   print("No Data");
                   return Container();
                 }

                },

            ),
         ),
         Container(
           padding: const EdgeInsets.symmetric(vertical: 15),
           child: SendChatMessageBar(
             reciverId: widget.reciverId,
             reciverName: widget.reciverName,
             messageController: _sendMessagesController,
           ),
         ),
       ],),
     ),
    );

  }
}


class SendChatMessageBar extends StatefulWidget {
  final TextEditingController? messageController;
  final String? reciverName,reciverId;
  SendChatMessageBar({this.messageController,this.reciverName,this.reciverId});

  @override
  _SendChatMessageBarState createState() => _SendChatMessageBarState();
}

class _SendChatMessageBarState extends State<SendChatMessageBar>  {

  bool _isRecorded = false;
  bool _isCancel = false;
  bool _isTypeVoice = true;
   double _dragBoxSize=45;
  int _timerSeconds=0;
  int _timerMinutes=0;
  String _recordedTime ="00 : 00";
  Timer? _counterTimer;
  AudioRecording _audioRecording = AudioRecording();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  _methodToChangeMicIcon(String onchangedValue){
    if(onchangedValue.isEmpty){
      _isTypeVoice =true;
    }else{
      _isTypeVoice = false;
    }
    setState(() {

    });

  }



  @override
  Widget build(BuildContext context) {
    return  Container(
       width: double.infinity,
     // color:Colors.orange,
      child: Row(
        children: [

         _isRecorded ?Container(): Expanded(
              flex: 1,
              child: Icon(Icons.image,color: Colors.black,size: 30,)),
          _isRecorded ?Expanded(
            flex: 7,
            child: Container(
           //   color: Colors.grey.shade100,
           child: Row(children: [
             Container(
               // width: double.infinity,
               // height: double.infinity,
               margin: EdgeInsets.only(
                 left: 15
               ),
              padding:EdgeInsets.all(10),
               child: FittedBox(
                 child: Text(_recordedTime,style: TextStyle(color: Colors.white,)
                 ),
               ),
               decoration: BoxDecoration(
                 color: Colors.black,
               //  borderRadius: BorderRadius.circular(10),
               ),

             ),
             SizedBox(width: 3,),
             Column(
               mainAxisAlignment: MainAxisAlignment.end,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Container(
                   height: 10,
                   width: 10,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     color:Colors.red,
                   ),
                 ),
                 Text("Recording..."),
               ],
             ),
             Spacer(),
            Text("Slide To Cancel",style: TextStyle(
              color: Colors.black,
              //fontSize: 18,
              fontWeight: FontWeight.w600,
            )),


           ],),
            ),
          ):Expanded(
            flex: 5,
            child: TextField(
               controller: widget.messageController,
              //onTap:()=>function,
              onChanged: (value){
                 _methodToChangeMicIcon(value);
                 setState(() {

                 });
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(

                focusedBorder: InputBorder.none,
                border: InputBorder.none,
               // prefixIcon: Icon(Icons.image,color: Colors.black,),
                hintText: "Send a message....",

              ),
            ),
          ),
          _isRecorded ?Container():Expanded(
              flex: 1,
              child: Icon(Icons.attach_file,color: Colors.black,size: 30,)),

          Expanded(
              flex: 2,
              child:_isTypeVoice ?

              GestureDetector(

                onLongPressStart: (lg){
                  _audioRecording.init().whenComplete(() => _audioRecording.start());

                  setState(() {
                       _isRecorded = true;
                     });
                  _counterTimer = Timer.periodic(Duration(seconds: 1), (timer) {


                   if(_timerSeconds>=0 && _timerSeconds <60){
                    _timerSeconds ++ ;
                    print(_timerSeconds);
                    if(_timerMinutes < 10 && _timerSeconds <10 ){
                     setState(() {
                       _recordedTime = "0$_timerMinutes : 0$_timerSeconds";
                     });

                    }else{
                     setState(() {
                       if(_timerMinutes < 10 ){
                         _recordedTime = "0$_timerMinutes :  $_timerSeconds";
                       }else{
                         _recordedTime = "$_timerMinutes :  $_timerSeconds";
                       }

                     });

                    }

                   }else{
                     _timerSeconds =0 ;
                     _timerMinutes++;
                   }




                 });

                  print("Start");
                },

                onLongPressEnd: (LongPressEndDetails lg){
                  _audioRecording.stop();
                  /// Function To Upload Audio File

                  print("Local Position");
                    if(lg.localPosition.dx.isNegative){

                   print("Cancel");


                      setState(() {

                       _counterTimer!.cancel();
                       _timerMinutes=0;
                       _timerSeconds=0;
                       _recordedTime = "00 : 00";
                        _isRecorded=false;

                      });



                    }else{
                      setState(() {
                      _audioRecording.init().whenComplete(() => _audioRecording.uploadAudio(
                          reciverId: widget.reciverId,
                          reciverName: widget.reciverName
                      ));


                     _timerSeconds=0;
                     _timerMinutes=0;
                     _counterTimer!.cancel();
                     _recordedTime = "00 : 00";
                     _isRecorded = false;
                   });


                    }

                  print("End");

                },

                child:
                _isRecorded ?
                 Container(
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       color: Colors.black,
                       shape: BoxShape.circle
                     ),
                     child: Icon(
                       Icons.mic,color: Colors.white,
                       size: 40,)):Icon(Icons.mic,color: Colors.black,size: 30,) ,)

                  : IconButton(
                onPressed: (){
    if(widget.messageController!.text.isNotEmpty){
             ManageMessages.sendMessages(reciverId: widget.reciverId!,
                 reciverName: widget.reciverName!,
                 textMessage: widget.messageController!.text,
                  isText: true,
             );
                  widget.messageController!.clear();

             setState(() {
             _isTypeVoice = true;
             });
            }

           },
      icon:Icon(Icons.send,color: Colors.black,size: 30,))),


        ],
      ),
    );
  }
}
