import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_app/components/LoginPage.dart';
import 'package:login_app/components/RoleSelectionPage.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserState.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for input fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Function to handle sign-up with email and password
  Future<void> _signUpWithEmailAndPassword() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      // Create a new user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      String userId = userCredential.user!.uid;

      // Update userId using UserState
      Provider.of<UserState>(context, listen: false).setUserId(userId);

      if (user != null) {
        // Store user data in Firestore
        await _firestore.collection('users').doc(userId).set({
          "username": username,
          "email": email,
        });

        Fluttertoast.showToast(msg: "Signup Successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RoleSelectionPage()), // Replace with your next screen
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        String userId = userCredential.user!.uid;

        // Update userId using UserState
        Provider.of<UserState>(context, listen: false).setUserId(userId);
        User? user = userCredential.user;

        if (user != null) {
          // Check if user data already exists in Firestore
          DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();

          if (userSnapshot.exists) {
            Fluttertoast.showToast(msg: "Login Successfully");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoleSelectionPage()));
          } else {
            // Store new user data in Firestore
            await _firestore.collection('users').doc(userId).set({
              "username": user.displayName,
              "email": user.email,
            });

            Fluttertoast.showToast(msg: "Signup Successfully");
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoleSelectionPage()));
          }
        } else {
          Fluttertoast.showToast(msg: "Google Sign-in failed");
        }
      } else {
        Fluttertoast.showToast(msg: "Google Sign-in canceled");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Google Sign-in failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap the Column in SingleChildScrollView
        child: Padding(
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
              // Page Title
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Montserrat', // Added Montserrat font
                ),
              ),
              SizedBox(height: 20),
              // Username Field
              Text(
                "Username",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat', // Added Montserrat font
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "Enter your username...",
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
              SizedBox(height: 16),
              // Email Field
              Text(
                "Email",
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
                  hintText: "Enter your email...",
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
              SizedBox(height: 16),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
              SizedBox(height: 16),
              // Confirm Password Field
              Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat', // Added Montserrat font
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm your password...",
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
                  margin: EdgeInsets.symmetric(horizontal: 20), // Padding on both sides
                  height: 50, // Fixed height
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF004DAB), Color(0xFF09163D)], // Gradient colors
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
                    onPressed: _signUpWithEmailAndPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Transparent background
                      shadowColor: Colors.transparent, // Remove default shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // Rounded corners
                      ),
                      padding: EdgeInsets.zero, // Remove default padding
                    ),
                    child: Text(
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
              // Continue with Google Button
              Center(
                child: Container(
                  width: double.infinity, // Full width
                  margin: EdgeInsets.symmetric(horizontal: 20), // Padding on both sides
                  height: 50, // Fixed height
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                    border: Border.all(
                      color: Color(0xFF425164), // Border color #425164
                      width: 1.5, // Border width
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Transparent background
                      shadowColor: Colors.transparent, // Remove default shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // Rounded corners
                      ),
                      padding: EdgeInsets.zero, // Remove default padding
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_icon.png', // Add Google icon asset
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Colors.black, // Black text color
                            fontFamily: 'Montserrat', // Montserrat font
                            fontWeight: FontWeight.w700, // Font weight 700
                            fontSize: 16, // Font size 16px
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Already have an account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat', // Added Montserrat font
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Login",
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
              SizedBox(height: 20), // Extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}