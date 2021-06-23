import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/user_model_class.dart';

import 'chat_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  var searchStream;
  bool isloading= true;
  @override
  Widget build(BuildContext context) {
    double mediaQuery = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:Text("Search User"),
      ),
      body:Column(
        children: [
          Padding(
            padding:EdgeInsets.symmetric(vertical: 20,horizontal: mediaQuery * 0.05),
            child: Container(
              //color: Colors.orange,
              padding:const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                       controller: _searchController,
                       decoration: InputDecoration(
                         hintText: "Search User By name..",
                         border: InputBorder.none,
                       ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: MaterialButton(
                      onPressed: (){
                       isloading = true;
                        if(_searchController.text.isNotEmpty){

                       searchStream = FirebaseFirestore.instance.collection("users")
                          // .where("field")
                           .where("name",isEqualTo: _searchController.text).snapshots();
                          setState(() {
                           isloading = false;
                          });
                        }

                      },
                      child: Container(
                        width: double.infinity,
                        color: Colors.black,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                        child: Text("Search",style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
        child: StreamBuilder(
          stream: searchStream,
          builder: (context,AsyncSnapshot<QuerySnapshot>snapshot) {
            if(!snapshot.hasData) return Center(

              child:Container(
                child: Text("No Data Found Yet"),
              ),
            );
            final data = snapshot.data!.docs;
                return ListView.builder(
                     itemCount: data.length,
                    itemBuilder: (context,index){
                       UserModelClass user = UserModelClass.fromJson(data[index].data());
                    if(isloading){return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );}else{
                       return CustomListTile(
                        searchUser: user,
                        containerwidth:mediaQuery
                    );
                    }
            });

          }
        ),
        ),

        ],
      ) ,
    );
  }
}

class CustomListTile extends StatelessWidget {
  final UserModelClass searchUser;
  final double containerwidth;
  CustomListTile({Key? key,required this.searchUser,required this.containerwidth}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Container(
      width: containerwidth,
     // color: Colors.orange,
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        width: double.infinity,
        child:  Row(
          children: [
            Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(

                  shape: BoxShape.circle,
                  image:searchUser.imageUrl == null ? DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/avator.jpg'),
                  ):DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('${searchUser.imageUrl}'),
                  ),)
            ),

            SizedBox(width: containerwidth* 0.03,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${searchUser.name}"),
                    Container(

                      height: 12,
                      width: 12,
                      decoration:searchUser.isOnline ? BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ):BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle
                      ),
                    ),

                  ],
                ),
                SizedBox(height: containerwidth* 0.01,),
                Container(
                  width: containerwidth*0.30,
                  child:searchUser.isOnline? Text("Online",
                   style: TextStyle(
                     fontSize: 10,
                   ),
                  ):Text("Offline",
                    style: TextStyle(
                      fontSize: 10,
                    )
                ),
                )],),
            SizedBox(width: containerwidth* 0.02,),
            Expanded(
              child:MaterialButton(
                onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ChatScreen(
                  status: searchUser.isOnline,
                  userid :searchUser.id,
                  username: searchUser.name,
                ))),
                child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 13,horizontal: 3),
                child: Text("MESSAGE",style: TextStyle(color: Colors.white),),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black
                ),
              ),
            ),
            )


          ],


        ),

      ),
    );
  }
}
