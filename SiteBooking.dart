import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SiteBookingPage extends StatefulWidget {
  const SiteBookingPage({super.key});

  @override
  SiteBookingPagestate createState() => SiteBookingPagestate();
}

class SiteBookingPagestate extends State<SiteBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _applicationIdController =
      TextEditingController();
  final TextEditingController _full_nameController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String applicationId = _applicationIdController.text;
      String fullName = _full_nameController.text;
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

      // Ensure you modify the URL as per the device being used
      var response = await http.post(
        Uri.parse(
            'http://localhost/api/site_booking.php'), // For Android emulator
        // Uri.parse('http://127.0.0.1/api/site_booking.php'), // For iOS simulator
        // Uri.parse('http://<YOUR_MACHINE_IP_ADDRESS>/api/site_booking.php'), // For physical device
        body: data,
      );

      // Print the response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle response
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Form submitted successfully: ${response.body}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to submit form: ${response.statusCode} - ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _applicationIdController,
                decoration: const InputDecoration(labelText: 'Application ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Application ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _full_nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Full Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _relationController,
                decoration: const InputDecoration(labelText: 'Relation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Relation';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(
                    labelText: 'Date of Birth (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Date of Birth';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _occupationController,
                decoration: const InputDecoration(labelText: 'Occupation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Occupation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
