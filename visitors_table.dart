import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'visitors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Add 'const' here

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitors Table',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 23, 146, 207),
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 9, 59, 133), // Dark blue background
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Updated for Flutter 2.5+
          bodyMedium: TextStyle(color: Color.fromARGB(255, 240, 236, 236)),
        ),
      ),
      home: const Visitorsdata(), // Add 'const' here
    );
  }
}

class Visitorsdata extends StatefulWidget {
  const Visitorsdata({super.key}); // Add 'const' here

  @override
  _VisitorsdataState createState() => _VisitorsdataState();
}

class _VisitorsdataState extends State<Visitorsdata> {
  List visitors = []; // List to hold visitors data
  bool isLoading = true; // To show loading indicator

  @override
  void initState() {
    super.initState();
    fetchVisitorsData();
  }

  // Fetching visitors data from the backend
  Future<void> fetchVisitorsData() async {
    final response =
        await http.get(Uri.parse('http://localhost/api/get_all_visitors.php'));

    if (response.statusCode == 200) {
      // Decode the JSON response from the backend
      setState(() {
        visitors = json.decode(response.body);
        isLoading = false; // Stop loading once data is fetched
      });
    } else {
      throw Exception('Failed to load visitors data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors Table'), // Add 'const' here
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '+ Add Visitor',
            onPressed: () {
              // Navigate to the AddVisitorPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VisitorsScreen()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Add 'const' here
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 17, 157, 212), // White background for the table
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
                ),
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: [
                    DataColumn2(
                      label: Container(
                        color: const Color.fromARGB(
                            255, 17, 157, 212), // Set header background color
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Full Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      size: ColumnSize.L,
                    ),
                    DataColumn(
                      label: Container(
                        color: const Color.fromARGB(
                            255, 17, 157, 212), // Set header background color
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Number',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        color: const Color.fromARGB(
                            255, 17, 157, 212), // Set header background color
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Purpose',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        color: const Color.fromARGB(
                            255, 17, 157, 212), // Set header background color
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Meeting Person',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 238, 234, 234)),
                        ),
                      ),
                    ),
                  ],
                  rows: visitors.map<DataRow>((visitor) {
                    return DataRow(
                      color: MaterialStateProperty.all(const Color.fromARGB(
                          255, 252, 251, 251)), // Row background color
                      cells: [
                        DataCell(Text(visitor['full_name'] ?? 'N/A')),
                        DataCell(Text(visitor['number'] ?? 'N/A')),
                        DataCell(Text(visitor['purpose'] ?? 'N/A')),
                        DataCell(Text(visitor['meeting_person'] ?? 'N/A')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}

// New page for adding visitor details
class AddVisitorPage extends StatelessWidget {
  const AddVisitorPage({super.key}); // Add 'const' here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Visitor'), // Add 'const' here
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Purpose',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Meeting Person',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
                // Add logic to save the new visitor
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
