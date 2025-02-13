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
  String? _youtubeHandle;
  String? _mojHandle;
  String? _shareChatHandle;
  String? _facebookHandle;
  String? _linkedInHandle;
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
      'youtube_handle': _youtubeHandle,
      'moj_handle': _mojHandle,
      'sharechat_handle': _shareChatHandle,
      'facebook_handle': _facebookHandle,
      'linkedin_handle': _linkedInHandle,
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
      backgroundColor: Colors.white, // Set white background
      appBar: AppBar(
        backgroundColor: Colors.white, // White background for AppBar
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF081B48), // Changed to #081B48
          ),
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
                        backgroundColor: const Color(0xFF081B48)
                            .withOpacity(0.1), // Light #081B48
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? Icon(Icons.person,
                                size: 60,
                                color: const Color(0xFF081B48)
                                    .withOpacity(0.5)) // #081B48 with opacity
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF081B48), // Changed to #081B48
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
                onSaved: (value) => _fullName = value,
                validator: (value) =>
                    value!.isEmpty ? "Full Name is required" : null,
              ),
              const SizedBox(height: 20),

              // Bio Field
              _buildInputField(
                label: "Bio",
                onSaved: (value) => _bio = value,
              ),
              const SizedBox(height: 20),

              // Date of Birth Field
              _buildInputField(
                label: "Date of Birth",
                onSaved: (value) => _dateOfBirth = value,
              ),
              const SizedBox(height: 20),

              // Location Field
              _buildInputField(
                label: "Location",
                onSaved: (value) => _location = value,
              ),
              const SizedBox(height: 20),

              // Instagram Handle Field
              _buildInputField(
                label: "Instagram Handle",
                onSaved: (value) => _instagramHandle = value,
              ),
              const SizedBox(height: 20),

              // YouTube Handle Field
              _buildInputField(
                label: "YouTube Handle",
                onSaved: (value) => _youtubeHandle = value,
              ),
              const SizedBox(height: 20),

              // Moj Handle Field
              _buildInputField(
                label: "Moj Handle",
                onSaved: (value) => _mojHandle = value,
              ),
              const SizedBox(height: 20),

              // ShareChat Handle Field
              _buildInputField(
                label: "ShareChat Handle",
                onSaved: (value) => _shareChatHandle = value,
              ),
              const SizedBox(height: 20),

              // Facebook Handle Field
              _buildInputField(
                label: "Facebook Handle",
                onSaved: (value) => _facebookHandle = value,
              ),
              const SizedBox(height: 20),

              // LinkedIn Handle Field
              _buildInputField(
                label: "LinkedIn Handle",
                onSaved: (value) => _linkedInHandle = value,
              ),
              const SizedBox(height: 20),

              // Phone Number Field
              _buildInputField(
                label: "Phone Number",
                onSaved: (value) => _phoneNumber = value,
              ),
              const SizedBox(height: 30),

              // Save Button
              Center(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF004DAB),
                        Color(0xFF081B48), // Changed end color to #081B48
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF081B48)
                            .withOpacity(0.25), // Changed shadow color
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfileData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 19,
                            ),
                          ),
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
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
            color: Color(0xFF081B48), // Changed to #081B48
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Enter your $label...",
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Color(0xFF081B48), // Changed to #081B48
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Color(0xFF081B48), // Changed to #081B48
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Color(0xFF081B48), // Changed to #081B48
                width: 1.5,
              ),
            ),
          ),
          onSaved: onSaved,
          validator: validator,
        ),
      ],
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
