import 'app_user.dart';

abstract class AuthRepository {
  // Future<void> signInWithGoogle();
  // Future<void> signOutFromGoogle();
  Future<void> signIn();
  Future<void> signOut();
  Future<AppUser?> signInWithEmailAndPassword(String email, String password);
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
}
