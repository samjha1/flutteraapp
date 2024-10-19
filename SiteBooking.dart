import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SiteBookingPage extends StatefulWidget {
  const SiteBookingPage({super.key});

  @override
  SiteBookingPageState createState() => SiteBookingPageState();
}

class SiteBookingPageState extends State<SiteBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _applicationIdController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String applicationId = _applicationIdController.text;
      String fullName = _fullNameController.text;
      String relation = _relationController.text;
      String dob = _dobController.text;
      String occupation = _occupationController.text;

      Map<String, String> data = {
        'application_id': applicationId,
        'full_name': fullName,
        'relation': relation,
        'dob': dob,
        'occupation': occupation,
      };

      var response = await http.post(
        Uri.parse('http://localhost/api/site_booking.php'),
        body: data,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully: ${response.body}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form: ${response.statusCode} - ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // Dark background
      appBar: AppBar(
        title: const Text('Application Form'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Allow scrolling in case of keyboard
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fill in the details below:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(_applicationIdController, 'Application ID'),
                const SizedBox(height: 20),
                _buildTextField(_fullNameController, 'Full Name'),
                const SizedBox(height: 20),
                _buildTextField(_relationController, 'Relation'),
                const SizedBox(height: 20),
                _buildTextField(_dobController, 'Date of Birth (YYYY-MM-DD)'),
                const SizedBox(height: 20),
                _buildTextField(_occupationController, 'Occupation'),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text( // Single child in the ElevatedButton
                      'Submit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
