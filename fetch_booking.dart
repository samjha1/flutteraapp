import 'dart:convert';
import 'package:durga/SiteBooking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'customer_edit.dart';

class FetchedDataScreen extends StatefulWidget {
  const FetchedDataScreen({super.key});

  @override
  _bookingListScreenState createState() => _bookingListScreenState();
}

class _bookingListScreenState extends State<FetchedDataScreen> {
  late Future<List<dynamic>> bookingData;

  @override
  void initState() {
    super.initState();
    bookingData = fetchData();
  }

  // Function to fetch data from the backend
  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.indataai.in/durga/fatch_booking.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // Function to delete a customer
  Future<void> deleteCustomer(int customerId) async {
    final response = await http.post(
      Uri.parse('https://api.indataai.in/durga/deletecustomer.php'),
      body: {'id': customerId.toString()},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(
          responseData); // Debug: Print response to check for success or error

      if (responseData['success'] == true) {
        setState(() {
          bookingData = fetchData(); // Reload data after deletion
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Customer deleted successfully'),
        ));
      } else {
        print("Error deleting customer: ${responseData['error']}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error deleting customer: ${responseData['error']}'),
        ));
      }
    } else {
      throw Exception('Failed to delete customer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back button to white
        ),
        title: const Text(
          'BOOKING LIST',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: bookingData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No records found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                final customerRecords = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: customerRecords.length,
                  itemBuilder: (context, index) {
                    final record = customerRecords[index];
                    print(record['id']
                        .runtimeType); // Debug: Check the type of 'id'

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                bookingDetailPage(customer: record),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.person,
                                  color: Color(0xFF800000), size: 30),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'First Name: ${record['fname']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Phone No: ${record['ph']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'developer: ${record['developer']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Edit and Delete buttons
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_red_eye,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditCustomerPage(
                                                  customer: record),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditCustomerPage(
                                                  customer: record),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Delete Customer'),
                                            content: const Text(
                                                'Are you sure you want to delete this customer?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Convert 'id' to int and pass it to the delete function
                                                  int customerId = int.parse(
                                                      record['id'].toString());
                                                  deleteCustomer(
                                                      customerId); // Delete the customer
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SiteBookingPage()),
                );
              },
              backgroundColor: const Color(0xFF800000),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class bookingDetailPage extends StatelessWidget {
  final Map<String, dynamic> customer;

  const bookingDetailPage({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back button to white
        ),
        title: const Text(
          'Customers List',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailBox('First Name', customer['fname']),
            _buildDetailBox('Middle Name', customer['mname']),
            _buildDetailBox('Last Name', customer['lname']),
            _buildDetailBox('Phone No', customer['ph']),
            _buildDetailBox('developer', customer['developer']),
            _buildDetailBox('DOB', customer['tel_name']),
            const SizedBox(height: 20),
            _buildDetailBox('Occupation', customer['p_name']),
            _buildDetailBox('Nominee', customer['executive_name']),
            _buildDetailBox('Relationship', customer['lname']),
            const SizedBox(height: 20),
            _buildDetailBox('Present Address', customer['manager_name']),
            _buildDetailBox('Permanent Address', customer['book_amt']),
            _buildDetailBox('Aadhar No', customer['rate']),
            _buildDetailBox('Apartment Type', customer['sqft']),
            const SizedBox(height: 20),
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
            const Icon(Icons.info_outline, color: Colors.blueAccent),
            Expanded(
              child: Text(
                '$label: ${value ?? 'N/A'}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
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
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
