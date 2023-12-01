import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/auth_result.dart';
import '../model/register_model.dart';

Future<AuthResult> login(String email, String password) async {
  try {
    var credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    return AuthResult(user, null);
  } on FirebaseAuthException catch (e) {
    return AuthResult(null, e.message);
  }
}

Future<AuthResult> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  try {
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.additionalUserInfo?.isNewUser == true) {
      var data = RegisterModel(
          email: userCredential.user?.email ?? "",
          firstName: userCredential.user?.displayName ?? "",
          lastName: "",
          photoUrl: userCredential.user?.photoURL ?? "");
      await FirebaseFirestore.instance
          .collection("User Information")
          .doc(userCredential.user?.uid)
          .set(data.toMap());
    }
    return AuthResult(userCredential.user, null);
  } on FirebaseAuthException catch (e) {
    return AuthResult(null, e.message);
  }
}
