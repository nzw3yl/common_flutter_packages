library firebase_auth_service;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.tenantId,
  }) : assert(uid != null, 'User can only be created with a non-null uid');

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final String tenantId;

  factory User.fromFirebaseUser({FirebaseUser user, String tenantId = 'TENANT_0'}) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      tenantId: tenantId,
    );
  }

  @override
  String toString() =>
      'uid: $uid, email: $email, photoUrl: $photoUrl, displayName: $displayName, tenantId: $tenantId';
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((firebaseUser) => User.fromFirebaseUser(user: firebaseUser));
  }

  Future<User> signInAnonymously() async {
    final AuthResult authResult = await _firebaseAuth.signInAnonymously();
    return User.fromFirebaseUser(user: authResult.user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return User.fromFirebaseUser(user: authResult.user, tenantId: 'TENANT_1');
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return User.fromFirebaseUser(user: authResult.user, tenantId: 'TENANT_2');
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return User.fromFirebaseUser(user: user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
