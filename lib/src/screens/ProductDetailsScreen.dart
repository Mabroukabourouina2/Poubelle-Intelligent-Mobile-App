
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/ProductModel.dart';
import '../services/AuthService.dart';
import '../services/FirestoreService.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final FirestoreService _productService = FirestoreService();
  final AuthService _authService = AuthService();
  late String _userId;
  late int _userScore;
  bool _isLoading = false;
  Future<int>? _userScoreFuture;


  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      _userId = await _authService.getCurrentUserId();
      _userScore = await _authService.getUserScore(_userId);
      _userScoreFuture = _authService.getUserScore(_userId);
      setState(() {});
    } catch (e) {
      // Handle error, e.g., show a message
      print('Error initializing user: $e');
    }
  }

  Future<void> _buyProduct() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _productService.buyProduct(widget.product, _userId, _userScore);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Produit acheté avec succès !'),
        duration: Duration(seconds: 2),
      ));
      Navigator.pop(context, true); // Return to ShopScreen and indicate purchase
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 2),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Produit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

      body:  Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.blueAccent, Colors.lightBlueAccent], // Similar gradient as SignInScreen and SignUpScreen
    ),
    ),
    child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.product.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.0),
            Image.network(
              widget.product.photoUrl,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 16.0),
            Text(
              widget.product.description,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Text(
              'Prix: ${widget.product.price.toString()} points',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _buyProduct,
              child: Text('Acheter' ,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                ),),
            ),
          ],
        ),
      ),
    ),);
  }
}