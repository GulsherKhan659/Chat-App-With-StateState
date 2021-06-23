import 'package:firebase_auth/firebase_auth.dart';


class SignUpService{
  static Future<User?> signUp ({final email,final password,final name})async{
         try{

          UserCredential signUpUser =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
          User _firebaseUser = signUpUser.user!;
            return _firebaseUser;

         }catch (e){
           print( "Sign Up Exception ");
           print(e);
         }
 }
}