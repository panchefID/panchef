import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipient/model/register_model.dart';

import '../model/auth_result.dart';

Future<AuthResult> register(String email, String password, String firstName, String lastName) async {
  var defaultApp = Firebase.app();

  var tempApp = await Firebase.initializeApp(name: "temp auth", options: defaultApp.options);
  var tempAuth = FirebaseAuth.instanceFor(app: tempApp);
  

  try {
    var credential = await tempAuth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    await user?.sendEmailVerification();
    if (user != null) {
      var data = RegisterModel(email: email, firstName: firstName, lastName: lastName);
      await FirebaseFirestore.instance.collection("User Information").doc(user.uid).set(data.toMap());
      return AuthResult(user, null);
    } else {
      return AuthResult(null, null);
    }
  } on FirebaseAuthException catch(e) {
    return AuthResult(null, e.message);
  }
}