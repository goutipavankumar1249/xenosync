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

  // Age Range
  double _ageValue = 18; // Default age
  final double _minAge = 10;
  final double _maxAge = 60;

  // Gender
  String? _selectedGender;

  // Height
  double _heightValue = 150; // Default height in cm
  final double _minHeight = 100;
  final double _maxHeight = 220;

  // Body Color
  String? _selectedBodyColor;

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
      "age": _ageValue.round(),
      "gender": _selectedGender,
      "height": _heightValue.round(),
      "bodyColor": _selectedBodyColor,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Narrow influencer details saved successfully!")),
    );

    // Navigate to the next page
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
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Let’s narrow it down",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat', // Montserrat font
                    ),
                  ),
                  SizedBox(height: 10),
                  // Subtitle
                  Text(
                    "Choose one or more collaboration types.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6b6b6b), // Color #6b6b6b
                      fontFamily: 'Source Sans Pro', // Source Sans Pro font
                      fontWeight: FontWeight.w400, // Font weight 400
                    ),
                  ),
                  SizedBox(height: 20),

                  // Niche Section
                  _buildSectionTitle("Niche"),
                  _buildChipGroup(nicheOptions, selectedNiche),
                  SizedBox(height: 30),

                  // Available On Section
                  _buildSectionTitle("Available On"),
                  _buildChipGroup(availableOptions, selectedAvailable),
                  SizedBox(height: 30),

                  // Audience Size Section
                  _buildSectionTitle("Audience Size"),
                  _buildChipGroup(audienceSizeOptions, selectedAudienceSize),
                  SizedBox(height: 30),

                  // Bio Section
                  _buildSectionTitle("Bio"),
                  TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      hintText: "Enter your bio...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xFF425164), // Border color #425164
                          width: 1.5, // Border width
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xFF425164), // Border color #425164
                          width: 1.5, // Border width
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xFF425164), // Border color #425164
                          width: 1.5, // Border width
                        ),
                      ),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 30),

                  // Age Range Slider
                  _buildSectionTitle("Age Range"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_ageValue > _minAge) _ageValue--;
                          });
                        },
                      ),
                      Expanded(
                        child: Slider(
                          value: _ageValue,
                          min: _minAge,
                          max: _maxAge,
                          divisions: (_maxAge - _minAge).toInt(),
                          label: _ageValue.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _ageValue = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (_ageValue < _maxAge) _ageValue++;
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    "Selected Age: ${_ageValue.round()}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Source Sans Pro', // Source Sans Pro font
                    ),
                  ),
                  SizedBox(height: 20),

                  // Gender Selection
                  _buildSectionTitle("Gender"),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildGenderChip("Male"),
                      _buildGenderChip("Female"),
                      _buildGenderChip("Other"),
                    ],
                  ),
                  Text(
                    "Selected Gender: ${_selectedGender ?? "Not selected"}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Source Sans Pro', // Source Sans Pro font
                    ),
                  ),
                  SizedBox(height: 20),

                  // Height Slider
                  _buildSectionTitle("Height (cm)"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_heightValue > _minHeight) _heightValue--;
                          });
                        },
                      ),
                      Expanded(
                        child: Slider(
                          value: _heightValue,
                          min: _minHeight,
                          max: _maxHeight,
                          divisions: (_maxHeight - _minHeight).toInt(),
                          label: _heightValue.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _heightValue = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (_heightValue < _maxHeight) _heightValue++;
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    "Selected Height: ${_heightValue.round()} cm",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Source Sans Pro', // Source Sans Pro font
                    ),
                  ),
                  SizedBox(height: 20),

                  // Body Color Selection
                  _buildSectionTitle("Body Color"),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildBodyColorChip("Fair"),
                      _buildBodyColorChip("Medium"),
                      _buildBodyColorChip("Dark"),
                    ],
                  ),
                  Text(
                    "Selected Body Color: ${_selectedBodyColor ?? "Not selected"}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Source Sans Pro', // Source Sans Pro font
                    ),
                  ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat', // Montserrat font
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

  Widget _buildGenderChip(String gender) {
    bool isSelected = _selectedGender == gender;
    return ChoiceChip(
      label: Text(gender),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedGender = selected ? gender : null;
        });
      },
      selectedColor: Color(0xFF081B48),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Color(0xFF081B48),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Color(0xFF081B48)),
      ),
    );
  }

  Widget _buildBodyColorChip(String color) {
    bool isSelected = _selectedBodyColor == color;
    return ChoiceChip(
        label: Text(color),
    selected: isSelected,
    onSelected: (selected) {
    setState(() {
    _selectedBodyColor = selected ? color : null;
    });
    },
    selectedColor: Color(0xFF081B48),
    labelStyle: TextStyle(
    color: isSelected ? Colors.white : Color(0xFF081B48),
    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    ),
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(color: Color(0xFF081B48)),
    ));
  }
}