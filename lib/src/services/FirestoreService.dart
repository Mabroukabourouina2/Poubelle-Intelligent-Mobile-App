import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ProductModel.dart';
import '../models/UserModel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>, uid);
    }
    return null;
  }

  Future<void> updateUserScore(String uid, double newScore) async {
    await _firestore.collection('users').doc(uid).update({
      'score': newScore,
    });
  }

  Future<List<Product>> getProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('products').where('sold', isEqualTo: false).get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<void> addRandomProduct() async {
    Random random = Random();
    int randomNumber = random.nextInt(1000);
    String randomTitle = 'Produit $randomNumber';
    String randomDescription = 'Description de $randomTitle';
    int randomPrice = (random.nextDouble() * 100).toInt();
    String randomPhotoUrl = 'https://via.placeholder.com/150';
    bool randomSold = false;

    await _firestore.collection('products').add({
      'title': randomTitle,
      'description': randomDescription,
      'price': randomPrice,
      'photoUrl': randomPhotoUrl,
      'sold': randomSold,
    });}

  Future<List<Product>> getProductsBoughtByUser(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('products')
        .where('boughtBy', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<void> buyProduct(Product product, String userId, int userScore) async {
    if (userScore >= product.price) {
      await _firestore.collection('products').doc(product.id).update({
        'sold': true,
        'boughtBy': userId,
      });
      await _firestore.collection('users').doc(userId).update({
        'score': userScore - product.price,
      });
    } else {
      throw Exception('Pas assez de points pour acheter ce produit.');
    }
  }
}
