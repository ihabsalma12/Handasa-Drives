import 'package:driver_demo/helpers/Driver.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

//controls login and signup in firebase
class AuthService{
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  Driver? _driverFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return Driver(user.uid, user.displayName, user.email, user.hashCode.toString());
  }

  Stream<Driver?>? get user{
    return _firebaseAuth.authStateChanges().map(_driverFromFirebase);
  }

  String? getUserUID(){
    return _firebaseAuth.currentUser!.uid;
  }
  String? getDisplayName(){
    return _firebaseAuth.currentUser?.displayName;
  }
  String? getUserEmail(){
    return _firebaseAuth.currentUser?.email;
  }

  Future<Driver?> signInWithEmailAndPassword({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _driverFromFirebase(credential.user);
  }

  Future<Driver?> createUserWithEmailAndPassword({required String fullName, required String email, required String password}) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(fullName);
    return _driverFromFirebase(credential.user);
  }


  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
    // notifyListeners();
  }

}