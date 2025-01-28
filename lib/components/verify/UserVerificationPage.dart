import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path/path.dart' as path;

class UserVerificationPage extends StatefulWidget {
  final String userId; // Accept userId as a parameter

  // Constructor to accept userId
  UserVerificationPage({required this.userId});

  @override
  _UserVerificationPageState createState() => _UserVerificationPageState();
}

class _UserVerificationPageState extends State<UserVerificationPage> {
  File? aadharCardImage;
  File? selfieImage;
  bool aadharUpload = false;
  bool selfieUpload = false;

  final picker = ImagePicker();

  // User details from passed userId
  String get userId => widget.userId;
  final String username = FirebaseAuth.instance.currentUser!.displayName ?? "Unknown User";
  final String role = "user"; // This can be dynamic

  Future<void> pickImage(bool isAadhar) async {
    ImageSource source = isAadhar ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (isAadhar) {
          aadharCardImage = File(pickedFile.path);
          aadharUpload = true;
        } else {
          selfieImage = File(pickedFile.path);
          selfieUpload = true;
        }
      });
    }
  }

  // Send email with images and user details
  Future<void> sendEmail() async {
    final Email email = Email(
      body: 'User: $username\nRole: $role\nUser ID: $userId\nAadhar Card Uploaded: $aadharUpload\nSelfie Uploaded: $selfieUpload',
      subject: 'User Verification Details',
      recipients: ['ssuryabackup@gmail.com'],
      attachmentPaths: [
        if (aadharCardImage != null) aadharCardImage!.path,
        if (selfieImage != null) selfieImage!.path,
      ],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  // Update user status in Firebase
  Future<void> updateUserStatus() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    await userDoc.update({
      'aadharUpload': aadharUpload,
      'selfieUpload': selfieUpload,
      'verifiedAccount': false, // Initially set to false, to be verified later by admin
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Verification"),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView for scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aadhar Card upload option
            ElevatedButton(
              onPressed: () => pickImage(true), // Use ImageSource.gallery for Aadhar
              child: Text("Upload Aadhar Card"),
            ),
            if (aadharCardImage != null)
              Image.file(aadharCardImage!),

            SizedBox(height: 16),

            // Selfie upload option
            ElevatedButton(
              onPressed: () => pickImage(false), // Use ImageSource.camera for Selfie
              child: Text("Upload Selfie"),
            ),
            if (selfieImage != null)
              Image.file(selfieImage!),

            SizedBox(height: 16),

            // Submit button
            ElevatedButton(
              onPressed: () async {
                await sendEmail();
                await updateUserStatus();
                // Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Verification files submitted successfully!'),
                ));
              },
              child: Text("Submit Verification"),
            ),
          ],
        ),
      ),
    );
  }
}