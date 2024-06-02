import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // autorizacija
Future loginWithUserNameandPassword(String email, String password) async {
  try {
    UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null && !user.emailVerified) {
      // ja email nav verified, tad izmet message
      return "Email Not Verified";
    } else if (user != null && user.emailVerified) {
      // palaiz talak ja ir verified
      return true;
    }
  } on FirebaseAuthException catch (e) {
    return e.message;
  }
}

 
  //registracija
Future registerUserWithEmailandPassword(String fullName, String email, String password) async {
  try {
    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      // Aizsuuta verifikacijas emailu
      await user.sendEmailVerification();

      // izsauc datubazi lai saglabatu datus
      await DatabaseService(uid: user.uid).savingUserData(fullName, email);
      
      // Pateikt, ka vajag verifyjot epastu
      return "Verify Email";
    }
  } on FirebaseAuthException catch (e) {
    return e.message;
  }
}


  // izlogoties
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
