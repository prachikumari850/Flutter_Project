// ============================================================
// services/auth_service.dart
// Firebase Authentication — login, signup, logout, persist state
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final AuthService _i = AuthService._();
  factory AuthService() => _i;
  AuthService._();

  final FirebaseAuth     _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db  = FirebaseFirestore.instance;

  // ── Getters ────────────────────────────────────────────
  User?          get currentUser    => _auth.currentUser;
  Stream<User?>  get authState      => _auth.authStateChanges();
  bool           get isLoggedIn     => _auth.currentUser != null;
  String         get uid            => _auth.currentUser?.uid ?? '';
  String         get displayName    =>
      _auth.currentUser?.displayName ??
      _auth.currentUser?.email?.split('@').first ?? 'User';
  String         get email          => _auth.currentUser?.email ?? '';

  // ── Sign Up ────────────────────────────────────────────
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password,
      );
      await cred.user?.updateDisplayName(name.trim());

      // Create Firestore user doc
      await _db.collection('users').doc(cred.user!.uid).set({
        'uid':          cred.user!.uid,
        'name':         name.trim(),
        'email':        email.trim(),
        'rewardPoints': 0,
        'createdAt':    FieldValue.serverTimestamp(),
        'fcmToken':     null,
      });
      return AuthResult.ok();
    } on FirebaseAuthException catch (e) {
      return AuthResult.err(_mapError(e.code));
    } catch (_) {
      return AuthResult.err('Something went wrong. Please try again.');
    }
  }

  // ── Sign In ────────────────────────────────────────────
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password,
      );
      return AuthResult.ok();
    } on FirebaseAuthException catch (e) {
      return AuthResult.err(_mapError(e.code));
    } catch (_) {
      return AuthResult.err('Something went wrong. Please try again.');
    }
  }

  // ── Sign Out ───────────────────────────────────────────
  Future<void> signOut() => _auth.signOut();

  // ── Save FCM token to Firestore ────────────────────────
  Future<void> saveFcmToken(String token) async {
    if (uid.isEmpty) return;
    await _db.collection('users').doc(uid)
        .update({'fcmToken': token}).catchError((_) {});
  }

  // ── Map Firebase error codes → readable messages ───────
  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':   return 'Email already registered. Please login.';
      case 'user-not-found':         return 'No account found with this email.';
      case 'wrong-password':         return 'Incorrect password. Please try again.';
      case 'invalid-email':          return 'Please enter a valid email address.';
      case 'weak-password':          return 'Password must be at least 6 characters.';
      case 'too-many-requests':      return 'Too many attempts. Please try again later.';
      case 'user-disabled':          return 'This account has been disabled.';
      case 'network-request-failed': return 'Network error. Check your connection.';
      case 'invalid-credential':     return 'Invalid email or password.';
      default:                       return 'Authentication failed. Please try again.';
    }
  }
}

// ── Result wrapper ─────────────────────────────────────────
class AuthResult {
  final bool   success;
  final String? error;
  const AuthResult._({required this.success, this.error});
  factory AuthResult.ok()            => const AuthResult._(success: true);
  factory AuthResult.err(String msg) => AuthResult._(success: false, error: msg);
}