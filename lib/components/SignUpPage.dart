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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Xeno Sync",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Page Title
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            // Username Field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Confirm Password Field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Next Button
            Center(
              child: ElevatedButton(
                onPressed: _signUpWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: Text(
                  "continue with google",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                TextButton(
                  onPressed: () {
                    // Add navigation to sign-up page
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>
                          LoginPage()), // Replace with your next screen
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue),
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
