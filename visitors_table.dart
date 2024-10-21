import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'visitors.dart'; // Make sure this imports your VisitorsScreen widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitors Table',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 23, 146, 207),
        scaffoldBackgroundColor:
        const Color.fromARGB(255, 9, 59, 133), // Dark blue background
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color.fromARGB(255, 240, 236, 236)),
        ),
      ),
      home: const Visitorsdata(),
    );
  }
}

class Visitorsdata extends StatefulWidget {
  const Visitorsdata({super.key});

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
        title: const Text('Visitors Table'),
        backgroundColor: const Color.fromARGB(255, 23, 146, 207),
        elevation: 0,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Visitor',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // Navigate to the AddVisitorPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VisitorsScreen()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 17, 157, 212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 17, 157, 212),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Visitor List',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  dataRowHeight: 60,
                  headingRowHeight: 60,
                  columns: [
                    DataColumn2(
                      label: Container(
                        color: const Color.fromARGB(255, 17, 157, 212),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Full Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                      size: ColumnSize.L,
                    ),
                    DataColumn(
                      label: Container(
                        color: const Color.fromARGB(255, 17, 157, 212),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Number',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        color: const Color.fromARGB(255, 17, 157, 212),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Purpose',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        color: const Color.fromARGB(255, 17, 157, 212),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Meeting Person',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  rows: visitors.map<DataRow>((visitor) {
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color.fromARGB(255, 17, 120, 180);
                          }
                          return const Color.fromARGB(255, 240, 240, 240);
                        },
                      ),
                      cells: [
                        DataCell(Text(
                          visitor['full_name'] ?? 'N/A',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )),
                        DataCell(Text(
                          visitor['number'] ?? 'N/A',
                          style: const TextStyle(fontSize: 14),
                        )),
                        DataCell(Text(
                          visitor['purpose'] ?? 'N/A',
                          style: const TextStyle(fontSize: 14),
                        )),
                        DataCell(Text(
                          visitor['meeting_person'] ?? 'N/A',
                          style: const TextStyle(fontSize: 14),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
