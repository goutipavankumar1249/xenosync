import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_app/components/individual/DetailsForInfluencer.dart';
import 'package:provider/provider.dart';
import '../UserState.dart';

class SocialMedia extends StatefulWidget {
  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<String> selectedPlatforms = {};

  final List<String> platforms = [
    "Instagram",
    "YouTube",
    "Moj",
    "ShareChat",
    "Facebook",
    "LinkedIn",
  ];

  Future<void> _saveData(String userId) async {
    if (selectedPlatforms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one platform")),
      );
      return;
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('details')
        .doc('Social Media')
        .set({
      "platforms": selectedPlatforms.toList(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsForInfluencer()),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserState>(context).userId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Shot OK",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Your Social Media Platforms",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Choose the platforms where you have an active presence.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6b6b6b),
                      fontFamily: 'Source Sans Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: platforms.map((platform) {
                      bool isSelected = selectedPlatforms.contains(platform);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedPlatforms.remove(platform);
                            } else {
                              selectedPlatforms.add(platform);
                            }
                          });
                        },
                        child: Chip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(platform),
                              if (isSelected) ...[
                                SizedBox(width: 5),
                                Icon(Icons.close,
                                    size: 16, color: Colors.white),
                              ],
                            ],
                          ),
                          labelStyle: TextStyle(
                            color:
                                isSelected ? Colors.white : Color(0xFF081B48),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontFamily: 'Montserrat',
                          ),
                          backgroundColor: isSelected
                              ? Color(0xFF081B48)
                              : Colors.transparent,
                          side: BorderSide(color: Color(0xFF081B48)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF004DAB), Color(0xFF09163D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40F4FAFF),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _saveData(userId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                    height: 26 / 19,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
