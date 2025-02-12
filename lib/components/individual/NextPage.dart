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

      // Navigate to a specific page based on the role
      if (selectedRole == "Model") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ModelNiche()), // Navigate to ModelNiche
        );
      } else if (selectedRole == "Influencer") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfluencerNiche()), // Navigate to InfluencerNiche
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductionCrew()), // Navigate to ProductionCrew
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Role saved successfully!")),
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
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text(
            "Shot OK", // Brand name
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Montserrat', // Montserrat font
            ),
          ),
        ),
        elevation: 0, // Remove shadow
        backgroundColor: Colors.transparent, // Transparent background
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Text(
              "Welcome! Let’s get to know you better",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat', // Montserrat font
              ),
            ),
            SizedBox(height: 10),
            // Subtitle text
            Text(
              "Choose your role to customize your experience.",
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
              onTap: () => setState(() => selectedRole = "Model"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedRole == "Model"
                        ? Color(0xFF004DAB) // Highlight border color #004DAB
                        : Color(0xFF425164), // Default border color #425164
                    width: selectedRole == "Model" ? 2.5 : 1.5, // Thicker border for selected
                  ),
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    "Model",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat', // Montserrat font
                      fontWeight: FontWeight.w500, // Font weight 500
                      color: selectedRole == "Model"
                          ? Color(0xFF004DAB) // Highlight text color #004DAB
                          : Colors.black, // Default text color
                    ),
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
                    color: selectedRole == "Influencer"
                        ? Color(0xFF004DAB) // Highlight border color #004DAB
                        : Color(0xFF425164), // Default border color #425164
                    width: selectedRole == "Influencer" ? 2.5 : 1.5, // Thicker border for selected
                  ),
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    "Influencer",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat', // Montserrat font
                      fontWeight: FontWeight.w500, // Font weight 500
                      color: selectedRole == "Influencer"
                          ? Color(0xFF004DAB) // Highlight text color #004DAB
                          : Colors.black, // Default text color
                    ),
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
                    color: selectedRole == "Production Crew"
                        ? Color(0xFF004DAB) // Highlight border color #004DAB
                        : Color(0xFF425164), // Default border color #425164
                    width: selectedRole == "Production Crew" ? 2.5 : 1.5, // Thicker border for selected
                  ),
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    "Production Crew",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat', // Montserrat font
                      fontWeight: FontWeight.w500, // Font weight 500
                      color: selectedRole == "Production Crew"
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
                onPressed: () => saveRoleToFirebase(userId), // Save role on click
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