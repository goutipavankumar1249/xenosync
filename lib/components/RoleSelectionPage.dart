import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:login_app/components/Business/Nextpage2.dart';
import 'package:login_app/components/SplashScreen.dart';
import 'package:login_app/components/individual/NextPage.dart';
import 'package:provider/provider.dart';
import 'UserState.dart';

class RoleSelectionPage extends StatefulWidget {
  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole; // To store the selected role
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  void saveRoleToFirebase() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    print('$currentUser');
    if (currentUser != null && selectedRole != null) {
      final String userId = currentUser.uid; // Get the current user's ID

      // Save the role to Firebase
      await databaseRef.child('users/${currentUser.uid}/role').set(selectedRole);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Role saved successfully!")),
      );

      //storing the userid
      Provider.of<UserState>(context, listen: false).setUserId(userId);
      print('$userId');

      // Navigate to a specific page based on the role
      if (selectedRole == "Individual") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NextPage()), // Navigate to IndividualPage
        );
      } else if (selectedRole == "Business") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NextPage2()), // Navigate to BusinessPage
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome! Let’s get to know you better",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Choose your role to customize your experience.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
                        ? Colors.blue
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Individual",
                    style: TextStyle(fontSize: 18),
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
                    color:
                    selectedRole == "Business" ? Colors.blue : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Business",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Spacer(),
            // Next button
            ElevatedButton(
              onPressed: saveRoleToFirebase,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Center(
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
