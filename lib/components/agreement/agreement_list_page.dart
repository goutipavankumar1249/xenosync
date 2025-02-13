import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'agreement_detail_page.dart';
import 'agreement_service.dart';

class AgreementListPage extends StatelessWidget {
  final String currentUserId;
  final AgreementService _agreementService = AgreementService();

  AgreementListPage({required this.currentUserId});

  Widget buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey[400]!, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_agreements.png', // Make sure to add this image
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            "No Agreements Yet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF081B48),
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your agreements will appear here",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Shot OK",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _agreementService.fetchUserAgreements(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildShimmerEffect();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return buildEmptyState();
          }

          final agreements = snapshot.data!;

          return ListView.builder(
            itemCount: agreements.length,
            itemBuilder: (context, index) {
              var agreement = agreements[index];
              String agreementId = agreement.id;
              String user1Id = agreement['user1'];
              String user2Id = agreement['user2'];
              String status = agreement['status'];

              bool isCreator = currentUserId == user1Id;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F7FB),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Color(0xFF081B48), width: 2),
                  ),
                  child: ListTile(
                    title: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUserId == user1Id ? user2Id : user1Id)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 16,
                              width: 150,
                              color: Colors.white,
                            ),
                          );
                        }
                        final userName = userSnapshot.data!['username'];
                        return Text(
                          "Agreement with $userName",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        );
                      },
                    ),
                    subtitle: Text(
                      "Status: $status",
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: Color(0xFF081B48)),
                    onTap: () {
                      if (isCreator) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                "Agreement Status",
                                style: TextStyle(
                                  color: Color(0xFF081B48),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                "Status: $status",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Color(0xFF081B48),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
