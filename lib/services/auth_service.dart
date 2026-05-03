import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'firestore_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  Future<UserCredential?> signUp(String email, String password, String name) async {
    try {
      String normalizedEmail = _normalizeEmail(email);
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      
      // Save user name to Firestore
      await _firestore.saveUserName(normalizedEmail, name);

      return userCredential;
    } catch (e) {
      debugPrint('SignUp Error: $e');
      rethrow;
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      String normalizedEmail = _normalizeEmail(email);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      return userCredential;
    } catch (e) {
      debugPrint('Login Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: _normalizeEmail(email));
  }
}
