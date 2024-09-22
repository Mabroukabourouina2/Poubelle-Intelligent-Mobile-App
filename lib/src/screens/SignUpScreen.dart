import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/AuthService.dart';
import 'DirctionScreen.dart';
import 'SignInScreen.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rfidController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorMessage;

  Future<void> _signup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match";
      });
      return;
    }

    try {
      User? user = await _authService.signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _rfidController.text,
      );
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DirctionScreen()),
        );
      }
    } catch (e) {
      setState(() {
        // Extract the error message using a regular expression
        final errorMessage = RegExp(r'(?<=\]).+').firstMatch(e.toString())?.group(0) ?? 'An unknown error occurred';
        _errorMessage = errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S'inscrire",style: TextStyle(color: Colors.white,            fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0, // Remove the shadow
      ),
      extendBodyBehindAppBar: true, // Extend body behind app bar
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.lightBlueAccent], // Add gradient background
          ),
        ),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    labelStyle: TextStyle(color: Colors.white), // Change label text color
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change focused border color
                    ),
                    errorText: _errorMessage,
                    errorStyle: TextStyle(color: Colors.red), // Change error text color
                  ),
                  style: TextStyle(color: Colors.white), // Change input text color
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _rfidController,
                  decoration: InputDecoration(
                    labelText: 'RFID',
                    labelStyle: TextStyle(color: Colors.white), // Change label text color
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change focused border color
                    ),
                    errorText: _errorMessage,
                    errorStyle: TextStyle(color: Colors.red), // Change error text color
                  ),
                  style: TextStyle(color: Colors.white), // Change input text color
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white), // Change label text color
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change focused border color
                    ),
                    errorText: _errorMessage,
                    errorStyle: TextStyle(color: Colors.red), // Change error text color
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white), // Change input text color
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'mot de passe',
                    labelStyle: TextStyle(color: Colors.white), // Change label text color
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change focused border color
                    ),
                    errorText: _errorMessage,
                    errorStyle: TextStyle(color: Colors.red), // Change error text color
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white), // Change input text color
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    labelStyle: TextStyle(color: Colors.white), // Change label text color
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Change focused border color
                    ),
                    errorText: _errorMessage,
                    errorStyle: TextStyle(color: Colors.red), // Change error text color
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white), // Change input text color
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text('Se connecter',style: TextStyle(color: Colors.blueAccent,            fontWeight: FontWeight.bold,
                  ),),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text(
                    'Vous avez déjà un compte ? Connectez-vous',
                    style: TextStyle(color: Colors.white), // Change button text color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}