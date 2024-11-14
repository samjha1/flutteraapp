import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard_page.dart'; // Assuming this is your dashboard page
import 'profile.dart'; // Assuming this is your profile page

void main() {
  runApp(const CustomersScreen());
}

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Customer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController first_nameController = TextEditingController();
  final TextEditingController middle_nameController = TextEditingController();
  final TextEditingController last_nameController = TextEditingController();
  final TextEditingController phone_noController = TextEditingController();
  final TextEditingController mail_idController = TextEditingController();
  final TextEditingController DOBController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController nomineeController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController present_addressController = TextEditingController();
  final TextEditingController permanent_addressController = TextEditingController();
  final TextEditingController aadhar_noController = TextEditingController();

  String? apartmentType;
  List<String> apartmentTypes = ['apartment', 'flat'];

  Future<void> submitForm() async {
    final response = await http.post(
      Uri.parse('http://localhost/api/customers.php'), // Backend URL
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'first_name': first_nameController.text.trim(),
        'middle_name': middle_nameController.text.trim(),
        'last_name': last_nameController.text.trim(),
        'phone_no': phone_noController.text.trim(),
        'mail_id': mail_idController.text.trim(),
        'DOB': DOBController.text.trim(),
        'occupation': occupationController.text.trim(),
        'nominee': nomineeController.text.trim(),
        'relationship': relationshipController.text.trim(),
        'present_address': present_addressController.text.trim(),
        'permanent_address': permanent_addressController.text.trim(),
        'aadhar_no': aadhar_noController.text.trim(),
        'apartment_type': apartmentType ?? '', // Send apartment_type to backend
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['message'] != null) {
        _showSnackbar(context, 'Success', responseData['message']);
      } else {
        _showSnackbar(context, 'Error', responseData['error'] ?? 'Something went wrong!');
      }
    } else {
      _showSnackbar(context, 'Error', 'Failed to submit form. Please try again.');
    }
  }

  void _showSnackbar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            title == 'Success' ? Icons.check_circle : Icons.error,
            color: title == 'Success' ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: title == 'Success' ? Colors.green : Colors.red,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Customer Form', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            _buildTextField('First Name', first_nameController, Icons.person),
            _buildTextField('Middle Name', middle_nameController, Icons.person),
            _buildTextField('Last Name', last_nameController, Icons.person),
            _buildTextField('Phone No', phone_noController, Icons.phone),
            _buildTextField('Email', mail_idController, Icons.email),
            _buildTextField('DOB', DOBController, Icons.calendar_today),
            _buildTextField('Occupation', occupationController, Icons.work),
            _buildTextField('Nominee', nomineeController, Icons.person_add),
            _buildTextField('Relationship', relationshipController, Icons.family_restroom),
            _buildTextField('Present Address', present_addressController, Icons.home),
            _buildTextField('Permanent Address', permanent_addressController, Icons.home),
            _buildTextField('Aadhar No', aadhar_noController, Icons.credit_card),

            const SizedBox(height: 16),
            _buildDropdown('Apartment Type', apartmentTypes, (String? newValue) {
              setState(() {
                apartmentType = newValue;
              });
            }, apartmentType),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_validateForm()) {
                    submitForm();
                  } else {
                    _showSnackbar(context, 'Error', 'Please fill in all fields.');
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70.0,
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueAccent),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.blueAccent),
              filled: true,
              fillColor: Colors.blue[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, ValueChanged<String?> onChanged, String? selectedValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueAccent),
          ),
          const SizedBox(height: 8),
          InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blue[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: onChanged,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    return first_nameController.text.isNotEmpty &&
        middle_nameController.text.isNotEmpty &&
        last_nameController.text.isNotEmpty &&
        phone_noController.text.isNotEmpty &&
        mail_idController.text.isNotEmpty &&
        DOBController.text.isNotEmpty &&
        occupationController.text.isNotEmpty &&
        nomineeController.text.isNotEmpty &&
        relationshipController.text.isNotEmpty &&
        present_addressController.text.isNotEmpty &&
        permanent_addressController.text.isNotEmpty &&
        aadhar_noController.text.isNotEmpty &&
        apartmentType != null;
  }
}