import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:login_app/components/MainHomePage.dart';
import 'package:provider/provider.dart';
import 'ImageDetailPage.dart';
import 'UserState.dart';
import 'package:video_player/video_player.dart'; // For video duration validation

class UploadImagesPage extends StatefulWidget {
  const UploadImagesPage({Key? key}) : super(key: key);

  @override
  State<UploadImagesPage> createState() => _UploadImagesPageState();
}

class _UploadImagesPageState extends State<UploadImagesPage> {
  List<File?> selectedMedia = [null, null, null, null, null, null];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia(int index, String userId) async {
    bool isVideo = (selectedMedia.where((media) => media != null && _isVideo(media)).length == 0);

    if (isVideo && index == 5) {
      final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        Duration? videoDuration = await _getVideoDuration(File(pickedVideo.path));
        if (videoDuration != null && videoDuration.inSeconds <= 30) {
          setState(() {
            selectedMedia[index] = File(pickedVideo.path);
          });
          _navigateToDetailPage(selectedMedia[index]!, userId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Video must be 30 seconds or less.")),
          );
        }
      }
    } else {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedMedia[index] = File(pickedImage.path);
        });
        _navigateToDetailPage(selectedMedia[index]!, userId);
      }
    }
  }

  Future<void> _navigateToDetailPage(File mediaFile, String userId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetailPage(
          imageFile: mediaFile,
          userId: userId,
          onSave: (description) {
            _uploadMedia(mediaFile, description, userId);
          },
        ),
      ),
    );
  }

  Future<void> _uploadMedia(File mediaFile, String description, String userId) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.${_isVideo(mediaFile) ? 'mp4' : 'jpg'}';

      final storageRef = FirebaseStorage.instance.ref().child('posts/$userId/$fileName');
      await storageRef.putFile(mediaFile);

      final mediaUrl = await storageRef.getDownloadURL();

      final postData = {
        'imageUrl': mediaUrl,
        'description': description,
        'fileName': fileName,
        'uploadedAt': FieldValue.serverTimestamp(),
        'userId': userId,
        'likes': 0,
        'comments': [],
        'type': _isVideo(mediaFile) ? 'video' : 'image',
      };

      final userFeedRef = _firestore.collection('users').doc(userId).collection('feed').doc();
      await userFeedRef.set(postData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Media uploaded successfully!")),
      );
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload media: $e")),
      );
    }
  }

  bool _isVideo(File mediaFile) {
    return mediaFile.path.endsWith('.mp4') || mediaFile.path.endsWith('.mov');
  }

  Future<Duration?> _getVideoDuration(File videoFile) async {
    final VideoPlayerController controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    return controller.value.duration;
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
              "Upload Media",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Upload up to 5 images + 1 video (30 seconds) or 6 images."),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: selectedMedia.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _pickMedia(index, userId),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: selectedMedia[index] != null
                          ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _isVideo(selectedMedia[index]!)
                                ? Center(
                              child: Icon(Icons.videocam, size: 50, color: Colors.white),
                            )
                                : Image.file(
                              selectedMedia[index]!,
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
                                  selectedMedia[index] = null;
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
                        child: Icon(Icons.add, color: Color(0xFF081B48), size: 30), // Changed icon color
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.transparent, // Transparent to apply gradient
                shadowColor: const Color(0xF4FAFF40), // Shadow color
                elevation: 5,
              ).copyWith(
                backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => null, // Ensures no solid background overrides gradient
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF004DAB), Color(0xFF09163D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xF4FEFFE2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
