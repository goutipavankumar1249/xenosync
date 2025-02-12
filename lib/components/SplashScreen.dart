// import 'package:flutter/material.dart';
// import 'package:login_app/components/LoginPage.dart';
// import 'dart:async';
//
// import 'package:login_app/components/RoleSelectionPage.dart';
// import 'package:login_app/components/SignUpPage.dart';
// import 'package:login_app/components/mainHomePage.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Animation Controller
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//
//     // Scaling Animation
//     _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//
//     // Optional: Automatically navigate after some time (remove if not needed)
//     Timer(const Duration(seconds: 5), () {
//       _navigateToNextScreen();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _navigateToNextScreen() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your next screen
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[900], // Background color
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: 3,
//               child: Center(
//                 child: ScaleTransition(
//                   scale: _animation,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/images/logo.png', // Replace with your logo file path
//                         height: 180,
//                         width: 180,
//                       ),
//                       const Text(
//                         'Connecting Influencers and Brands Like Never Before',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_app/components/LoginPage.dart';
import 'package:login_app/components/mainHomePage.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Check user authentication and navigate accordingly
    Timer(const Duration(seconds: 3), _navigateToNextScreen);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>MainHomePage()),
      );
    } else {
      // User is not logged in, navigate to Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // Background color
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: ScaleTransition(
                  scale: _animation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/shot_ok_logo.png', // Replace with your logo file path
                        height: 180,
                        width: 180,
                      ),
                      const Text(
                        'Connecting Individuals and Businesses Like Never Before',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
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

