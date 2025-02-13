import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/components/mainHomePage.dart';
import 'package:login_app/components/SignUpPage.dart';
import 'package:provider/provider.dart';
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
        MaterialPageRoute(
            builder: (context) => MainHomePage()), // Replace with your HomePage
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Title
            Text(
              "Shot OK", // Updated to "Shot OK"
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Montserrat', // Added Montserrat font
              ),
            ),
            Text(
              "Login",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Montserrat', // Added Montserrat font
              ),
            ),
            SizedBox(height: 40),
            // Email Field
            Text(
              "Email Id",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat', // Added Montserrat font
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Enter your email id...",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Color(0xFF425164), // Border color #425164
                    width: 1.5, // Border width
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Color(0xFF425164), // Border color #425164
                    width: 1.5, // Border width
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Color(0xFF425164), // Border color #425164
                    width: 1.5, // Border width
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Password Field
            Text(
              "Password",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat', // Added Montserrat font
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter your password...",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Color(0xFF425164), // Border color #425164
                    width: 1.5, // Border width
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Color(0xFF425164), // Border color #425164
                    width: 1.5, // Border width
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Color(0xFF425164), // Border color #425164
                    width: 1.5, // Border width
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Next Button
            Center(
              child: Container(
                width: double.infinity, // Full width
                margin: EdgeInsets.symmetric(
                    horizontal: 20), // Padding on both sides
                height: 50, // Fixed height
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF004DAB),
                      Color(0xFF09163D)
                    ], // Gradient colors
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(25), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40F4FAFF), // Shadow color with opacity
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Transparent background
                    shadowColor: Colors.transparent, // Remove default shadow
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25), // Rounded corners
                    ),
                    padding: EdgeInsets.zero, // Remove default padding
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white, // White text color
                            fontFamily: 'Montserrat', // Montserrat font
                            fontWeight: FontWeight.w700, // Font weight 700
                            fontSize: 19, // Font size 19px
                            height: 26 / 19, // Line height 26px
                          ),
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
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat', // Added Montserrat font
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignUpPage())); // Navigate to SignUpPage
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF062C68), // Updated to #062C68
                      fontFamily: 'Montserrat', // Added Montserrat font
                    ),
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF062C68), // Updated to #062C68
                    fontFamily: 'Montserrat', // Added Montserrat font
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
