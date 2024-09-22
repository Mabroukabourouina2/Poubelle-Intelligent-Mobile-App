import 'package:flutter/material.dart';
import '../models/ProductModel.dart';
import '../services/AuthService.dart';
import '../services/FirestoreService.dart';
import 'ProductDetailsScreen.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final FirestoreService _productService = FirestoreService();
  final AuthService _authService = AuthService();
  late Future<List<Product>> _productsFuture;
  late String _userId;
  late int _userScore;
  Future<int>? _userScoreFuture;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _productsFuture = _productService.getProducts();
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

  void _buyProduct(Product product) async {
    try {
      await _productService.buyProduct(product, _userId, _userScore);
      await _initializeUser(); // Refresh user details after buying the product
      setState(() {
        _productsFuture = _productService.getProducts();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Produit acheté avec succès !'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magasin',style: TextStyle(color: Colors.white,            fontWeight: FontWeight.bold,
        ),),
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
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun produit trouvé'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Product product = snapshot.data![index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(product.title  ,
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
                      subtitle: Text('${product.price.toString()} points',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.lightBlueAccent,
                        ), ),
                      onTap: () async {
                        bool? purchaseMade = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product: product),
                          ),
                        );

                        if (purchaseMade == true) {
                          // Refresh the product list after a successful purchase
                          setState(() {
                            _productsFuture = _productService.getProducts();
                          });
                          _initializeUser(); // Refresh user details
                        }
                      },
                      trailing: ElevatedButton(
                        onPressed: () {
                          _buyProduct(product);
                        },
                        child: Text('Acheter', style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.lightBlueAccent,
                        ),),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _productService.addRandomProduct();
          setState(() {
            _productsFuture = _productService.getProducts();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}