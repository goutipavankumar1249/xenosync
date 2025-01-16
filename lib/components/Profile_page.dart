import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'UserState.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  String? fullName;
  String? dateOfBirth;
  String? location;
  String? instagramHandle;
  String? phoneNumber;
  String? bio;
  String? imageUrl;

  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfileData(String userId) async {
    String? uploadedImageUrl;
    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("influencers/$userId/profile_image.jpg");
      await storageRef.putFile(_imageFile!);
      uploadedImageUrl = await storageRef.getDownloadURL();
    }

    await firestore
        .collection('users')
        .doc(userId)
        .collection('intrest')
        .doc('basic details')
        .set({
      "full_name": fullName,
      "date_of_birth": dateOfBirth,
      "location": location,
      "instagram_handle": instagramHandle,
      "phone_number": phoneNumber,
      "image_url": uploadedImageUrl ?? imageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  Future<Map<String, dynamic>> _fetchProfileData(String userId) async {
    try {
      final userDoc = await firestore
          .collection('users')
          .doc(userId)
          .collection('intrest')
          .doc('basic details')
          .get();
      if (userDoc.exists) {
        return userDoc.data() ?? {};
      } else {
        return {};
      }
    } catch (e) {
      print("Error fetching profile data: $e");
      return {};
    }
  }

  Future<List<String>> _fetchUserPosts(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('feed')
          .get();

      return querySnapshot.docs
          .map((doc) => doc['imageUrl'] as String)
          .toList();
    } catch (e) {
      print("Error fetching user posts: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserState>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xeno Sync'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchProfileData(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final profileData = snapshot.data!;
            fullName = profileData['full_name'] ?? "Unknown";
            dateOfBirth = profileData['date_of_birth'] ?? "Not specified";
            location = profileData['location'] ?? "Not specified";
            instagramHandle = profileData['instagram_handle'] ?? "Not specified";
            phoneNumber = profileData['phone_number'] ?? "Not specified";
            imageUrl = profileData['image_url'];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue.shade100,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (imageUrl != null ? NetworkImage(imageUrl!) : null)
                          as ImageProvider?,
                          child: _imageFile == null && imageUrl == null
                              ? const Icon(Icons.camera_alt, size: 40)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                fullName!,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB9DDFF),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                ),
                                child: const Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () => _saveProfileData(userId),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF081B48)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF081B48),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'My Bio',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bio ?? 'No bio available.',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Date of Birth: $dateOfBirth"),
                  Text("Location: $location"),
                  Text("Instagram: $instagramHandle"),
                  Text("Phone: $phoneNumber"),
                  const SizedBox(height: 20),
                  const Text(
                    'My Posts',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<String>>(
                    future: _fetchUserPosts(userId),
                    builder: (context, postSnapshot) {
                      if (postSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (postSnapshot.hasData) {
                        final postImages = postSnapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.64,
                          ),
                          itemCount: postImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(postImages[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return const Text("No posts available.");
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Failed to load profile data.'));
        },
      ),
    );
  }
}
