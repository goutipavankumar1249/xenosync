import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'agreement_detail_page.dart';
import 'agreement_service.dart';

class AgreementListPage extends StatelessWidget {
  final String currentUserId;
  final AgreementService _agreementService = AgreementService();

  AgreementListPage({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agreements",style: TextStyle(color: Colors.blueAccent),)),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _agreementService.fetchUserAgreements(currentUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final agreements = snapshot.data!;
          print('inside the list page $agreements');
          if (agreements.isEmpty) {
            return Center(child: Text("No agreements found."));
          }

          return ListView.builder(
            itemCount: agreements.length,
            itemBuilder: (context, index) {
              var agreement = agreements[index];
              String agreementId = agreement.id;
              String user1Id = agreement['user1'];
              String user2Id = agreement['user2'];
              String status = agreement['status'];

              bool isCreator = currentUserId == user1Id; // Check if current user is the creator

              return ListTile(

                title: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(currentUserId == user1Id ? user2Id : user1Id).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading...");
                    }
                    final userName = snapshot.data!['username']; // Assuming 'name' field exists
                    return Text("Agreement with $userName");
                  },
                ),

                subtitle: Text("Status: $status"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (isCreator) {
                    // User14 (creator) should only see the status, no accept/reject buttons
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Agreement Status"),
                          content: Text("Status: $status"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // User16 (receiver) can open the details page to accept/reject
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgreementDetailPage(
                          agreementDetails: agreement['agreementDetails'],
                          agreementId: agreementId,
                          status: status,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
