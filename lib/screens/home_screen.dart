import 'package:flutter/material.dart';

 /// Custom import File
import '../authentication/authentication.dart';
import '../data_resourse/send_and_recive_user.dart';
import '../model/user_model_class.dart';
import '../services/shared_prefences.dart';
import '../widgets/displaymsgcard.dart';
import '../widgets/drawer_widget.dart';
import '../routes.dart';
import '../widgets/fav_messagesWidget.dart';
import '../widgets/optionWidget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthenticationService _auth = AuthenticationService();
  SharedPrefService _prefService = SharedPrefService();



  @override
  Widget build(BuildContext context) {
   ///Get login user information to display in Drawer as Active user
   final UserModelClass? loginUser = ModalRoute.of(context)!.settings.arguments as UserModelClass;

    return SafeArea(
      child:Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Chat App"),

          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).pushNamed(SearchRoute);
            }, icon:Icon(Icons.search)),
            IconButton(onPressed: ()async{

              /// Method to SignOut user from firebase custom method from authentication.dart
              await _auth.logOutFromApp(userId: _prefService.readCache("user"));

              /// Method to remove userCache from shared_prefences.dart

              await _prefService.removeCache("user").whenComplete(() {

                SendAndReciveDataFromFireStore.updateSignInStatus(SendAndReciveDataFromFireStore.data[0]).then((
                    value){ SendAndReciveDataFromFireStore.data.removeAt(0);
                Navigator.of(context).pushReplacementNamed(SignInRoute);
                });
                setState(() {

                });
               print("SignOut");});

            }, icon:Icon(Icons.exit_to_app))
          ],
        ),
        drawer: DrawerWidget(
          /// Custom drawer widget Except parameters,
          userName: loginUser!.name,
          userEmail:loginUser.email ,
          userImageUrl:loginUser.imageUrl ,
        ),
        // ignore: unnecessary_null_comparison
        body: Container(
            height: double.infinity,
            width: double.infinity,
          child: Column(
            children: [

            OptionWidget(

            ),
            FavouraiteWidget(
            currentuserid: loginUser.id,
            ),
            Expanded(child:  Container(
                color: Colors.white,
                child: DisplayMessageCard()),)
          ],),

        ),
      ),
    );
  }
}
