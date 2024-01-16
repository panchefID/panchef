import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const mainFont = "Comfortaa";
const mainColor = Color.fromRGBO(232, 76, 35, 1);

String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value!)) {
    return 'Enter a valid email address';
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value!)) {
    return 'Password must be contain uppercase, lowercase and number';
  } else {
    return null;
  }
}

bool isEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value!)) {
    return true;
  } else {
    return false;
  }
}

bool isPassword(String? value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value!)) {
    return true;
  } else {
    return false;
  }
}

Future<void> showDialogs(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          color: Colors.white,
          child: Lottie.asset(
            "asset/animation/data.json",
            width: 100,
            height:100,
          ),
        ),
      );
    },
  );
}
