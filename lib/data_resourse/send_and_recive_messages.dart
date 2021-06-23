

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_day5/data_resourse/send_and_recive_user.dart';
import 'package:flutter_day5/model/message_model_class.dart';

class ManageMessages{
  static sendMessages({required String reciverId,required String reciverName,required String textMessage,required bool isText})async{
    try{
    final _senderId = SendAndReciveDataFromFireStore.data[0].id;
   final _senderName = SendAndReciveDataFromFireStore.data[0].name;
   if(_senderId != null) {
     Message _message = Message(
       senderId: _senderId,
       senderName: _senderName,
       reciverId: reciverId,
       reciverName: reciverName,
       isText: isText,
       text: textMessage,
       isLiked: false,
       unread: true,
       time: DateTime.now(),
     );
     await FirebaseFirestore.instance.collection("messages").add(_message.toJson());
   }else{
     print("Message Sender Name");
     print(_senderName);
   }

    } catch (e){
      print("Exception Found In sendMessages Method");
      print(e);
    }

  }

// List getmessagedata=[];
//  static Future<Stream> reciveMessages() async {
//    try {
//    return
//    //     .forEach((snapshot) {
//    //    var element = snapshot.docs;
//    //  element.map((e)=> Message.fromJson(e.data())
//    //  ).where((element) =>  (
//    //
//    //      element.reciverId == anotherUser &&
//    //      element.senderId == currentUser) ||
//    //      (element.reciverId == currentUser &&
//    //          element.senderId == anotherUser));
//    //
//    //
//    //     // if(   (element.receiverId == friendId &&
//    //     //     element.senderId == currentUserId) ||
//    //     //     (element.receiverId == currentUserId &&
//    //     //         element.senderId == friendId)){}
//    // });
//
//
//    }catch (e){
//      print("Exception In Recive Data");
//    }
//  }


}