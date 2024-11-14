import 'package:flutter/material.dart';
import 'customer_edit.dart'; // Import the EditCustomerPage file

class CustomerDetailPage extends StatelessWidget {
  final Map<String, dynamic> customer;

  const CustomerDetailPage({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('${customer['first_name']}\'s Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailBox('First Name', customer['first_name']),
            _buildDetailBox('Middle Name', customer['middle_name']),
            _buildDetailBox('Last Name', customer['last_name']),
            _buildDetailBox('Phone No', customer['phone_no']),
            _buildDetailBox('Email', customer['mail_id']),
            _buildDetailBox('DOB', customer['DOB']),
            SizedBox(height: 20),
            _buildDetailBox('Occupation', customer['occupation']),
            _buildDetailBox('Nominee', customer['nominee']),
            _buildDetailBox('Relationship', customer['relationship']),
            SizedBox(height: 20),
            _buildDetailBox('Present Address', customer['present_address']),
            _buildDetailBox('Permanent Address', customer['permanent_address']),
            _buildDetailBox('Aadhar No', customer['aadhar_no']),
            _buildDetailBox('Apartment Type', customer['apartment_type']),
            SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.blueAccent, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$label: ${value ?? 'N/A'}',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditCustomerPage(customer: customer),
              ),
            );
          },
          icon: Icon(Icons.edit),
          label: Text('Edit'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
