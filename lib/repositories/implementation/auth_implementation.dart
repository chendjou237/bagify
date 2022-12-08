import 'package:bagify/general_providers.dart';
import 'package:bagify/repositories/base/auth_base.dart';
import 'package:bagify/utils/custom_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository implements BaseAuthRepository {
  final Ref ref;
  AuthRepository(this.ref);

  @override
  User? getCurrentUser() {
    return ref.read(firebaseAuthProvider).currentUser;
  }

  @override
  // TODO: implement onAuthStateChanged
  Stream<User?> get onAuthStateChanged =>
      ref.read((firebaseAuthProvider)).authStateChanges();

  @override
  Future<void> signInAnonymously() async {
    await ref.read(firebaseAuthProvider).signInAnonymously();
  }

  @override
  Future<void> signInWithEmailPassWord(
      String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await ref
          .read(firebaseAuthProvider)
          .signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    } catch (e) {
      // Handle this scenario
      throw CustomException(message: e.toString());
    }
    // Trigger the authentication flow
  }

  @override
  Future<void> signOut() async {
    try {
      await ref.read(firebaseAuthProvider).signOut();
      await signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
