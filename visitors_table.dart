import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'visitors.dart';

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
        scaffoldBackgroundColor: const Color.fromARGB(255, 9, 59, 133),
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
  List visitors = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVisitorsData(); // Fetch all visitors initially
  }

  // Function to fetch data with optional search parameter
  Future<void> fetchVisitorsData([String? searchQuery]) async {
    setState(() {
      isLoading = true;
    });

    // Construct the URL with the optional search query
    String url = 'https://api.indataai.in/durga/get_all_visitors.php';
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '?search=$searchQuery';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        visitors = json.decode(response.body);
        isLoading = false;
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
        backgroundColor: const Color.fromARGB(255, 23, 20, 184),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Visitor',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
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
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Visitors...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Fetch data based on the search input
                fetchVisitorsData(value);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : DataTable2(
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    minWidth: 370,
                    dataRowHeight: 50,
                    headingRowHeight: 50,
                    columns: const [
                      DataColumn2(
                        label: Center(
                          child: Text(
                            'Full Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        size: ColumnSize.L,
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(
                            'Number',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(
                            'Purpose',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text(
                            'Meeting',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: visitors.map<DataRow>((visitor) {
                      return DataRow(
                        cells: [
                          DataCell(Center(
                            child: Text(
                              visitor['full_name'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          )),
                          DataCell(Center(
                            child: Text(
                              visitor['number'] ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black),
                            ),
                          )),
                          DataCell(Center(
                            child: Text(
                              visitor['purpose'] ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black),
                            ),
                          )),
                          DataCell(Center(
                            child: Text(
                              visitor['meeting_person'] ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black),
                            ),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
