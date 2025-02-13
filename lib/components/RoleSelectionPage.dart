import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_app/components/Business/Nextpage2.dart';
import 'package:login_app/components/individual/NextPage.dart';
import 'package:provider/provider.dart';
import 'UserState.dart';

class RoleSelectionPage extends StatefulWidget {
  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole; // To store the selected role
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void saveRoleToFirebase() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && selectedRole != null) {
      final String userId = currentUser.uid; // Get the current user's ID

      // Save the role to Firebase
      await _firestore.collection('users').doc(userId).update(
        {
          'role': selectedRole,
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Role saved successfully!")),
      );

      // Storing the user ID
      Provider.of<UserState>(context, listen: false).setUserId(userId);
      print('$userId');

      // Navigate to a specific page based on the role
      if (selectedRole == "Individual") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NextPage()), // Navigate to IndividualPage
        );
      } else if (selectedRole == "Business") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NextPage2()), // Navigate to BusinessPage
        );
      }
    } else {
      // Show a Snackbar if no role is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a role.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set white background
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Shot OK", // Brand name
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Montserrat', // Montserrat font
          ),
        ),
        centerTitle: true,
        elevation: 0, // Remove shadow
        backgroundColor: Colors.white, // Set white background for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Text(
              "Welcome! Let's get to know you better",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat', // Montserrat font
              ),
            ),
            SizedBox(height: 10),
            // Subtitle text
            Text(
              "Choose the categories that fit you best.",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6b6b6b), // Color #6b6b6b
                fontFamily: 'Source Sans Pro', // Source Sans Pro font
                fontWeight: FontWeight.w400, // Font weight 400
              ),
            ),
            SizedBox(height: 30),
            // Role buttons
            GestureDetector(
              onTap: () => setState(() => selectedRole = "Individual"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedRole == "Individual"
                        ? Color(0xFF004DAB) // Highlight border color #004DAB
                        : Color(0xFF425164), // Default border color #425164
                    width: selectedRole == "Individual"
                        ? 2.5
                        : 1.5, // Thicker border for selected
                  ),
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    "Individual",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat', // Montserrat font
                      fontWeight: FontWeight.w500, // Font weight 500
                      color: selectedRole == "Individual"
                          ? Color(0xFF004DAB) // Highlight text color #004DAB
                          : Colors.black, // Default text color
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedRole = "Business"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedRole == "Business"
                        ? Color(0xFF004DAB) // Highlight border color #004DAB
                        : Color(0xFF425164), // Default border color #425164
                    width: selectedRole == "Business"
                        ? 2.5
                        : 1.5, // Thicker border for selected
                  ),
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    "Business",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat', // Montserrat font
                      fontWeight: FontWeight.w500, // Font weight 500
                      color: selectedRole == "Business"
                          ? Color(0xFF004DAB) // Highlight text color #004DAB
                          : Colors.black, // Default text color
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            // Next button
            Container(
              width: double.infinity, // Full width
              margin:
                  EdgeInsets.symmetric(horizontal: 20), // Padding on both sides
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
                onPressed: saveRoleToFirebase,
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
          ],
        ),
      ),
    );
  }
}
