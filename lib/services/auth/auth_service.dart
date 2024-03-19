import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance auth
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //instance for the firestore
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//sign in method
  Future<UserCredential> signInWithEmailandPassword(
      String email, password) async {
    try {
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

//After creating a user, create a new document for the user in the users collection
      _firebaseFirestore.collection("notes").doc(userCredential.user!.uid).set(
          {'uid': userCredential.user!.uid, 'email': email},
          SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // catch error
      throw Exception(e.code);
    }
  }

  //create a new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

//After creating a user, create a new document for the user in the users collection
      _firebaseFirestore
          .collection("notes")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});
      return userCredential;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

//sign out method
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
