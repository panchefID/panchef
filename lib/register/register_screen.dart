import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:recipient/home_screen.dart';
import 'package:recipient/register/register_request.dart';

import '../login/login_screen.dart';
import '../util.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage("asset/image/picture_one.png"),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0, left: 10.0),
                child: Text(
                  "Buat akun kamu dulu",
                  style: TextStyle(
                    color: mainColor,
                    fontFamily: mainFont,
                    fontSize: 26,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 16.0, top: 32, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nama Depan",
                            style: TextStyle(
                              color: Colors.black26,
                              fontFamily: mainFont,
                            ),
                          ),
                          TextFormField(
                            controller: firstNameController,
                            cursorColor: mainColor,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(
                              fontFamily: mainFont,
                            ),
                            decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: mainColor))),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 16.0, top: 32, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nama Belakang",
                            style: TextStyle(
                              color: Colors.black26,
                              fontFamily: mainFont,
                            ),
                          ),
                          TextFormField(
                            controller: lastNameController,
                            cursorColor: mainColor,
                            keyboardType: TextInputType.name,
                            style: const TextStyle(
                              fontFamily: mainFont,
                            ),
                            decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: mainColor))),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
                        focusedBorder: const UnderlineInputBorder(
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
                margin:
                    const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
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
                    var firstName = firstNameController.text;
                    var lastName = lastNameController.text;

                    if (email.isEmpty ||
                        password.isEmpty ||
                        firstName.isEmpty ||
                        lastName.isEmpty ||
                        isEmail(email) ||
                        isPassword(password)) {
                      Fluttertoast.showToast(
                          msg: "Data belum lengkap",
                          toastLength: Toast.LENGTH_SHORT);
                    } else {
                      register(email, password, firstName, lastName)
                          .then((value) {
                        Navigator.pop(context);
                        if (value.user != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                          Fluttertoast.showToast(
                              msg: "Verifikasi telah dikirim ke email anda",
                              toastLength: Toast.LENGTH_SHORT);
                        } else {
                          Fluttertoast.showToast(
                              msg: value.message!,
                              toastLength: Toast.LENGTH_SHORT);
                        }
                      });
                    }
                  },
                  child: const Text(
                    "Buat akun",
                    style: TextStyle(
                      fontFamily: mainFont,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
                      Text(
                        "Sudah punya akun?",
                        style: TextStyle(
                          fontFamily: mainFont,
                          fontWeight: FontWeight.w500,
                          color: Colors.black26,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Masuk Disini",
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
      ),
    );
  }
}
