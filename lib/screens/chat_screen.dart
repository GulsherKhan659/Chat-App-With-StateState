import 'package:flutter/material.dart';
import '../widgets/chat_message.dart';


class ChatScreen extends StatefulWidget {
  //const ChatScreen({Key key}) : super(key: key);
  final username,userid,status;
  ChatScreen({this.username,this.userid,this.status});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(children: [
          Text("${widget.username}"),
          SizedBox(
            width: 1,
          ),
          widget.status == true ?
          Row(
            children: [
              Text("Online",style: TextStyle(
                fontSize: 8
              ),
              ),
              SizedBox(
                width: 0.6,
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            ],
          ):Row(
            children: [
              Text("Offline",style: TextStyle(
                  fontSize: 8
              ),
              ),
              SizedBox(
                width: 0.6,
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],),

      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
       child: Column(children: [
         SizedBox(height:10),
         Expanded(
           child: Container(
           child: ChatMessageDisplayCard(
             reciverId : widget.userid,
             reciverName : widget.username
           ),
           ),
         ),
       ],),
      ),
    ));
  }
}
