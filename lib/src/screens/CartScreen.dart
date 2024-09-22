import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/ProductModel.dart';
import '../services/AuthService.dart';
import '../services/FirestoreService.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirestoreService _productService = FirestoreService();
  final AuthService _authService = AuthService();
  Future<List<Product>>? _boughtProductsFuture;
  late String _userId;
  Future<int>? _userScoreFuture;


  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      _userId = await _authService.getCurrentUserId();
      String userId = await _authService.getCurrentUserId();
      _userScoreFuture = _authService.getUserScore(_userId);

      setState(() {
        _boughtProductsFuture = _productService.getProductsBoughtByUser(userId);
      });
    } catch (e) {
      // Handle error, e.g., show a message
      print('Error initializing user: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Panier',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0,
        actions: [
          FutureBuilder<int>(
            future: _userScoreFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur');
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Score: ${snapshot.data}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true, // Extend body behind app bar
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
          ),
        ),
        child: FutureBuilder<List<Product>>(
          future: _boughtProductsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun produit acheté' ,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Product product = snapshot.data![index];
                  return  Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child :ListTile(
                    title: Text(product.title ,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),),
                    leading: Image.network(
                      product.photoUrl,
                      width: 50,
                      height: 50,
                    ),
                    subtitle: Text('${product.price.toString()} points' ,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.lightBlueAccent,
                      ),),
                  ),);
                },
              );
            }
          },
        ),
      ),
    );
  }
}