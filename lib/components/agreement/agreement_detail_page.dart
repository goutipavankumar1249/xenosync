//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AgreementDetailPage extends StatefulWidget {
//   final String user1Id;
//   final String user2Id;
//   final String currentUserId;
//   final String agreementId;
//   final String status; // "pending", "accepted", "rejected"
//
//   const AgreementDetailPage({
//     Key? key,
//     required this.currentUserId,
//     required this.user1Id,
//     required this.user2Id,
//     required this.agreementId,
//     required this.status,
//   }) : super(key: key);
//
//   @override
//   _AgreementDetailPageState createState() => _AgreementDetailPageState();
// }
//
// class _AgreementDetailPageState extends State<AgreementDetailPage> {
//   String? user1Name;
//   String? user2Name;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserNames();
//   }
//
//   Future<void> fetchUserNames() async {
//     try {
//       // Fetch user1 and user2 details from Firestore
//       final user1Doc = await FirebaseFirestore.instance.collection('users').doc(widget.user1Id).get();
//       final user2Doc = await FirebaseFirestore.instance.collection('users').doc(widget.user2Id).get();
//
//       setState(() {
//         user1Name = user1Doc.exists ? user1Doc['username'] : "Unknown User";
//         user2Name = user2Doc.exists ? user2Doc['username'] : "Unknown User";
//       });
//     } catch (e) {
//       print("Error fetching user names: $e");
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     bool isReceiver = widget.currentUserId == widget.user2Id; // Only receiver can accept/reject
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Agreement Details")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Agreement between ${user1Name ?? 'Loading...'} and ${user2Name ?? 'Loading...'}",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Text()
//             Text(
//               "Status: ${widget.status}",
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 24),
//
//             // Only show Accept/Reject buttons for the receiver (user2) when the status is "pending"
//             if (isReceiver && widget.status == "pending") ...[
//               ElevatedButton(
//                 onPressed: () => updateAgreementStatus("accepted"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                 ),
//                 child: const Text("Accept Agreement"),
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton(
//                 onPressed: () => updateAgreementStatus("rejected"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                 ),
//                 child: const Text("Reject Agreement"),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   void updateAgreementStatus(String newStatus) {
//     FirebaseFirestore.instance
//         .collection('agreements')
//         .doc(widget.agreementId)
//         .update({'status': newStatus}).then((_) {
//       setState(() {
//         // Update local status for immediate UI change
//         widget.status == newStatus;
//       });
//     }).catchError((error) {
//       print("Error updating agreement status: $error");
//     });
//   }
// }
//
//
//

import 'package:flutter/material.dart';
import 'agreement_service.dart';

class AgreementDetailPage extends StatelessWidget {
  final String agreementId;
  final String agreementDetails;
  final String status;
  final AgreementService _agreementService = AgreementService();

  AgreementDetailPage({required this.agreementId, required this.agreementDetails, required this.status});

  void _acceptAgreement(BuildContext context) async {
    await _agreementService.updateAgreementStatus(agreementId, "accepted");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agreement Accepted!')));
    Navigator.pop(context);
  }

  void _rejectAgreement(BuildContext context) async {
    await _agreementService.updateAgreementStatus(agreementId, "rejected");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agreement Rejected!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agreement Details')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(agreementDetails, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            if (status == "pending") ...[
              ElevatedButton(
                onPressed: () => _acceptAgreement(context),
                child: Text('Accept Agreement'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _rejectAgreement(context),
                child: Text('Reject Agreement'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ] else
              Text("Status: $status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
