import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SettingsScreen.dart';
import 'front_page.dart';
import 'visitors.dart';
import 'profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitors List',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF800000),
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
    String url = 'https://api.indataai.in/durga/visitorsdetails.php';
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
        title: const Text(
          'Visitors List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF800000),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back button to white
        ),
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
              backgroundColor: const Color(0xFF800000),
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
                : ListView.builder(
                    itemCount: visitors.length,
                    itemBuilder: (context, index) {
                      final visitor = visitors[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        color: Colors.grey[300],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            visitor['full_name'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mobile No: ${visitor['mobile_no'] ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              Text(
                                'Location: ${visitor['location'] ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              Text(
                                'Appointment: ${visitor['appointment'] ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              Text(
                                'Email: ${visitor['email'] ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigate to the VisitorDetailScreen with visitor details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VisitorDetailScreen(visitor: visitor),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 55.0,
        color: const Color(0xFF800000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const FrontPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VisitorDetailScreen extends StatelessWidget {
  final dynamic visitor;

  const VisitorDetailScreen({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visitor Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF800000),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back button to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Ensure the content is scrollable on smaller screens
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard('Full Name', visitor['full_name']),
              _buildDetailCard('Mobile No', visitor['mobile_no']),
              _buildDetailCard('Location', visitor['location']),
              _buildDetailCard('Appointment', visitor['appointment']),
              _buildDetailCard('Email', visitor['email']),
              _buildDetailCard('Company', visitor['company']),
              _buildDetailCard('Visiting For', visitor['visiting_for']),
              _buildDetailCard('Message', visitor['message']),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for building detail cards
  Widget _buildDetailCard(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '$title: ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Text(
                  value ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
