import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/AuthService.dart';
import 'DirctionScreen.dart';
import 'SignupScreen.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorMessage;

  Future<void> _login() async {
    try {
      User? user = await _authService.login(
        _emailController.text,
        _passwordController.text,
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
        title: Text('Se connecter',style: TextStyle(color: Colors.white,            fontWeight: FontWeight.bold,
        ), ),
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove the shadow
        // Change app bar color
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                errorStyle: TextStyle(color: Colors.red),
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white), // Change input text color
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: Colors.white), // Change label text color
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Change focused border color
                ),
                errorText: _errorMessage,
                errorStyle: TextStyle(color: Colors.red),
    // Change error text color
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white), // Change input text color
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Se connecter',style: TextStyle(color: Colors.blueAccent,            fontWeight: FontWeight.bold,
              ),),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                "Vous n'avez pas un compte ? Créez",
                style: TextStyle(color: Colors.white), // Change button text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}