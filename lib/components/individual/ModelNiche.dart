import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_app/components/individual/Model2.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class ModelNiche extends StatefulWidget {
  @override
  _ModelNicheState createState() => _ModelNicheState();
}

class _ModelNicheState extends State<ModelNiche> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Options
  final List<String> nicheOptions = [
    "Ramp Walk Model",
    "Fashion Model",
    "Editorial Model",
    "Commercial Model",
    "Fitness Model",
    "Lingerie/Bikini Model",
    "Plus-Size Model",
    "Product/Commercial Shoots",
    "Runway/Showroom",
    "Photographic Model"
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
        SnackBar(content: Text("Please select at least one niche.")),
      );
      return;
    }

    await _firestore
        .collection('users')
        .doc('$userId')
        .collection('details')
        .doc('Model Niche')
        .set({
      "niches": selectedNiche.toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Details saved successfully!")),
    );

    // Navigate to the next page
    Navigator.push(context, MaterialPageRoute(builder: (context) => Model2()));
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserState>(context).userId;

    return Scaffold(
      backgroundColor: Colors.white, // Set white background
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Shot OK",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white, // Set white background for AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading
                  Text(
                    "Tell us more about your role",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat', // Montserrat font
                    ),
                  ),
                  SizedBox(height: 10),
                  // Subtitle
                  Text(
                    "Choose the categories that fit you best.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6b6b6b), // Color #6b6b6b
                      fontFamily: 'Source Sans Pro', // Source Sans Pro font
                      fontWeight: FontWeight.w400, // Font weight 400
                    ),
                  ),
                  SizedBox(height: 20),

                  // Model Niche Section
                  Text(
                    "Model Niche",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat', // Montserrat font
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildChipGroup(nicheOptions, selectedNiche),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Fixed Next Button at the Bottom
          Container(
            width: double.infinity, // Full width
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _saveData(userId),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Color(0xFF004DAB), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Montserrat', // Montserrat font
                  fontWeight: FontWeight.w700, // Font weight 700
                ),
              ),
            ),
          ),
        ],
      ),
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
            backgroundColor:
                isSelected ? Color(0xFF081B48) : Colors.transparent,
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
