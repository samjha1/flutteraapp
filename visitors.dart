import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  // Controllers for form fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _visitingForController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _appointment = 'YES'; // Default dropdown value
  bool _isLoading = false; // Loading state

  // Function to submit form data to the backend
  Future<void> _submitForm() async {
    const String apiUrl = "http://localhost/api/visitors.php"; // Replace with your API URL

    // Validate fields
    if (_fullNameController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _companyController.text.isEmpty ||
        _visitingForController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'full_name': _fullNameController.text,
          'mobile_no': _mobileController.text,
          'location': _locationController.text,
          'appointment': _appointment,
          'email': _emailController.text,
          'company': _companyController.text,
          'visiting_for': _visitingForController.text,
          'message': _messageController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully')),
        );

        // Clear fields after successful submission
        _fullNameController.clear();
        _mobileController.clear();
        _locationController.clear();
        _emailController.clear();
        _companyController.clear();
        _visitingForController.clear();
        _messageController.clear();
        setState(() {
          _appointment = 'YES';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit the form')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visitors Form',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF800000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '* All fields are mandatory',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(height: 20),
              buildInputField(
                label: 'Full Name',
                controller: _fullNameController,
                hintText: 'Enter your full name',
              ),
              buildInputField(
                label: 'Mobile No',
                controller: _mobileController,
                hintText: 'Enter your mobile number',
                keyboardType: TextInputType.phone,
              ),
              buildInputField(
                label: 'Location',
                controller: _locationController,
                hintText: 'Enter your location',
              ),
              buildDropdownField(
                label: 'Do you have an Appointment?',
                value: _appointment,
                options: ['YES', 'NO'],
                onChanged: (value) {
                  setState(() {
                    _appointment = value!;
                  });
                },
              ),
              buildInputField(
                label: 'Email ID',
                controller: _emailController,
                hintText: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
              ),
              buildInputField(
                label: 'Company/Dept',
                controller: _companyController,
                hintText: 'Enter your company/department',
              ),
              buildInputField(
                label: 'Visiting For',
                controller: _visitingForController,
                hintText: 'Reason for your visit',
              ),
              buildInputField(
                label: 'Message/Comment',
                controller: _messageController,
                hintText: 'Write your message',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
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

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: options
              .map((option) =>
              DropdownMenuItem<String>(value: option, child: Text(option)))
              .toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
