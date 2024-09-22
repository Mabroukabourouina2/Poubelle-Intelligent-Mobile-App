import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/UserModel.dart';
import 'FirestoreService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Future<User?> signUp(String email, String password, String name, String rfid) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;

    if (user != null) {
      UserModel newUser = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        rfid: rfid,
        score: 0,
      );
      await _firestoreService.addUser(newUser);
    }

    return user;
  }

  Future<User?> login(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String> getCurrentUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("Aucun utilisateur n'est actuellement connecté.");
    }
  }

  Future<int> getUserScore(String userId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return (doc['score'] as num).toInt();
    } else {
      throw Exception('Utilisateur non trouvé.');
    }
  }
}