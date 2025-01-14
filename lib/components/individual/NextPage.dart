import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_app/components/individual/InfluencerPage.dart';
import 'package:login_app/components/individual/ModelNiche.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';
import 'InfluencerNiche.dart';
import 'ProductionCrew.dart';

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String? selectedRole; // Store the selected role
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firebase reference



  void saveRoleToFirebase(String userId) async {
    if (selectedRole != null) {
      // Save the selected role to Firebase under the userId
      await _firestore.collection('users').doc('$userId').collection('details').doc('$selectedRole').set({
        'individual': selectedRole, // Add/update the role
      });

      //Navigate to the next page (if applicable)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ModelNiche() ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Role saved successfully!")),
      );

      // Navigate to a specific page based on the role
      if (selectedRole == "Model") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ModelNiche()), // Navigate to IndividualPage
        );
      } else if (selectedRole == "Influencer") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfluencerNiche()), // Navigate to BusinessPage
        );
      } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductionCrew()), // Navigate to BusinessPage
      );
    }

    }else {
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
              onTap: () => setState(() => selectedRole = "Model"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedRole == "Model"
                        ? Colors.blue
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Model",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedRole = "Influencer"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    selectedRole == "Influencer" ? Colors.blue : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Influencer",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => selectedRole = "Production Crew"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    selectedRole == "Production Crew" ? Colors.blue : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Production Crew",
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
