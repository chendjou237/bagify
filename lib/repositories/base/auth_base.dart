import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseAuthRepository {
  Stream<User?> get onAuthStateChanged;
  Future<void> signInAnonymously();
  Future<UserCredential?> signInWithGoogle();
  Future<void> signInWithEmailPassWord(String emailAddress, String password);
  Future<void> signOut();
  User? getCurrentUser();
}
