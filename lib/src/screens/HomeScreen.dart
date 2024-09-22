import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/UserModel.dart';
import '../services/AuthService.dart';
import '../services/FirestoreService.dart';
import 'SignInScreen.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

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
      appBar: AppBar(
        title: FutureBuilder<UserModel?>(
          future: _getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Bienvenue');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data == null) {
              return Text('No user data found');
            } else {
              return Text('Bienvenue, ${snapshot.data!.name}' ,style: TextStyle(color: Colors.white,            fontWeight: FontWeight.bold,
              ),);
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout ,color: Colors.white,),
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
      ),
      extendBodyBehindAppBar: true, // Extend body behind app bar
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlueAccent], // Similar gradient as SignInScreen and SignUpScreen
          ),
        ),
        child: Center(
          child: FutureBuilder<UserModel?>(
            future: _getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else if (snapshot.data == null) {
                return Text('Aucune donnée utilisateur trouvée');
              } else {
                return _buildScoreSection(snapshot.data!);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSection(UserModel user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScoreCircle(user.score),
        SizedBox(height: 20),
        Text(
          'Votre solde',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Text style similar to SignInScreen and SignUpScreen
        ),
      ],
    );
  }

  Widget _buildScoreCircle(int score) {
    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.blueAccent], // Gradient similar to SignInScreen and SignUpScreen
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$score',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}