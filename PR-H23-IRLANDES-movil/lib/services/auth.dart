import 'package:firebase_auth/firebase_auth.dart';
import '../models/firebaseuser.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Create user object base on Firebase User
  FirebaseUser? firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  //Auth change user stream
  Stream<FirebaseUser?> get user {
    return auth.authStateChanges().map(firebaseUser);
  }

  //Sign in anonymously
  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await auth.signInAnonymously();
      User? user = userCredential.user;
      return firebaseUser(user);
    } 
    catch (e) {
     return FirebaseUser(code: e.toString(), uid: null);
    }
  }

/*
  Future signInEmailPassword(LoginUser login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());
      User? user = userCredential.user;
      return firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
*/

  //Sign out
  Future signOut() async {
    try {
      return await auth.signOut();
    } 
    catch (e) {
      return null;
    }
  }
}