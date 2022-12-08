import 'dart:async';

import 'package:bagify/general_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AuthControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, User?>((ref) {
  return AuthControllerNotifier(ref)..appStarted();
});

class AuthControllerNotifier extends StateNotifier<User?> {
  final Ref ref;
  StreamSubscription<User?>? _authStateChangesSubscription;
  AuthControllerNotifier(
    this.ref,
  ) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription =
        ref.read(firebaseAuthProvider).authStateChanges().listen((user) {
      state = user;
    });
  }
  void appStarted() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) {
      await ref.read(firebaseAuthProvider).signInAnonymously();
    }
  }

  void signout() async {
    await ref.read(firebaseAuthProvider).signOut();
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }
}
