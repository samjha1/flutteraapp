import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SiteBookingPage extends StatefulWidget {
  @override
  _SiteBookingPageState createState() => _SiteBookingPageState();
}

class _SiteBookingPageState extends State<SiteBookingPage> {
  final Map<String, TextEditingController> controllers = {
    'developer': TextEditingController(),
    'dt': TextEditingController(),
    'fname': TextEditingController(),
    'mname': TextEditingController(),
    'lname': TextEditingController(),
    'ph': TextEditingController(),
    'mail': TextEditingController(),
    'dob': TextEditingController(),
    'occupation': TextEditingController(),
    'adhar': TextEditingController(),
    'nam': TextEditingController(),
    'relation': TextEditingController(),
    'raddress': TextEditingController(),
    'paddress': TextEditingController(),
    'executive_name': TextEditingController(),
    'manager_name': TextEditingController(),
    'tel_name': TextEditingController(),
    'p_mode': TextEditingController(),
    'remark': TextEditingController(),
    'layout': TextEditingController(),
    'nxt_dt': TextEditingController(),
    'p_name': TextEditingController(),
    'sqft': TextEditingController(),
    'rate': TextEditingController(),
    'book_amt': TextEditingController(),
    'tamount': TextEditingController(),
  };

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!_validateForm()) {
      _showSnackbar(context, 'Error', 'Please fill all fields');
      return;
    }

    try {
      final formData = controllers.map(
        (key, controller) =>
            MapEntry(key.toLowerCase(), controller.text.trim()),
      );

      final response = await http.post(
        Uri.parse('http://localhost/api/sp.php'), // Use correct backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['message'] != null) {
        _showSnackbar(context, 'Success', responseData['message']);
      } else {
        _showSnackbar(
            context, 'Error', responseData['error'] ?? 'Submission failed');
      }
    } catch (e) {
      _showSnackbar(context, 'Error', 'Network error: $e');
    }
  }

  bool _validateForm() {
    return controllers.values
        .every((controller) => controller.text.trim().isNotEmpty);
  }

  void _showSnackbar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      content: Text('$title: $message'),
      backgroundColor: title == 'Error' ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String _getLabelText(String fieldName) {
    switch (fieldName) {
      case 'developer':
        return 'Developer Name';
      case 'dt':
        return 'Date';
      case 'fname':
        return 'First Name';
      case 'mname':
        return 'Middle Name';
      case 'lname':
        return 'Last Name';
      case 'ph':
        return 'Phone';
      case 'mail':
        return 'Email';
      case 'dob':
        return 'Date of Birth';
      case 'occupation':
        return 'Occupation';
      case 'adhar':
        return 'Aadhar Number';
      case 'nam':
        return 'Name of Person';
      case 'relation':
        return 'Relation with Developer';
      case 'raddress':
        return 'Residential Address';
      case 'paddress':
        return 'Permanent Address';
      case 'executive_name':
        return 'Executive Name';
      case 'manager_name':
        return 'Manager Name';
      case 'tel_name':
        return 'Telephone Number';
      case 'p_mode':
        return 'Payment Mode';
      case 'remark':
        return 'Remarks';
      case 'layout':
        return 'Layout';
      case 'nxt_dt':
        return 'Next Date';
      case 'p_name':
        return 'Person Name';
      case 'sqft':
        return 'Area in Sqft';
      case 'rate':
        return 'Rate per Sqft';
      case 'book_amt':
        return 'Booking Amount';
      case 'tamount':
        return 'Total Amount';
      default:
        return fieldName; // Fallback if no label is found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF800000), // Blue app bar for consistency
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...controllers.entries
                .map((entry) => _buildTextField(entry.key, entry.value))
                .toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800], // Blue button
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the frontend label
          Text(
            _getLabelText(label), // Get the user-friendly label
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.blue[800], // Blue label
            ),
          ),
          SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[800]!),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
