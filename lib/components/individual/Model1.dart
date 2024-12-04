import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:login_app/components/individual/Model2.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class Model1 extends StatefulWidget {
  @override
  _Model1State createState() => _Model1State();
}

class _Model1State extends State<Model1> {
  String? selectedRole; // Store the selected role
  final DatabaseReference databaseRef = FirebaseDatabase.instance.reference(); // Firebase reference

  void saveRoleToFirebase(String userId) async {
    if (selectedRole != null) {
      // Save the selected role to Firebase under the userId
      await databaseRef.child('users/$userId').update({
        'model1_role': selectedRole, // Add/update the role
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Role saved successfully!")),
      );

      // Navigate to the next page (if applicable)
      // Replace with your next page's route
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Model2()),
      );
    } else {
      // Show a snackbar if no role is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a role.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserState>(context).userId;

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
              "Tell us more about your role",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Choose the categories that fit you best.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            // Role buttons
            buildRoleButton("Fashion Models"),
            buildRoleButton("Commercial Models"),
            buildRoleButton("Fitness Models"),
            buildRoleButton("Editorial Models"),
            Spacer(),
            // Next button
            ElevatedButton(
              onPressed: () => saveRoleToFirebase(userId), // Save role on click
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
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

  Widget buildRoleButton(String roleName) {
    return GestureDetector(
      onTap: () => setState(() => selectedRole = roleName),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedRole == roleName ? Colors.blue : Colors.black,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            roleName,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
