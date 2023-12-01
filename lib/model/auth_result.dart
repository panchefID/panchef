import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;
  final String? message;

  AuthResult(this.user, this.message);
}