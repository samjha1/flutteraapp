import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'customer_edit.dart';
import 'profile.dart';
import 'dashboard_page.dart';
import 'customerdetailpage.dart';
import 'customers.dart'; // Import the CustomerDetailPage

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late Future<List<dynamic>> customerData;

  @override
  void initState() {
    super.initState();
    customerData = fetchData();
  }

  // Function to fetch data from the backend
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/api/fetch_customers.php'));

    if (response.statusCode == 200) {
      // Parse the JSON data
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Function to delete a customer
  Future<void> deleteCustomer(int customerId) async {
    final response = await http.post(
      Uri.parse('http://localhost/api/deletecustomer.php'),
      body: {'id': customerId.toString()},
    );

    if (response.statusCode == 200) {
      setState(() {
        customerData = fetchData(); // Reload the data after deletion
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Customer deleted successfully'),
      ));
    } else {
      throw Exception('Failed to delete customer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Customers List'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: customerData,
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerDetailPage(customer: record),
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
                              Icon(Icons.person, color: Colors.blueAccent, size: 30),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'First Name: ${record['first_name']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Phone No: ${record['phone_no']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Mail ID: ${record['mail_id']}',
                                      style: TextStyle(
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
                                    icon: Icon(Icons.edit, color: Colors.blueAccent),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditCustomerPage(customer: record),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      // Show confirmation dialog before deleting
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Customer'),
                                            content: const Text('Are you sure you want to delete this customer?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteCustomer(record['id']); // Delete the customer
                                                  Navigator.of(context).pop(); // Close the dialog
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
                  MaterialPageRoute(builder: (context) => CustomersScreen()), // Navigate to CustomersScreen
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
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
                // Ensure the SettingsScreen is defined properly
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {
                // Ensure the ProfileScreen is defined properly
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
}
