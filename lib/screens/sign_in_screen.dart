import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Custom Files Import

import '../data_resourse/send_and_recive_user.dart';
import '../model/user_model_class.dart';
import '../services/shared_prefences.dart';
import '../authentication/authentication.dart';
import '../routes.dart';
import '../widgets/sign_button_design.dart';
import '../widgets/social_icon_button_row.dart';
import '../util/constants.dart';
import '../widgets/sign_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthenticationService _authenticationService = AuthenticationService();
  TextEditingController  _textController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool isLoading = false;
  SharedPrefService _prefService = SharedPrefService();

    _showDialog(BuildContext context){
      showDialog(
         barrierColor: Colors.white.withOpacity(0.4),
          barrierDismissible: false,
      context: context, builder:(_){

        return AlertDialog(
          contentPadding: EdgeInsets.all(15),
          backgroundColor: Colors.grey.shade900,
          elevation: 15,
          title: Row(children:[
            Icon(Icons.close_rounded,color: Colors.red,size:30,),
            Text("Invalid",style: TextStyle(
                 color: Colors.white,
                 fontSize: 16,
                 fontWeight: FontWeight.w800
             ),),
          ]),
          content: Text("Please Check Email And Password",style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800
          )),
          actions: [
            MaterialButton(onPressed: (){
              Navigator.of(context).pop();

              },
            child: Text("Ok",style: TextStyle(
               color: Colors.white,
               fontSize: 16,
              fontWeight: FontWeight.w800
            ),),
            )
          ],
        );
      });

   }

  @override
  Widget build(BuildContext context) {
    double heightMedia=MediaQuery.of(context).size.height;
    double widthMedia=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child:isLoading ? Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ) : SingleChildScrollView(

          child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: EdgeInsets.symmetric(vertical: heightMedia*0.04,horizontal:widthMedia*0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome Back",style: kHeadingStyle1,),
                      Text("Login Back To Your Account",style: kGreyTextStyle,),

                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.symmetric(vertical: heightMedia*0.01,horizontal:widthMedia*0.07),

                  height: heightMedia*0.60,
                  width: widthMedia*0.9,

                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(topLeft: kCornerRadius,bottomRight: kCornerRadius)
                  ),
                  padding: EdgeInsets.symmetric(vertical:heightMedia*0.04, horizontal:widthMedia*0.07),
                  child: Column(children: [

                    Text("SignIn",style: kHeadingStyleW,),
                    SizedBox(
                      height: heightMedia*0.04,
                    ),

                    TextFieldDesign(
                      textController: _textController,
                      textIcon: Icons.alternate_email,
                      textTitle: "Enter Email Here",
                    ),
                    Spacer(flex: 1,),

                    PasswordFieldDesign(passController: _passController,),
                    Spacer(flex: 1,),
                    SignButtonDesign(
                      "SignIn",(){
                      if(_textController.text.isNotEmpty && _passController.text.isNotEmpty){
                      setState(() {
                        isLoading = true;
                      });

                        _authenticationService.signInEmail(_textController.text,_passController.text).then((
                          user)
                         {
                          /// recive model class of UserModelClass from Method reciveFromFireStort(id:user.uid) after parsing to json
                         if(user != null ) {
                          setState(() {
                            isLoading =false;
                          });

                          _prefService.createCache("user", user.uid.toString()).
                              whenComplete((){
                          SendAndReciveDataFromFireStore.reciveFromFireStort(id:user.uid);
                          final _currentUser = SendAndReciveDataFromFireStore.data[0];
                          FirebaseFirestore.instance.collection("users").doc(_currentUser.id).update({
                            "status" : true
                          });
                          Navigator.of(context).pushReplacementNamed(HomeRoute,arguments: _currentUser);
                          });

                        }
                      else{

                      }
                      });

                    }else{
                        _showDialog(context);
                        print("No Sign In");
                      }
                      },
                    ),
                    Spacer(flex: 1,),
                  ],),
                ),

                TextButton(
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                        Navigator.of(context).pushNamed(SignUpRoute);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        RichText(text:TextSpan(
                            children: [TextSpan(text:"Create An Account?",style: kGreyTextStyle),TextSpan(text:"SignUp",style: kGreyTextStyle)]
                        )),
                        SizedBox(
                          height: heightMedia*0.02,
                        ),
                        Text("SignIn Up",style: kGreyTextStyle,)
                      ],
                    ),
                  ),
                ),
              SocialIconWidget(
                firstImage: AssetImage("assets/images/fb-dark.png"),
                firstFunction:(){
                  setState(() {
                    isLoading = true;
                  });
                  _authenticationService.facebookSignInAuthentication().then((user) async {
    /// recive model class of UserModelClass from Method reciveFromFireStort(id:user.uid) after parsing to json
    final isData = await SendAndReciveDataFromFireStore.reciveFromFireStort(id:user.uid);

                if(user != null ) {
                 isLoading =false;
                 _prefService.createCache("user", user.uid);
                     if(isData == null ){
                     UserModelClass _userModelClass = UserModelClass(
                       email: user.email,
                       name:user.displayName,
                         imageUrl:user.photoUrl,
                      id:user.uid,
                      isOnline: true
    );
    /// SendAndReciveDataFromFireStore is custom class manage FireStore
      SendAndReciveDataFromFireStore.sendToFireStore(_userModelClass);
     await SendAndReciveDataFromFireStore.reciveFromFireStort(id:user.uid);
     final _currentUser = SendAndReciveDataFromFireStore.data[0];
        _prefService.createCache("user", user.uid);

        Navigator.of(context).pushReplacementNamed(HomeRoute,
       arguments:_currentUser);

    }else{
      final _currentUser = SendAndReciveDataFromFireStore.data[0];
      _prefService.createCache("user", user.uid);
      Navigator.of(context).pushReplacementNamed(HomeRoute,
          arguments:_currentUser);
    }

    }else{
                      print("Facebook Result =>=>");
                    }
                  });

                },
               secondImage:AssetImage("assets/images/google-dark.jpeg"),
                  secondFunction:(){
                    setState(() {
                      isLoading = true;
                    });
                    _authenticationService.googleSignInAuthentication().then((user)async {
                      /// recive model class of UserModelClass from Method reciveFromFireStort(id:user.uid) after parsing to json
                      final isData = await SendAndReciveDataFromFireStore.reciveFromFireStort(id:user.uid);

                      if(user != null ) {
                        isLoading =false;
                        _prefService.createCache("user", user.uid);

                        if(isData == null ){
                          UserModelClass _userModelClass = UserModelClass(
                              email: user.email,
                              name:user.displayName,
                              imageUrl:user.photoURL,
                              id:user.uid,
                              isOnline: true
                          );
                          ////endAndReciveDataFromFireStore is custom class manage FireStore
                         await SendAndReciveDataFromFireStore.sendToFireStore(_userModelClass);

                         await  SendAndReciveDataFromFireStore.reciveFromFireStort(id:user.uid);

                          final _currentUser = SendAndReciveDataFromFireStore.data[0];
                          _prefService.createCache("user", user.uid.toString());
                          Navigator.of(context).pushReplacementNamed(HomeRoute,
                              arguments:_currentUser);

                        }else{

                          final _currentUser = SendAndReciveDataFromFireStore.data[0];
                          _prefService.createCache("user", user.uid.toString());
                          Navigator.of(context).pushReplacementNamed(HomeRoute,
                              arguments:_currentUser);
                        }

                      }else{
                        print("Google  Result =>=>");
                      }
                    });

                  },

              ),
              ]),



        ),
      ),
    );

  }
}

