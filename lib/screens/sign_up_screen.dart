import 'package:flutter/material.dart';
/// Custom Files Import
import '../authentication/signup_authentication.dart';
import '../data_resourse/send_and_recive_user.dart';
import '../model/user_model_class.dart';
import '../services/shared_prefences.dart';
import '../widgets/sign_button_design.dart';
import '../routes.dart';
import '../util/constants.dart';
import '../widgets/sign_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController  _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
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
        content: Text("Please Fill All Fields",style: TextStyle(
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
                      Text("Dark Chat ",style: kHeadingStyle1,),
                      Text("Create An Account & Join us",style: kGreyTextStyle,),

                    ],
                  ),
                ),
                Container(
                  margin:EdgeInsets.symmetric(vertical: heightMedia*0.01,horizontal:widthMedia*0.07),

                  height: heightMedia*0.7,
                  width: widthMedia*0.9,

                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(topLeft: kCornerRadius,bottomRight: kCornerRadius)
                  ),
                  padding: EdgeInsets.symmetric(vertical:heightMedia*0.04, horizontal:widthMedia*0.07),
                  child: Column(children: [

                    Text("SignUp",style: kHeadingStyleW,),
                    SizedBox(
                      height: heightMedia*0.04,
                    ),

                    TextFieldDesign(
                      textController: _emailController,
                      textIcon: Icons.alternate_email,
                      textTitle: "Enter Email Here",
                    ),
                    Spacer(flex: 1,),
                    TextFieldDesign(
                      textController: _nameController,
                      textIcon: Icons.person,
                      textTitle: "Enter Name Here",
                    ),
                    Spacer(flex: 1,),


                    PasswordFieldDesign(
                      passController: _passController,
                    ),
                    Spacer(flex: 1,),
                    SignButtonDesign(
                      "SignUp",
                       (){
                        if(_nameController.text.isNotEmpty && _passController.text.isNotEmpty && _emailController.text.isNotEmpty){
                          setState(() {
                            isLoading = true;
                          });

                          SignUpService.signUp(email:_emailController.text,
                              password:
                              _passController.text,name :_nameController.text).then((user){
                            if(user != null){

                              isLoading= false;
                              _prefService.createCache("user", user.uid);
                              UserModelClass _userModelClass = UserModelClass(
                                  email: _emailController.text,
                                  name:_nameController.text,
                                  imageUrl:user.photoURL,
                                  id:user.uid,
                                  isOnline: true
                              );
                              //// SendAndReciveDataFromFireStore is custom class manage FireStore
                              SendAndReciveDataFromFireStore.sendToFireStore(
                                  _userModelClass).whenComplete(() async {
                                    await SendAndReciveDataFromFireStore.reciveFromFireStort(id:user.uid);
                                    final _currentUser = SendAndReciveDataFromFireStore.data[0];
                                    Navigator.of(context).pushNamed(HomeRoute,
                                    arguments: _currentUser);
                                  });



                            }
                          });
                        }else{
                          _showDialog(context);
                          print("Not Accepted");
                        }
                      },
                    ),
                    Spacer(flex: 1,),
                  ],),
                ),

                TextButton(
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    //    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SignUpScreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      onPressed: ()=> Navigator.pushNamed(context, SignInRoute),
                      child: RichText(text:TextSpan(
                          children: [TextSpan(text:"Already Have Account?",style: kGreyTextStyle),TextSpan(text:"SignIn",style: kGreyTextStyle)]
                      )),
                    ),
                  ),
                ),

              ]),



        ),
      ),
    );

  }
}

