import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:login_app/components/individual/DetailsForInfluencer.dart';
import 'package:login_app/components/individual/PassionPage.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class AudienceForInfluencer extends StatefulWidget {
  @override
  _AudienceForInfluencerState createState() => _AudienceForInfluencerState();
}

class _AudienceForInfluencerState extends State<AudienceForInfluencer> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

  // Options
  final List<String> nicheOptions = [
    "Lifestyle",
    "Fashion & Beauty",
    "Technology & Gadgets",
    "Travel & Adventure",
    "Health & Fitness",
    "Music",
    "Parenting & Family",
    "Food & Beverage",
    "Sports",
    "Finance & Business",
    "Gaming & Esports",
    "Art & Design"
  ];

  final List<String> platformFocusOptions = [
    "TikTok",
    "Facebook",
    "LinkedIn",
    "Pinterest",
    "Instagram",
    "Youtube",
    "Snapchat",
    "Twitch",
    "Reddit",
    "Podcasts",
    "Clubhouse"
  ];

  final List<String> audienceSizeOptions = [
    "1k-10k",
    "10k-50k",
    "50k-100k",
    "100k+"
  ];

  // Selected options
  final Set<String> selectedNiche = {};
  final Set<String> selectedPlatformFocus = {};
  final Set<String> selectedAudienceSize = {};

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
        selectedPlatformFocus.isEmpty &&
        selectedAudienceSize.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one option.")),
      );
      return;
    }

    await databaseRef.child("users/$userId").set({
      "niches": selectedNiche.toList(),
      "platform_focus": selectedPlatformFocus.toList(),
      "audience_size": selectedAudienceSize.toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Audience for influencer details saved successfully!")),
    );

    // Navigate to the next page (if applicable)
    Navigator.push(context, MaterialPageRoute(builder: (context) => PassionPage()));
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
              "Let's personalize your profile!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Tell us about your interests and niche to find the best matches for you.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            _buildSectionTitle("Niche"),
            _buildChipGroup(nicheOptions, selectedNiche),
            SizedBox(height: 30),
            _buildSectionTitle("Platform Focus"),
            _buildChipGroup(platformFocusOptions, selectedPlatformFocus),
            SizedBox(height: 30),
            _buildSectionTitle("Audience Size"),
            _buildChipGroup(audienceSizeOptions, selectedAudienceSize),
            SizedBox(height:50),
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
      spacing: 8,
      runSpacing: 8,
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
