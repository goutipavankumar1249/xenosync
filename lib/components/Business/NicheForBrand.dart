import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:login_app/components/individual/PassionPage.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class NicheForBrand extends StatefulWidget {
  @override
  _NicheForBrandState createState() => _NicheForBrandState();
}

class _NicheForBrandState extends State<NicheForBrand> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

  // Options for Campaign Type and Influencer Niche
  final List<String> campaignTypeOptions = [
    "Product Promotion",
    "Events",
    "Giveaways",
    "Reviews",
    "Contests",
    "Music",
    "Parenting & Family",
    "Food & Beverage",
    "Sports",
    "Finance & Business",
    "Gaming & Esports",
    "Art & Design",
    "Books & Literature"
  ];

  final List<String> influencerNicheOptions = [
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

  // Selected options
  final Set<String> selectedCampaignTypes = {};
  final Set<String> selectedInfluencerNiches = {};

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
    if (selectedCampaignTypes.isEmpty && selectedInfluencerNiches.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one option.")),
      );
      return;
    }

    await databaseRef.child("users/$userId").set({
      "campaign_types": selectedCampaignTypes.toList(),
      "influencer_niches": selectedInfluencerNiches.toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Niche for brand details saved successfully!")),
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
          icon: Icon(Icons.arrow_back),
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
            Text(
              "Campaign Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing:8,
              runSpacing:8,
              children: campaignTypeOptions.map((option) {
                bool isSelected = selectedCampaignTypes.contains(option);
                return GestureDetector(
                  onTap: () => toggleSelection(option, selectedCampaignTypes),
                  child: Chip(
                    label: Text(option),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    backgroundColor: isSelected ? Color(0xFF081B48) : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFF081B48)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text(
              "Preferred Influencer Niche",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: influencerNicheOptions.map((option) {
                bool isSelected = selectedInfluencerNiches.contains(option);
                return GestureDetector(
                  onTap: () => toggleSelection(option, selectedInfluencerNiches),
                  child: Chip(
                    label: Text(option),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    backgroundColor: isSelected ? Color(0xFF081B48) : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFF081B48)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 40),
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
}
