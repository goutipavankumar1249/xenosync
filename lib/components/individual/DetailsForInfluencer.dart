import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/components/individual/AudienceForInfluencer.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../UserState.dart';

class DetailsForInfluencer extends StatefulWidget {
  @override
  _DetailsForInfluencerState createState() => _DetailsForInfluencerState();
}

class _DetailsForInfluencerState extends State<DetailsForInfluencer> {
  final _formKey = GlobalKey<FormState>();
  String? fullName, dateOfBirth, location, instagramHandle, phoneNumber;
  File? _imageFile;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveData(String userId) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload image to Firebase Storage
      String? imageUrl;
      if (_imageFile != null) {
        final storageRef =
        FirebaseStorage.instance.ref().child("influencers/$userId/profile_image.jpg");
        await storageRef.putFile(_imageFile!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Save data to Firebase Realtime Database
      await databaseRef.child("users/$userId/influencer data").set({
        "full_name": fullName,
        "date_of_birth": dateOfBirth,
        "location": location,
        "instagram_handle": instagramHandle,
        "phone_number": phoneNumber,
        "image_url": imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Influencer details saved successfully!")),
      );

      // Navigate to the next page (if applicable)
      Navigator.push(context, MaterialPageRoute(builder: (context) => AudienceForInfluencer()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields correctly.")),
      );
    }
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's get to know you!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Fill out the basics to set up your profile.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? Icon(Icons.camera_alt, size: 40, color: Colors.blue)
                            : null,
                      ),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.add, size: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Upload a picture that represents you.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(
                label: "Full Name",
                hint: "Enter your full name...",
                onSaved: (value) => fullName = value,
              ),
              _buildTextField(
                label: "Date of Birth",
                hint: "DD/MM/YYYY",
                onSaved: (value) => dateOfBirth = value,
              ),
              _buildTextField(
                label: "Phone Number",
                hint: "Enter your phone number...",
                onSaved: (value) => phoneNumber = value,
              ),
              _buildTextField(
                label: "Location",
                hint: "City, Country",
                onSaved: (value) => location = value,
              ),
              _buildTextField(
                label: "Instagram Handle",
                hint: "Enter your Instagram handle link...",
                onSaved: (value) => instagramHandle = value,
              ),
              SizedBox(height:20),
              ElevatedButton(
                onPressed: () => _saveData(userId),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This field cannot be empty.";
              }
              return null;
            },
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }
}
