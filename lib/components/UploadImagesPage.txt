// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:login_app/components/HomePage.dart';
// import 'package:login_app/pages/home_page.dart';
// import 'package:provider/provider.dart';
// import 'ImageDetailPage.dart';
// import 'UserState.dart';
//
//
// class UploadImagesPage extends StatefulWidget {
//   const UploadImagesPage({Key? key}) : super(key: key);
//
//   @override
//   State<UploadImagesPage> createState() => _UploadImagesPageState();
// }
//
// class _UploadImagesPageState extends State<UploadImagesPage> {
//   List<File?> selectedImages = [null, null, null, null, null, null];
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> _pickImage(int index, String userId) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         selectedImages[index] = File(pickedFile.path);
//       });
//
//       // Navigate to the detail page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ImageDetailPage(
//             imageFile: selectedImages[index]!,
//             userId: userId,
//             onSave: (description) {
//               _uploadImage(selectedImages[index]!,description,userId);
//             },
//           ),
//         ),
//       );
//     }
//   }
//
//   Future<void> _uploadImage(File image, String description, String userId) async {
//     try {
//       final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
//
//       print('Starting image upload...');
//       // Upload image to Firebase Storage
//       final storageRef = FirebaseStorage.instance.ref().child('posts/$userId/$fileName');
//       await storageRef.putFile(image);
//
//       print('Image uploaded to storage.');
//       // Get the download URL
//       final imageUrl = await storageRef.getDownloadURL();
//       print('Download URL retrieved: $imageUrl');
//
//       // Save image details to Firestore
//       print('Uploading details to Firestore...');
//       await _firestore.collection('users')
//           .doc(userId)
//           .collection('posts')
//           .add({
//         'imageUrl': imageUrl,
//         'description': description,
//         'fileName': fileName,
//         'uploadedAt': FieldValue.serverTimestamp(),
//         'userId': userId,
//       });
//       print('Details uploaded successfully to Firestore.');
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Image uploaded successfully!")),
//       );
//     } catch (e, stackTrace) {
//       print("Error uploading image: $e");
//       print("Stack Trace: $stackTrace");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to upload image: $e")),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final userId = Provider.of<UserState>(context).userId; // Get userId from Provider
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Upload Images",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text("Upload your best images to attract businesses."),
//             const SizedBox(height: 16),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 10,
//                   crossAxisSpacing: 10,
//                   childAspectRatio:0.7,
//                 ),
//                 itemCount: selectedImages.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () => _pickImage(index, userId),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey, width: 2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: selectedImages[index] != null
//                           ? Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.file(
//                               selectedImages[index]!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               height: double.infinity,
//                             ),
//                           ),
//                           Positioned(
//                             top: 4,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   selectedImages[index] = null;
//                                 });
//                               },
//                               child: const CircleAvatar(
//                                 backgroundColor: Colors.black54,
//                                 child: Icon(Icons.close, color: Colors.white, size: 18),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                           : const Center(
//                         child: Icon(Icons.add, color: Colors.blue, size: 30),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to Upload Images Page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => mainHomePage()), // Use the correct class name
//                 );
//               }, // Save role on click
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 15),
//                 backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   "Next",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_app/components/MainHomePage.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickImage(int index, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImages[index] = File(pickedFile.path);
      });

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
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      print('Starting image upload...');
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('posts/$userId/$fileName');
      await storageRef.putFile(image);

      print('Image uploaded to storage.');
      final imageUrl = await storageRef.getDownloadURL();
      print('Download URL retrieved: $imageUrl');

      // Create post metadata
      final postData = {
        'imageUrl': imageUrl,
        'description': description,
        'fileName': fileName,
        'uploadedAt': FieldValue.serverTimestamp(),
        'userId': userId,
        'likes': 0,
        'comments': [],
      };

      // Reference to user's feed collection
      final userFeedRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('feed')
          .doc(); // Auto-generate document ID

      // Add to user's feed collection
      await userFeedRef.set(postData);

      print('Details uploaded successfully to user feed.');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e, stackTrace) {
      print("Error uploading image: $e");
      print("Stack Trace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserState>(context).userId;

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
                  childAspectRatio: 0.7,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainHomePage()),
                );
              },
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