
class Message {
  final senderId;
  final senderName;
  final reciverId;
  final reciverName;
  final  time;
  final  text;
  bool isText = false;
  bool isLiked = false;
  bool  unread = true;

  Message({
    required this.senderId,
    required this.senderName,
    required this.reciverId,
    required this.reciverName,
    required this.time,
    required this.isText,
    required this.text,
    required this.isLiked,
    required this.unread,
  });


 factory Message.fromJson({final json}){
  return Message(
     senderId: json["senderId"],
     senderName: json["senderName"],
     reciverId: json["reciverId"],
     reciverName: json["reciverName"],
     time: json["time"],
     isText: json["isText"],
     text: json["text"],
     isLiked: json["isLiked"],
     unread: json["unread"]
     );
  }

  Map<String,dynamic> toJson(){
  return {
    "senderId":senderId,
    "senderName":senderName,
    "reciverId": reciverId,
    "reciverName" :reciverName,
    "time" : time,
    "isText" : isText,
    "text" : text,
    "isLiked":isLiked,
    "unread": unread
     };
  }

}
