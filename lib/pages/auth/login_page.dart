import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/register_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Ventspils Augstskolas tērzēšanas platforma",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Pievienojies studentu tīklam",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          "assets/VeA25_logo.png",
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "E-pasts",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@venta\.lv$")
                                  .hasMatch(val!)
                              ? null
                              : "Lūdzu ievadi derīgu @venta.lv e-pastu";
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Parole",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            )),
                        validator: (val) {
                          if (val!.length < 6) {
                            return "Parolei jābūt vismaz 6 simbolu garai";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Text(
                            "Pieslēgties",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(TextSpan(
                        text: "Vai nav izveidots profils? ",
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Reģistrējies šeit",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const RegisterPage());
                                }),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result = await authService.loginWithUserNameandPassword(email, password);
      if (result == true) {
        await checkAndJoinSpecialGroup();
        
        QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
        nextScreenReplace(context, const HomePage());
      } else {
        showSnackbar(context, Colors.red, result);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> checkAndJoinSpecialGroup() async {
    const String specialGroupId = "T5NUa8VDyYMVXzu1Yple";
    const String specialGroupName = "Kopējais čats";

    DatabaseService dbService = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    bool isJoined = await dbService.isUserJoined(specialGroupName, specialGroupId, email);

    if (!isJoined) {
      await dbService.toggleGroupJoin(specialGroupId, email, specialGroupName);
    }
  }
}
