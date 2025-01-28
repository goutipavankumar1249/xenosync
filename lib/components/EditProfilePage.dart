import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String? _fullName;
  String? _bio;
  String? _dateOfBirth;
  String? _location;
  String? _instagramHandle;
  String? _phoneNumber;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfileData() async {
    String? imageUrl;

    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("users/${widget.userId}/profile_image");
      await storageRef.putFile(_imageFile!);
      imageUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('intrest')
        .doc('basic details')
        .update({
      'full_name': _fullName,
      'bio': _bio,
      'date_of_birth': _dateOfBirth,
      'location': _location,
      'instagram_handle': _instagramHandle,
      'phone_number': _phoneNumber,
      'image_url': imageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Edit Profile")),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage:
                      _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? const Icon(Icons.camera_alt, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Full Name"),
                    onSaved: (value) => _fullName = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Bio"),
                    onSaved: (value) => _bio = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Date of Birth"),
                    onSaved: (value) => _dateOfBirth = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Location"),
                    onSaved: (value) => _location = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Instagram Handle"),
                    onSaved: (value) => _instagramHandle = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Phone Number"),
                    onSaved: (value) => _phoneNumber = value,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      _saveProfileData();
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        );
    }
}