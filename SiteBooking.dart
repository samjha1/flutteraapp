import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SiteBookingPage extends StatefulWidget {
  const SiteBookingPage({super.key});

  @override
  SiteBookingPageState createState() => SiteBookingPageState();
}

class SiteBookingPageState extends State<SiteBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'application_id': TextEditingController(),
    'booking_firm': TextEditingController(),
    'first_name': TextEditingController(),
    'middle_name': TextEditingController(),
    'last_name': TextEditingController(),
    'phone': TextEditingController(),
    'email': TextEditingController(),
    'dob': TextEditingController(),
    'occupation': TextEditingController(),
    'aadhar_no': TextEditingController(),
    'nominee': TextEditingController(),
    'relation': TextEditingController(),
    'present_address': TextEditingController(),
    'permanent_address': TextEditingController(),
    'executive_name': TextEditingController(),
    'manager_name': TextEditingController(),
    'telecaller': TextEditingController(),
    'payment_method': TextEditingController(),
    'payment_details': TextEditingController(),
    'apartment': TextEditingController(),
    'next_payment_date': TextEditingController(),
    // Added property details
    'project': TextEditingController(),
    'flat_plot_no': TextEditingController(),
    'plot_size': TextEditingController(),
    'rate': TextEditingController(),
    'total_amount': TextEditingController(),
    'booking_amount': TextEditingController(),
  };

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> data = {
        for (var entry in _controllers.entries) entry.key: entry.value.text,
      };

      try {
        final response = await http.post(
          Uri.parse('https://api.indataai.in/durga/site_booking.php'),
          body: data,
        );

        if (response.statusCode == 200) {
          _showSnackBar('Form submitted successfully: ${response.body}');
        } else {
          _showSnackBar('Failed to submit form: ${response.statusCode}');
        }
      } catch (e) {
        _showSnackBar('Error submitting form: $e');
      }
    }
  }

  Widget _buildTextField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _controllers[key],
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.blueGrey[50],
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Site Booking'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Fill in the details below:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Existing form fields (user details)
                for (var entry in _controllers.entries.take(20))
                  _buildTextField(entry.key, entry.key.replaceAll('_', ' ').capitalize()),
                const SizedBox(height: 20),
                // Property details heading
                const Text(
                  'Add property details:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Property details fields
                _buildTextField('project', 'Project'),
                _buildTextField('flat_plot_no', 'Flat/Plot No'),
                _buildTextField('plot_size', 'Plot Size (sq. ft.)'),
                _buildTextField('rate', 'Rate'),
                _buildTextField('total_amount', 'Total Amount'),
                _buildTextField('booking_amount', 'Booking Amount'),
                const SizedBox(height: 30),
                // Submit button with custom styling
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
