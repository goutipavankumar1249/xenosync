import 'package:cloud_firestore/cloud_firestore.dart';

class AgreementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send an agreement request
  Future<void> sendAgreementRequest(
      String user1, String user2, String details) async {
    final agreementRef = _firestore.collection('agreements').doc();

    await agreementRef.set({
      "user1": user1,
      "user2": user2,
      "status": "pending",
      "agreementDetails": details,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp()
    });
  }

  /// Accept or reject an agreement
  Future<void> updateAgreementStatus(String agreementId, String newStatus) async {
    await _firestore.collection('agreements').doc(agreementId).update({
      "status": newStatus,
      "updatedAt": FieldValue.serverTimestamp()
    });
  }

  /// Fetch agreements for a user
  Stream<List<QueryDocumentSnapshot>> fetchUserAgreements(String userId) {
    return _firestore
        .collection('agreements')
        .where(
           Filter.or(
             Filter("user1", isEqualTo: userId), // Fetch if user is creator
             Filter("user2", isEqualTo: userId), // Fetch if user is receiver
           ),
        )
        .where("status", isNotEqualTo: "rejected")
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }



}
