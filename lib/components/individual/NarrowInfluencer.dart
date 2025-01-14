import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_app/components/individual/DetailsForInfluencer.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class NarrowInfluencer extends StatefulWidget {
  @override
  _NarrowInfluencerState createState() => _NarrowInfluencerState();
}

class _NarrowInfluencerState extends State<NarrowInfluencer> {
  // Firestore reference
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Options
  final List<String> nicheOptions = [
    "Influencers",
    "Bloggers",
    "Podcasters",
    "Life Style",
    "Life Style",
    "Life Style",
    "Life Style"
  ];

  final List<String> availableOptions = [
    "Instagram",
    "Facebook",
    "LinkedIn",
    "Pinterest",
    "Youtube",
    "Snapchat",
    "Twitch",
    "Reddit",
    "Podcasts",
  ];

  final List<String> audienceSizeOptions = [
    "<1k",
    "1k-10k",
    "10k-50k",
    "50k-100k",
    "100k+"
  ];

  // Selected options
  final Set<String> selectedNiche = {};
  final Set<String> selectedAvailable = {};
  final Set<String> selectedAudienceSize = {};

  // Bio controller
  final TextEditingController bioController = TextEditingController();

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
    if (selectedNiche.isEmpty &&
        selectedAvailable.isEmpty &&
        selectedAudienceSize.isEmpty &&
        bioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one option and enter your bio.")),
      );
      return;
    }

    await firestore.collection("users").doc(userId).collection('intrest').doc('narrowinfluencer').set({
      "niches": selectedNiche.toList(),
      "available": selectedAvailable.toList(),
      "audience_size": selectedAudienceSize.toList(),
      "bio": bioController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Narrow influencer details saved successfully!")),
    );

    // Navigate to the next page (if applicable)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsForInfluencer()),
    );
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
              "Let's narrow it down",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Choose one or more collaboration types.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            _buildSectionTitle("Niche"),
            _buildChipGroup(nicheOptions, selectedNiche),
            SizedBox(height: 30),
            _buildSectionTitle("Available On"),
            _buildChipGroup(availableOptions, selectedAvailable),
            SizedBox(height: 30),
            _buildSectionTitle("Audience Size"),
            _buildChipGroup(audienceSizeOptions, selectedAudienceSize),
            SizedBox(height: 30),
            _buildSectionTitle("Bio"),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                hintText: "Enter your bio...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
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
