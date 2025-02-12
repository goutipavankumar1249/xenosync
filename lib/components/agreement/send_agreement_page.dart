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
    if (_agreementController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter agreement details.')),
      );
      return;
    }

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
      appBar: AppBar(
        title: Text(
          'Send Agreement',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agreement Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '''E-AGREEMENT

                    This Agreement, made on [Date], is between [Client Name] (“Client”) and [Service Provider Name] (“Service Provider”).
          
                      The Service Provider will deliver:
                    •	[e.g., 5 high-quality photos for a fashion shoot]
                    •	[e.g., 1 promotional video]
                    by [Completion Date].
          
                    Payment Terms:
                    Total: [Amount]
                    •	[X%] upon signing
                    •	[X%] upon completion
          
                      Dispute Resolution:
                      Any disputes will be resolved via [mediation/arbitration] in [jurisdiction].
          
                    By signing, both parties agree to the terms and confirm this Agreement is legally binding..''',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _agreementController,
                  decoration: InputDecoration(
                    hintText: "Type your agreement details here...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  maxLines: 5,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Container(
                  width: 160, // Adjusted width for better fit
                  height: 40, // Adjusted height for better fit
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF004DAB), Color(0xFF09163D)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40F4FAFF),
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: _sendAgreement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Send Agreement",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14, // Adjusted font size for better fit
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}