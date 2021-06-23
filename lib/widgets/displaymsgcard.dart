import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../data_resourse/send_and_recive_user.dart';
import '../model/message_model_class.dart';
import '../screens/chat_screen.dart';
import '../util/constants.dart';
import '../util/date_time_format.dart';



class DisplayMessageCard extends StatelessWidget {
 // const MessageCard({Key key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    final sender = SendAndReciveDataFromFireStore.data[0];

    /// Variable is create just to check which user is online
    final _currentUserId = sender.id;

    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft:Radius.circular(30),),

      child:StreamBuilder(
           stream: FirebaseFirestore.instance.collection("messages")
                .where("reciverId",isEqualTo: _currentUserId)
                .orderBy("time",descending: true)
                .snapshots(),
          builder :(context,AsyncSnapshot<QuerySnapshot>snapshot){
         if(!snapshot.hasData)  return Container();
             var data = snapshot.data!.docs;

         return ListView.builder(
             itemCount: data.length,
             itemBuilder: (context,index){
               Message message = Message.fromJson(json: data[index].data());

               return   MessageCard(
                 data: message,
                 docId : data[index].id,

               );
          });}),
    );
  }
}


////////// Message Card Widget
//
class MessageCard extends StatelessWidget {
  final  data,docId;
   MessageCard({required this.data,required this.docId});

  dynamic userStatus;

   Future<void> getCurrentUserStatue(final id) async{
     print(id);
    userStatus =await FirebaseFirestore.instance.collection("users").doc(id).get().then((value){
      if(value.exists){
        userStatus =value ["status"];
      }
    });

   // print(userStatus.length);
   //   userStatus[0].data();
   // print(userStatus);
   }
  @override
  Widget build(BuildContext context) {
    double mediaWidth =MediaQuery.of(context).size.width;

    return GestureDetector(

      onTap: (){
       getCurrentUserStatue(data.senderId).whenComplete((){
         FirebaseFirestore.instance.collection("messages").doc(docId).update({
           "unread" : false
         }).then((value){
           Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ChatScreen(
             status: userStatus,//userStatus["status"],
             username: data.senderName,
             userid:data.senderId,
           )
           )
           );
         });
       });
      },
      child: Container(
        height: 100,

        padding: EdgeInsets.only(bottom: 10,right: 35),
        child: Container(
          padding:const EdgeInsets.only(left:15),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
            color:data.unread ? Colors.grey.shade100:Colors.white,

          ),

          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(

                  shape: BoxShape.circle,
                  image:data.unread ? DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/undread.png'),
                  ):DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/read.png'),
                  ),)
                ),

              SizedBox(width: mediaWidth* 0.03,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("${data.senderName}"),
                  SizedBox(height: mediaWidth* 0.01,),
                  Container(
                  width: mediaWidth*0.44,
                  child: data.isText ? Text("${data.text}",
                    overflow: TextOverflow.ellipsis,
                  ):Container(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.mic)),
                ) ,
              ],),
              SizedBox(width: mediaWidth* 0.02,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("${FormatDate.converTimestampToTime(timeStamp: data.time)}"), //${data.time}
                SizedBox(height: mediaWidth* 0.02,),
                data.unread ? kNewBadge:Container(height: 20,width: 30,),
            ],)
            ],


           ),
        ),
      ),
    );
  }
}
