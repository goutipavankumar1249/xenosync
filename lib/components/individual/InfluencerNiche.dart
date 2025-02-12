import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_app/components/individual/SocialMedia.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class InfluencerNiche extends StatefulWidget {
  @override
  _InfluencerNicheState createState() => _InfluencerNicheState();
}

class _InfluencerNicheState extends State<InfluencerNiche> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Options
  final List<String> nicheOptions = [
    "Fashion",
    "Beauty & Makeup",
    "Fitness & Health",
    "Tech & Gadgets",
    "Lifestyle",
    "Food & Beverage",
    "Automobile",
    "Travel",
    "Gaming",
    "Photography & Art",
    "Parenting & Family",
    "Entertainment (Music, Dance, etc.)",
    "Digital Content Creation"
  ];

  // Selected options
  final Set<String> selectedNiche = {};

  void toggleSelection(String option) {
    setState(() {
      if (selectedNiche.contains(option)) {
        selectedNiche.remove(option);
      } else {
        selectedNiche.add(option);
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

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('details')
        .doc('Influencer Niche')
        .set({
      "niches": selectedNiche.toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Influencer Niche details saved successfully!")),
    );

    // Navigate to the next page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SocialMedia()));
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserState>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shot OK",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              "Influencer Niche",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(height: 10),

            // Subtitle
            Text(
              "Choose one or more Influencer Niche",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Niche Section
            _buildSectionTitle("Niche"),
            Expanded(child: _buildChipGroup()),

            // "Next" Button fixed at bottom
            _buildGradientButton(userId),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
    );
  }

  Widget _buildChipGroup() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: nicheOptions.map((option) {
          bool isSelected = selectedNiche.contains(option);
          return GestureDetector(
            onTap: () => toggleSelection(option),
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
                fontFamily: 'Montserrat',
              ),
              backgroundColor: isSelected ? Color(0xFF081B48) : Colors.transparent,
              side: BorderSide(color: Color(0xFF081B48)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGradientButton(String userId) {
    return GestureDetector(
      onTap: () => _saveData(userId),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // Adjusted width
        height: 50, // Consistent button height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), // Rounded corners
          gradient: LinearGradient(
            colors: [Color(0xFF004DAB), Color(0xFF09163D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x66F4FAFF), // Shadow effect
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Next",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 19,
              height: 26 / 19, // Line height adjustment
            ),
          ),
        ),
      ),
    );
  }
}
