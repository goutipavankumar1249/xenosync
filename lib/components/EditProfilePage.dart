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

  bool _isSaving = false; // To show a loading indicator

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfileData() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isSaving = true;
    });

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

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.person, size: 60, color: Colors.blue)
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Full Name Field
              _buildInputField(
                label: "Full Name",
                icon: Icons.person,
                onSaved: (value) => _fullName = value,
                validator: (value) =>
                value!.isEmpty ? "Full Name is required" : null,
              ),
              const SizedBox(height: 20),

              // Bio Field
              _buildInputField(
                label: "Bio",
                icon: Icons.info,
                onSaved: (value) => _bio = value,
              ),
              const SizedBox(height: 20),

              // Date of Birth Field
              _buildInputField(
                label: "Date of Birth",
                icon: Icons.calendar_today,
                onSaved: (value) => _dateOfBirth = value,
              ),
              const SizedBox(height: 20),

              // Location Field
              _buildInputField(
                label: "Location",
                icon: Icons.location_on,
                onSaved: (value) => _location = value,
              ),
              const SizedBox(height: 20),

              // Instagram Handle Field
              _buildInputField(
                label: "Instagram Handle",
                icon: Icons.link,
                onSaved: (value) => _instagramHandle = value,
              ),
              const SizedBox(height: 20),

              // Phone Number Field
              _buildInputField(
                label: "Phone Number",
                icon: Icons.phone,
                onSaved: (value) => _phoneNumber = value,
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfileData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Save",
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

  // Helper method to build consistent input fields
  Widget _buildInputField({
    required String label,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none, // Remove default underline
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// class EditProfilePage extends StatefulWidget {
//   final String userId;
//
//   const EditProfilePage({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//
//   String? _fullName;
//   String? _bio;
//   String? _dateOfBirth;
//   String? _location;
//   String? _instagramHandle;
//   String? _phoneNumber;
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _saveProfileData() async {
//     String? imageUrl;
//
//     if (_imageFile != null) {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child("users/${widget.userId}/profile_image");
//       await storageRef.putFile(_imageFile!);
//       imageUrl = await storageRef.getDownloadURL();
//     }
//
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.userId)
//         .collection('intrest')
//         .doc('basic details')
//         .update({
//       'full_name': _fullName,
//       'bio': _bio,
//       'date_of_birth': _dateOfBirth,
//       'location': _location,
//       'instagram_handle': _instagramHandle,
//       'phone_number': _phoneNumber,
//       'image_url': imageUrl,
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Profile updated successfully!")),
//     );
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text("Edit Profile")),
//         body: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.blue.shade100,
//                       backgroundImage:
//                       _imageFile != null ? FileImage(_imageFile!) : null,
//                       child: _imageFile == null
//                           ? const Icon(Icons.camera_alt, size: 40)
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Full Name"),
//                     onSaved: (value) => _fullName = value,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Bio"),
//                     onSaved: (value) => _bio = value,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Date of Birth"),
//                     onSaved: (value) => _dateOfBirth = value,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Location"),
//                     onSaved: (value) => _location = value,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Instagram Handle"),
//                     onSaved: (value) => _instagramHandle = value,
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Phone Number"),
//                     onSaved: (value) => _phoneNumber = value,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       _formKey.currentState?.save();
//                       _saveProfileData();
//                     },
//                     child: const Text("Save"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//     }
// }