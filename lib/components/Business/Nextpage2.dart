import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_app/components/Business/Brand.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';
import 'AgencyNiche.dart';
import 'BrandNiche.dart';
import 'ProductionType.dart';

class NextPage2 extends StatefulWidget {
  @override
  _NextPage2State createState() => _NextPage2State();
}

class _NextPage2State extends State<NextPage2> {
  String? selectedRole; // Store the selected role
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firebase reference



  void saveRoleToFirebase(String userId) async {
    if (selectedRole != null) {
      // Save the selected role to Firebase under the userId
      await _firestore.collection('users').doc('$userId').collection('details').doc('$selectedRole').set({
        'individual': selectedRole, // Add/update the role
      });

      // Navigate to the next page (if applicable)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Brand()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Role saved successfully!")),
      );

      // Navigate to a specific page based on the role
      if (selectedRole == "Model") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BrandNiche()), // Navigate to IndividualPage
        );
      } else if (selectedRole == "Influencer") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgencyNiche()), // Navigate to BusinessPage
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              ProductionType()), // Navigate to BusinessPage
        );
      }

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
              "Welcome! Let's find your focus",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "What type of business are you? ",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            // Role buttons
            GestureDetector(
              onTap: () => setState(() => selectedRole = "Brand"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedRole == "Brand"
                        ? Colors.blue
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Brand",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedRole = "Agency"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    selectedRole == "Agency" ? Colors.blue : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Agency",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedRole = "Production House"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    selectedRole == "Production House" ? Colors.blue : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Productive House",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),

            Spacer(),
            // Next button
            ElevatedButton(
              onPressed: () => saveRoleToFirebase(userId), // Save role on click
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
