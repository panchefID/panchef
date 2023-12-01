import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:recipient/register/register_screen.dart';
import 'package:recipient/util.dart';

import '../home_screen.dart';
import '../main.dart';
import 'login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String errorMsg = "";
  bool isObscure = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage("asset/image/picture_one.png"),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0),
              child: Text(
                "Selamat Datang",
                style: TextStyle(
                  color: mainColor,
                  fontFamily: mainFont,
                  fontSize: 26,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0, top: 32, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.black26,
                      fontFamily: mainFont,
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    cursorColor: mainColor,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontFamily: mainFont,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (validator) {
                      return validateEmail(validator!);
                    },
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: mainColor))),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0, top: 32, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.black26,
                      fontFamily: mainFont,
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    cursorColor: mainColor,
                    obscureText: isObscure,
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                      fontFamily: mainFont,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (validator) {
                      return validatePassword(validator!);
                    },
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          !isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(mainColor),
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () {
                  showDialogs(context);
                  var email = emailController.text;
                  var password = passwordController.text;

                  if (email.isEmpty ||
                      password.isEmpty ||
                      isEmail(email) ||
                      isPassword(password)) {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "Data belum lengkap",
                        toastLength: Toast.LENGTH_SHORT);
                  } else {
                    login(email, password).then((value) {
                      Navigator.pop(context);
                      if (value.user != null) {
                        if (value.user?.emailVerified == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyMainPage()));
                        } else {
                          FirebaseAuth.instance.signOut();
                          Fluttertoast.showToast(
                              msg: "Mohon Konfirmasi email anda");
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: value.message!,
                            toastLength: Toast.LENGTH_SHORT);
                      }
                    });
                  }
                },
                child: const Text(
                  "Masuk",
                  style: TextStyle(
                    fontFamily: mainFont,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(
                  "atau",
                  style: TextStyle(
                      fontFamily: mainFont,
                      color: Colors.black26,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll(Colors.white),
                  overlayColor: const MaterialStatePropertyAll(
                    Color.fromRGBO(255, 240, 230, 1),
                  ),
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () {
                  signInWithGoogle().then((value) {
                    if (value.user != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    } else {
                      Fluttertoast.showToast(
                          msg: value.message!, toastLength: Toast.LENGTH_SHORT);
                    }
                  });
                },
                icon: const Image(
                  image: AssetImage("asset/image/google_img.png"),
                  width: 30,
                  height: 30,
                ),
                label: const Text(
                  "Masuk dengan google",
                  style: TextStyle(
                    fontFamily: mainFont,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Belum punya akun?",
                      style: TextStyle(
                        fontFamily: mainFont,
                        fontWeight: FontWeight.w500,
                        color: Colors.black26,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: const Text(
                        "Daftar Disini",
                        style: TextStyle(
                          fontFamily: mainFont,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
