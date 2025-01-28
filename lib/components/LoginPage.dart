import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/components/Business/DetailsForBrand.dart';
import 'package:login_app/components/mainHomePage.dart';
import 'package:login_app/components/RoleSelectionPage.dart';
import 'package:login_app/components/SplashScreen.dart';
import 'package:login_app/components/individual/AudienceForInfluencer.dart';
import 'package:login_app/components/individual/DetailsForInfluencer.dart';
import 'package:login_app/components/Business/NicheForBrand.dart';
import 'package:login_app/components/individual/NarrowInfluencer.dart';
import 'package:login_app/components/individual/PassionPage.dart';
import 'package:login_app/main.dart';
import 'package:provider/provider.dart';
import 'SignUpPage.dart';
import 'UploadImagesPage.dart';
import 'UserState.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String userId = userCredential.user!.uid;
      print('$userId');

      // Update userId using UserState
      Provider.of<UserState>(context, listen: false).setUserId(userId);

      // Login successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainHomePage()), // Replace with your HomePage
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      String message = "An error occurred, please try again.";
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password.";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Title
            Text(
              "Xeno Sync",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Login",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            // Email Field
            Text(
              "Email Id",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Enter your email id...",
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Password Field
            Text(
              "Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter your password...",
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Next Button
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Sign-up and Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage())); // Navigate to SignUpPage
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                ),
              ],
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  // Add navigation to forgot password page
                },
                child: Text(
                  "Forget password?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


