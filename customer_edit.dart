import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditCustomerPage extends StatefulWidget {
  final Map<String, dynamic> customer;

  const EditCustomerPage({Key? key, required this.customer}) : super(key: key);

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneNoController;
  late TextEditingController emailController;
  late TextEditingController DOBController;
  late TextEditingController OccupationController;
  late TextEditingController NomineeController;
  late TextEditingController RelationshipController;
  late TextEditingController PresentAddressController;
  late TextEditingController PermanentAddressController;
  late TextEditingController AadharNoController;
  late TextEditingController ApartmentTypeController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.customer['first_name']);
    middleNameController = TextEditingController(text: widget.customer['middle_name']);
    lastNameController = TextEditingController(text: widget.customer['last_name']);
    phoneNoController = TextEditingController(text: widget.customer['phone_no']);
    emailController = TextEditingController(text: widget.customer['mail_id']);
    DOBController = TextEditingController(text: widget.customer['DOB']);
    OccupationController = TextEditingController(text: widget.customer['occupation']);
    NomineeController = TextEditingController(text: widget.customer['nominee']);
    RelationshipController = TextEditingController(text: widget.customer['relationship']);
    PresentAddressController = TextEditingController(text: widget.customer['present_address']);
    PermanentAddressController = TextEditingController(text: widget.customer['permanent_address']);
    AadharNoController = TextEditingController(text: widget.customer['aadhar_no']);
    ApartmentTypeController = TextEditingController(text: widget.customer['apartment_type']);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    phoneNoController.dispose();
    emailController.dispose();
    DOBController.dispose();
    OccupationController.dispose();
    NomineeController.dispose();
    RelationshipController.dispose();
    PresentAddressController.dispose();
    PermanentAddressController.dispose();
    AadharNoController.dispose();
    ApartmentTypeController.dispose();
    super.dispose();
  }

  Future<void> _updateCustomer() async {
    final response = await http.post(
      Uri.parse('http://localhost/api/update_customer.php'),
      body: {
        'id': widget.customer['id'].toString(),
        'first_name': firstNameController.text,
        'middle_name': middleNameController.text,
        'last_name': lastNameController.text,
        'phone_no': phoneNoController.text,
        'mail_id': emailController.text,
        'DOB': DOBController.text,
        'occupation': OccupationController.text,
        'nominee': NomineeController.text,
        'relationship': RelationshipController.text,
        'present_address': PresentAddressController.text,
        'permanent_address': PermanentAddressController.text,
        'aadhar_no': AadharNoController.text,
        'apartment_type': ApartmentTypeController.text,
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Customer updated successfully'),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update customer'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Server error: ${response.statusCode}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('First Name', firstNameController),
            _buildTextField('Middle Name', middleNameController),
            _buildTextField('Last Name', lastNameController),
            _buildTextField('Phone No', phoneNoController),
            _buildTextField('Email', emailController),
            _buildTextField('DOB', DOBController),
            _buildTextField('Occupation', OccupationController),
            _buildTextField('Nominee', NomineeController),
            _buildTextField('Relationship', RelationshipController),
            _buildTextField('Present Address', PresentAddressController),
            _buildTextField('Permanent Address', PermanentAddressController),
            _buildTextField('Aadhar No', AadharNoController),
            _buildTextField('Apartment Type', ApartmentTypeController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCustomer,
              child: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
