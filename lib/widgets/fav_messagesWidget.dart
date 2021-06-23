import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';

class FavouraiteWidget extends StatefulWidget {
  final currentuserid;
  FavouraiteWidget({this.currentuserid});

  @override
  _FavouraiteWidgetState createState() => _FavouraiteWidgetState();
}

class _FavouraiteWidgetState extends State<FavouraiteWidget> {
   @override
  Widget build(BuildContext context) {
     setState(() {

     });
     return StreamBuilder(
         stream:FirebaseFirestore.instance.collection("users").where("id",isNotEqualTo:widget.currentuserid)
             .where("status",isEqualTo: true)
             .snapshots(),
         builder: (context,AsyncSnapshot<QuerySnapshot>snapshot) {

         if(!snapshot.hasData) {
           return Container();
         }else{
           final data = snapshot.data!.docs;
           return  Container(

        decoration: BoxDecoration(
         color: Colors.white,
          borderRadius: BorderRadius.only(topLeft:Radius.circular(40),topRight: Radius.circular(40)),
        ),
    //  height: 160,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Online Users"),
                  Icon(Icons.more_horiz_rounded),
                ],
              ),
            ),
            Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context,index){
                    return Container(
                      padding: EdgeInsets.only(left: 25),
                      child:Column(children: [
                          GestureDetector(
                          onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ChatScreen(
                            status: data[index]["status"],
                            userid :data[index]["id"],
                            username: data[index]["name"],
                          ))),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Stack(
                              children: [
                                Container(
                                  height:60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.yellow,
                                    image:data[index]["image"]== null ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/images/avator.jpg'),
                                    ):DecorationImage(
                                    fit: BoxFit.cover,
                                   image: NetworkImage('${data[index]["image"]}'),
                                  ),
                                  ),
                                ),
                              Positioned(

                                child: Container(
                                 height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                     color: Colors.green,
                                    shape: BoxShape.circle
                                  ),
                                ),
                                right: 1,
                              ),
                              ],
                            ),
                          ),
                        ),

                        Text("${data[index]["name"]}",style:TextStyle(
                          height: 2,

                        ),),
                      ],),
                    );
                  }),
            ),
          ],
        ),
    );}
         }
     );
  }
}
