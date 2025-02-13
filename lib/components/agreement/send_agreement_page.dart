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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      appBar: AppBar(
        title: Text(
          'Send Agreement',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Changed title text color to black
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
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
                  color: Color(0xFF081B48), // Changed text color
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF081B48), width: 1.5),
                ),
                child: Text(
                  '''E-AGREEMENT

This Agreement, made on [Date], is between [Client Name] (“Client”) and [Service Provider Name] (“Service Provider”).

The Service Provider will deliver:
•  [e.g., 5 high-quality photos for a fashion shoot]
•  [e.g., 1 promotional video]
by [Completion Date].

Payment Terms:
Total: [Amount]
•  [X%] upon signing
•  [X%] upon completion

Dispute Resolution:
Any disputes will be resolved via [mediation/arbitration] in [jurisdiction].

By signing, both parties agree to the terms and confirm this Agreement is legally binding.''',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                    height: 1.5, // Improved readability
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Customize Your Agreement:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF081B48),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color white
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF081B48), width: 1.5), // Border
                ),
                child: TextField(
                  controller: _agreementController,
                  decoration: InputDecoration(
                    hintText: "Type your agreement details here...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
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
                  width: MediaQuery.of(context).size.width * 0.9, // Button width as device width
                  height: 50, // Adjusted button height
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF004DAB), Color(0xFF09163D)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40F4FAFF), // Box-shadow
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30), // Rounded button
                  ),
                  child: ElevatedButton(
                    onPressed: _sendAgreement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Send Agreement",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16, // Slightly larger text
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
