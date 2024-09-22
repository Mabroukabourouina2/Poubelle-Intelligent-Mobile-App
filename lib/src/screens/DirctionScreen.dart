import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/UserModel.dart';
import '../services/AuthService.dart';
import '../services/FirestoreService.dart';
import 'CartScreen.dart';
import 'HomeScreen.dart';
import 'ShopScreen.dart';

class DirctionScreen extends StatefulWidget {
  const DirctionScreen({super.key});

  @override
  State<DirctionScreen> createState() => _DirctionScreenState();
}

class _DirctionScreenState extends State<DirctionScreen> {
  @override

  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ShopScreen(),
    CartScreen()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<UserModel?> _getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await _firestoreService.getUser(user.uid);
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      extendBody: true,

      bottomNavigationBar:Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
    ],
    ),
    child: ClipRRect(
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30.0),
    topRight: Radius.circular(30.0),
    ),
    child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Boutique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        backgroundColor:Colors.white,


        onTap: _onItemTapped,
      ),
    ),),);
  }
}