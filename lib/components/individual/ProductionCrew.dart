import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_app/components/individual/DetailsForInfluencer.dart';
import 'package:login_app/components/individual/Model2.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class ProductionCrew extends StatefulWidget {
  @override
  _ProductionCrewState createState() => _ProductionCrewState();
}

class _ProductionCrewState extends State<ProductionCrew> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Options
  final List<String> nicheOptions = [
    "Camera Crew",
    "Lighting & Sound",
    "Makeup & Hair",
    "Styling",
    "Editing & Post-Production",
    "Director/Assistant Director",
    "AI Engineer (for digital/tech-driven productions)",
    "Game Developer (for gaming or digital content)",
    "Animator (for animation, CGI, VFX)"
  ];


  // Selected options
  final Set<String> selectedNiche = {};

  void toggleSelection(String option, Set<String> selectedSet) {
    setState(() {
      if (selectedSet.contains(option)) {
        selectedSet.remove(option);
      } else {
        selectedSet.add(option);
      }
    });
  }

  Future<void> _saveData(String userId) async {
    if (selectedNiche.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one option.")),
      );
      return;
    }

    await _firestore.collection('users').doc('$userId').collection('details').doc('ProductionCrew Niche').set({
      "niches": selectedNiche.toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("ProductionCrew Niche details saved successfully!")),
    );

    // Navigate to the next page (if applicable)
    Navigator.push(context, MaterialPageRoute(builder: (context) => Model2()));
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
              "Production Crew",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "choose one or more Production Crew",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            _buildSectionTitle("Niche"),
            _buildChipGroup(nicheOptions, selectedNiche),
            SizedBox(height: 220),
            ElevatedButton(
              onPressed: () => _saveData(userId),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildChipGroup(List<String> options, Set<String> selectedSet) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        bool isSelected = selectedSet.contains(option);
        return GestureDetector(
          onTap: () => toggleSelection(option, selectedSet),
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
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            backgroundColor: isSelected ? Color(0xFF081B48) : Colors.transparent,
            side: BorderSide(color: Color(0xFF081B48)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }).toList(),
    );
  }
}
