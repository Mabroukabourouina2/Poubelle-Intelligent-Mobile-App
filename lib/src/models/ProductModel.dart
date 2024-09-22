import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String photoUrl;
  final int price;
  final bool sold;
  final String? boughtBy;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.price,
    required this.sold,
    this.boughtBy,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      price: (data['price'] as num).toInt(),
      sold: data['sold'] ?? false,
      boughtBy: data['boughtBy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'photoUrl': photoUrl,
      'price': price,
      'sold': sold,
      'boughtBy': boughtBy,
    };
  }
}
