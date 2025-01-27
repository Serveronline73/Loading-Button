import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registrierung mit E-Mail und Passwort
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null; // Erfolg
    } catch (e) {
      return e.toString(); // Fehler
    }
  }

  /// Anmeldung mit E-Mail und Passwort
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Erfolg
    } catch (e) {
      return e.toString(); // Fehler
    }
  }

  /// Abmeldung
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Aktuellen Benutzer abrufen
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
