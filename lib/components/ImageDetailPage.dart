import 'dart:io';
import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final File imageFile;
  final String userId;
  final Function(String description) onSave;

  const ImageDetailPage({
    required this.imageFile,
    required this.userId,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final descriptionController = TextEditingController();

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
              "Image Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height:10),
            const Text("Upload your best images to attract businesses."),
            const SizedBox(height:20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Enter Caption",style:TextStyle(fontSize: 20,fontWeight : FontWeight.normal),),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter caption for your image",
                contentPadding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0), // Increase padding

              ),
            ),
            const SizedBox(height:200),
            // ElevatedButton(
            //   onPressed: () {
            //     onSave(descriptionController.text);
            //     Navigator.pop(context);
            //   },
            //   child: const Text("Upload Image"),
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 50),
            //   ),
            // ),

            ElevatedButton(
              onPressed: () {
                onSave(descriptionController.text);
                Navigator.pop(context);
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
                  "upload image",
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
