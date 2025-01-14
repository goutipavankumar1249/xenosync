import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:login_app/components/individual/NarrowInfluencer.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class Model2 extends StatefulWidget {
  @override
  _Model2State createState() => _Model2State();
}

class _Model2State extends State<Model2> {
  String? selectedRole; // Store the selected role
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firebase reference

  void saveRoleToFirebase(String userId) async {
    if (selectedRole != null) {
      // Save the selected role to Firebase under the userId
      await _firestore.collection('users').doc('$userId').collection('details').doc('collaborate').set({
        'collaborate with': selectedRole, // Add/update the role
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Role saved successfully!")),
      );

      // Navigate to the next page (if applicable)
      // Replace with your next page's route
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NarrowInfluencer()),
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
              "What do you want to collaborate with?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "select oen to proceed.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            // Role buttons
            buildRoleButton("Agency"),
            buildRoleButton("Model"),
            buildRoleButton("Production Crew"),
            buildRoleButton("influencer"),
            buildRoleButton("Brand"),
            buildRoleButton("Production House"),
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
