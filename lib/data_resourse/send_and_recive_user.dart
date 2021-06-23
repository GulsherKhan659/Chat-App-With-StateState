import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_day5/model/user_model_class.dart';



class SendAndReciveDataFromFireStore{
static List data =[];
static List recentlyJoinedUser = [];
static Future sendToFireStore (UserModelClass user)async{

    await FirebaseFirestore.instance.collection("users").doc(user.id).set(
      {
        "id" : user.id,
        "name" : user.name,
        "email" :user.email,
        "image" : user.imageUrl,
        "status" : user.isOnline
      }
    );
  }

 static Future reciveFromFireStort({final id}) async {
   await FirebaseFirestore.instance.collection("users").doc(id).get().then((dataBaseStoreRecord){
    try{
     if(dataBaseStoreRecord.exists){
       ///return model class after parsing json from firebase
       data.add(UserModelClass.fromJson(dataBaseStoreRecord.data()));

     }
     else{
       print("No Login User record Found");
     }
    }catch (e){
      print("Reciving Data Exception from FireStore");
      print(e);
    }
   } );

 }
 /// Method To  Receive Recently Joined Users
static  getAllRecentlyJoinedUser({final id}) async {
  try{

   return FirebaseFirestore.instance.collection("users").where("id",isNotEqualTo:id).snapshots();

  }catch(e){
    print("Exception in Recently Joined User Method");
    print(e);
  }
}

/// Method to update SignIn and SignOut Status

 static Future<void> updateSignInStatus(UserModelClass user)async{
    await FirebaseFirestore.instance.collection("users").doc(user.id).update(
      {
        "status": false,
      }
    );

        }


}


