import 'package:flutter/material.dart';
import 'agreement_service.dart';

class SendAgreementPage extends StatefulWidget {
  final String currentUserId;
  final String receiverId;

  SendAgreementPage({required this.currentUserId, required this.receiverId});

  @override
  _SendAgreementPageState createState() => _SendAgreementPageState();
}

class _SendAgreementPageState extends State<SendAgreementPage> {
  final TextEditingController _agreementController = TextEditingController();
  final AgreementService _agreementService = AgreementService();

  void _sendAgreement() async {
    if (_agreementController.text.isEmpty) return;

    await _agreementService.sendAgreementRequest(
        widget.currentUserId, widget.receiverId, _agreementController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Agreement request sent!')),
    );

    Navigator.pop(context); // Go back after sending
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Agreement')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _agreementController,
              decoration: InputDecoration(
                hintText: "Enter agreement details...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendAgreement,
              child: Text('Send Agreement'),
            ),
          ],
        ),
      ),
    );
  }
}
