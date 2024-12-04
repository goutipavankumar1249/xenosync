import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:login_app/components/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'ImageDetailPage.dart';
import 'UserState.dart';


class UploadImagesPage extends StatefulWidget {
  const UploadImagesPage({Key? key}) : super(key: key);

  @override
  State<UploadImagesPage> createState() => _UploadImagesPageState();
}

class _UploadImagesPageState extends State<UploadImagesPage> {
  List<File?> selectedImages = [null, null, null, null, null, null];

  Future<void> _pickImage(int index, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImages[index] = File(pickedFile.path);
      });

      // Navigate to the detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDetailPage(
            imageFile: selectedImages[index]!,
            userId: userId,
            onSave: (description) {
              _uploadImage(selectedImages[index]!, description, userId);
            },
          ),
        ),
      );
    }
  }

  Future<void> _uploadImage(File image, String description, String userId) async {
    try {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/$userId/${DateTime.now().millisecondsSinceEpoch}');
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();

      // Save data to Realtime Database
      final databaseRef = FirebaseDatabase.instance.ref("users/$userId/images");
      await databaseRef.push().set({
        'imageUrl': imageUrl,
        'description': description,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserState>(context).userId; // Get userId from Provider

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Images",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Upload your best images to attract businesses."),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio:0.7,
                ),
                itemCount: selectedImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _pickImage(index, userId),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: selectedImages[index] != null
                          ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              selectedImages[index]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImages[index] = null;
                                });
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.close, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      )
                          : const Center(
                        child: Icon(Icons.add, color: Colors.blue, size: 30),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Upload Images Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadImagesPage()), // Use the correct class name
                );
              }, // Save role on click
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
    );
  }
}
