import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:login_app/components/UploadImagesPage.dart';
import 'package:provider/provider.dart';

import '../UserState.dart';

class PassionPage extends StatefulWidget {
  @override
  _PassionPageState createState() => _PassionPageState();
}

class _PassionPageState extends State<PassionPage> {
  // List of options for passions
  final List<String> passionOptions = [
    "Lifestyle",
    "Fashion & Beauty",
    "Technology & Gadgets",
    "Travel & Adventure",
    "Health & Fitness",
    "Music",
    "Parenting & Family",
    "Books & Literature",
    "Food & Beverage",
    "Sports",
    "Gaming & Esports",
    "Art & Design",
    "Finance & Business",
  ];

  // Selected passions
  final Set<String> selectedPassions = {};
  void togglePassion(String option) {
    setState(() {
      if (selectedPassions.contains(option)) {
        selectedPassions.remove(option);
      } else {
        selectedPassions.add(option);
      }
    });
  }

  Future<void> savePassionsToFirebase(String userId) async {
    try {
      // Firebase Realtime Database instance
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore.collection('users').doc('$userId').collection('intrest').doc('passion').set({
        "passion" :selectedPassions.toList(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passions saved successfully!")),
      );
      // Navigate to the next page (if applicable)
      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImagesPage()));

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save passions: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserState>(context).userId;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Passions",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Tell us about your interests and niche to find the best matches for you.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: passionOptions.map((option) {
                    bool isSelected = selectedPassions.contains(option);
                    return GestureDetector(
                      onTap: () => togglePassion(option),
                      child: Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(option),
                            if (isSelected) ...[
                              SizedBox(width: 5),
                              Icon(Icons.close, size: 16, color: Colors.white),
                            ],
                          ],
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Color(0xFF081B48),
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor:
                        isSelected ? Color(0xFF081B48) : Colors.transparent,
                        side: BorderSide(color: Color(0xFF081B48)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedPassions.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select at least one option")),
                  );
                } else {
                  savePassionsToFirebase(userId);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Color(0xFF081B48),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
