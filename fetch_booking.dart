import 'dart:convert';
import 'package:durga/SiteBooking.dart';
import 'package:durga/pdf.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'customer_edit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FetchedDataScreen extends StatefulWidget {
  const FetchedDataScreen({super.key});

  @override
  _FetchedDataScreenState createState() => _FetchedDataScreenState();
}

class _FetchedDataScreenState extends State<FetchedDataScreen> {
  late Future<List<dynamic>> bookingData;
  late double _fabPositionX;
  late double _fabPositionY;

  @override
  void initState() {
    super.initState();
    bookingData = fetchData(); // Initialize the data fetching here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set initial FAB position (bottom-right corner) based on context
    _fabPositionX =
        MediaQuery.of(context).size.width - 80; // 80 is the FAB's width
    _fabPositionY =
        MediaQuery.of(context).size.height - 130; // 80 is the FAB's height
  }

  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.indataai.in/durga/fatch_booking.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load data');
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> deleteCustomer(int customerId) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.indataai.in/durga/deletecustomer.php'),
        body: {'id': customerId.toString()},
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        setState(() => bookingData = fetchData());
        _showSnackbar('Customer deleted successfully');
      } else {
        _showSnackbar('Error deleting customer: ${responseData['error']}');
      }
    } catch (e) {
      _showSnackbar('Failed to delete customer');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleWhatsAppShare(Map<String, dynamic> record) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.indataai.in/durga/whatsapp.php'),
        body: {
          'bill_no': record['bill_no'],
          'ph': record['ph'],
          'name': record['fname'],
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _showSnackbar(responseData['status'] == 'success'
            ? responseData['message']
            : 'Error: ${responseData['message']}');
      } else {
        _showSnackbar('Failed to share on WhatsApp');
      }
    } catch (e) {
      _showSnackbar('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        iconTheme: const IconThemeData(color: Colors.white),
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
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No records found',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final record = snapshot.data![index];
                  return _buildCustomerCard(record);
                },
              );
            },
          ),
          Positioned(
            left: _fabPositionX,
            top: _fabPositionY,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color(0xFF800000),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              child: FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SiteBookingPage()),
                ),
                backgroundColor: const Color(0xFF800000),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              onDragEnd: (details) {
                setState(() {
                  // Update the FAB's position based on drag position
                  _fabPositionX = details.offset.dx;
                  _fabPositionY = details.offset.dy;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.person, color: Color(0xFF800000), size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First Name: ${record['fname'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone No: ${record['ph'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Developer: ${record['developer'] ?? 'N/A'}',
                    style:
                        const TextStyle(fontSize: 14, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye,
                      color: Colors.blueAccent),
                  onPressed: () {
                    // Navigate to BookingDetailPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GeneratePDFScreen(
                          billNo: record['bill_no'].toString(),
                        ),
                      ),
                    );

                    // Immediately navigate to GeneratePDFScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailPage(
                          bill_no: record['bill_no'].toString(),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCustomerPage(
                        customer: record,
                        reloadCustomerList: () =>
                            setState(() => bookingData = fetchData()),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _showDeleteConfirmation(record),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.whatsapp,
                      color: Colors.green),
                  onPressed: () => _handleWhatsAppShare(record),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Customer'),
          content: const Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteCustomer(int.parse(record['id'].toString()));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class BookingDetailPage extends StatefulWidget {
  final String bill_no;
  const BookingDetailPage({super.key, required this.bill_no});

  @override
  _BookingDetailPageState createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  bool isLoading = true;
  Map<String, dynamic> bookingItem = {};

  @override
  void initState() {
    super.initState();
    _fetchBookingData();
  }

  Future<void> _fetchBookingData() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.indataai.in/durga/bookingdetails.php')
              .replace(queryParameters: {'bill_no': widget.bill_no}));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bookingItem = data.isNotEmpty && data['error'] == null ? data : {};
          isLoading = false;
        });
        if (bookingItem.isEmpty) {
          _showSnackbar('No data found for bill number: ${widget.bill_no}');
        }
      } else {
        throw Exception('Failed to load booking data');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackbar('Error fetching data');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Booking Item Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingItem.isEmpty
              ? const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: bookingItem.entries.map((entry) {
                      return _buildDetailBox(entry.key, entry.value);
                    }).toList(),
                  ),
                ),
    );
  }

  Widget _buildDetailBox(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              '${_capitalize(label)}: ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                value?.toString() ?? 'N/A',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    return text.isNotEmpty
        ? text[0].toUpperCase() + text.substring(1).toLowerCase()
        : text;
  }
}
