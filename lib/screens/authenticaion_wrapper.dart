
/// Flutter And Dart Imports
import 'dart:async';
import 'package:flutter/material.dart';

/// Custom Files Import

import '../authentication/authentication.dart';
import '../data_resourse/send_and_recive_user.dart';
import '../services/shared_prefences.dart';
import '../routes.dart';


class AuthWrapper extends StatefulWidget {
  //const Auth_Wrapper({Key key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  AuthenticationService _auth = AuthenticationService();
  SharedPrefService _prefService =SharedPrefService();


  @override

  void initState() {

   _prefService.readCache("user").then(( value) {
      if (value != null && value.isNotEmpty && value != 'null' ){
        // IF user login before
        return Timer(Duration(milliseconds: 500),
                (){
                  /// Is to avoid null as route arrgument and pass current user data

                  SendAndReciveDataFromFireStore.reciveFromFireStort(id:value).then((value){
                    final _currentUser = SendAndReciveDataFromFireStore.data[0];
                    Navigator.of(context).pushNamed(HomeRoute,
                        arguments: _currentUser);
                  });

                });
      } else {
        return Timer(Duration(milliseconds: 500),
                () => Navigator.of(context).pushNamed(SignInRoute));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
    child:CircularProgressIndicator() ,
  );

  }
}
