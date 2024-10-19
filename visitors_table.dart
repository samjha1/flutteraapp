import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard_page.dart';

void main() {
  runApp(const VisitorsScreen());
}

class VisitorsScreen extends StatelessWidget {
  const VisitorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Form Submission App',
      home: FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController meetingPersonController = TextEditingController();

  Future<void> submitForm(String fullName, String number, String purpose,
      String meetingPerson) async {
    final response = await http.post(
      Uri.parse('http://localhost/api/visitors.php'), // Update this URL
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'full_name': fullName,
        'number': number,
        'purpose': purpose,
        'meeting_person': meetingPerson,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['message'] != null) {
        // Show the popup dialog on successful insertion
        _showPopupDialog(context, 'Success', responseData['message']);
      } else {
        // Handle error case
        _showPopupDialog(
            context, 'Error', responseData['error'] ?? 'Something went wrong!');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      _showPopupDialog(
          context, 'Error', 'Failed to submit form. Please try again.');
    }
  }

  // Function to show the popup dialog
  void _showPopupDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Submission'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the dashboard page and remove the current page from the stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
              (Route<dynamic> route) =>
                  false, // Remove all routes until reaching the dashboard
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border:
                    OutlineInputBorder(), // Adds a box around the text field
              ),
            ),
            const SizedBox(height: 16), // Adds space between text fields
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Number',
                border:
                    OutlineInputBorder(), // Adds a box around the text field
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose',
                border:
                    OutlineInputBorder(), // Adds a box around the text field
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: meetingPersonController,
              decoration: const InputDecoration(
                labelText: 'Meeting Person',
                border:
                    OutlineInputBorder(), // Adds a box around the text field
              ),
            ),
            const SizedBox(height: 24), // Space before submit button
            ElevatedButton(
              onPressed: () {
                String fullName = fullNameController.text.trim();
                String number = numberController.text.trim();
                String purpose = purposeController.text.trim();
                String meetingPerson = meetingPersonController.text.trim();

                if (fullName.isNotEmpty &&
                    number.isNotEmpty &&
                    purpose.isNotEmpty &&
                    meetingPerson.isNotEmpty) {
                  submitForm(fullName, number, purpose, meetingPerson);
                } else {
                  print('Please fill in all fields.');
                  _showPopupDialog(
                      context, 'Error', 'Please fill in all fields.');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
