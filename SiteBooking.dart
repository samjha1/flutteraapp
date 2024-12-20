import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SiteBookingPage extends StatefulWidget {
  const SiteBookingPage({super.key});

  @override
  _SiteBookingPageState createState() => _SiteBookingPageState();
}

class _SiteBookingPageState extends State<SiteBookingPage> {
  final Map<String, TextEditingController> controllers = {
    'dt': TextEditingController(),
    'mname': TextEditingController(),
    'lname': TextEditingController(),
    'ph': TextEditingController(),
    'mail': TextEditingController(),
    'dob': TextEditingController(),
    'occupation': TextEditingController(),
    'adhar': TextEditingController(),
    'nam': TextEditingController(),
    'relation': TextEditingController(),
    'raddress': TextEditingController(),
    'paddress': TextEditingController(),
    'executive_name': TextEditingController(),
    'manager_name': TextEditingController(),
    'tel_name': TextEditingController(),
    'p_mode': TextEditingController(),
    'remark': TextEditingController(),
    'layout': TextEditingController(),
    'nxt_dt': TextEditingController(),
    'p_name': TextEditingController(),
    'sqft': TextEditingController(),
    'rate': TextEditingController(),
    'book_amt': TextEditingController(),
    'tamount': TextEditingController(),
  };

  String bookingFirm = 'Durga'; // Default value for the dropdown
  String selectedfname = ''; // To store selected fname value
  List<String> fnameList = []; // List to hold fetched fname values

  @override
  void initState() {
    super.initState();
    fetchFnames();
  }

  Future<void> fetchFnames() async {
    final url = Uri.parse('https://api.indataai.in/durga/getFnames.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          fnameList = List<String>.from(data);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  final requiredFields = [
    'dt',
    'lname',
    'ph',
    'mail',
    'dob',
    'occupation',
    'adhar',
    'raddress',
    'paddress',
    'p_name',
    'sqft',
    'rate',
    'book_amt',
    'tamount'
  ];

  final Map<String, IconData> fieldIcons = {
    'dt': Icons.calendar_today,
    'mname': Icons.person,
    'lname': Icons.person,
    'ph': Icons.phone,
    'mail': Icons.email,
    'dob': Icons.cake,
    'occupation': Icons.work,
    'adhar': Icons.credit_card,
    'nam': Icons.account_box,
    'relation': Icons.group,
    'raddress': Icons.home,
    'paddress': Icons.location_city,
    'executive_name': Icons.person_outline,
    'manager_name': Icons.supervisor_account,
    'tel_name': Icons.phone_android,
    'p_mode': Icons.payment,
    'remark': Icons.comment,
    'layout': Icons.map,
    'nxt_dt': Icons.event,
    'p_name': Icons.apartment,
    'sqft': Icons.square_foot,
    'rate': Icons.money,
    'book_amt': Icons.account_balance_wallet,
    'tamount': Icons.calculate,
  };

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!_validateFormWithHighlight()) {
      _showSnackbar(context, 'Error', 'Please fill all required fields');
      return;
    }

    try {
      final formData = controllers.map(
        (key, controller) {
          final value = controller.text.trim();
          return MapEntry(key, value.isNotEmpty ? value : null);
        },
      )..removeWhere((key, value) => value == null);

      formData['developer'] = bookingFirm;
      formData['fname'] = selectedfname;

      final response = await http.post(
        Uri.parse('https://api.indataai.in/durga/sp.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['message'] != null) {
        _showSnackbar(context, 'Success', responseData['message']);
      } else {
        _showSnackbar(
            context, 'Error', responseData['error'] ?? 'Submission failed');
      }
    } catch (e) {
      _showSnackbar(context, 'Error', 'Network error: $e');
    }
  }

  // Add this function after fetchFnames()
  Future<void> fetchUserDetails(String fname) async {
    final url =
        Uri.parse('https://api.indataai.in/durga/getFnames.php?fname=$fname');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final userData = data[0]; // Get the first record
          setState(() {
            // Update controllers with fetched data
            controllers['mname']?.text = userData['mname'] ?? '';
            controllers['lname']?.text = userData['lname'] ?? '';
            controllers['ph']?.text = userData['ph'] ?? '';
            controllers['raddress']?.text = userData['raddress'] ?? '';
            controllers['paddress']?.text = userData['paddress'] ?? '';
            controllers['adhar']?.text = userData['adhar'] ?? '';
            controllers['relation']?.text = userData['relation'] ?? '';
            controllers['nam']?.text = userData['nam'] ?? '';
            controllers['mail']?.text = userData['mail'] ?? '';
            controllers['occupation']?.text = userData['occupation'] ?? '';

            // Handle date field separately
            if (userData['dob'] != null) {
              controllers['dob']?.text = userData['dob'];
            }

            // Handle other fields if needed
            controllers['p_name']?.text = userData['p_name'] ?? '';
          });
        }
      } else {
        print('Failed to load user details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

// Update the _buildDropdownname() function
  Widget _buildDropdownname() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Full NAME',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedfname.isEmpty ? null : selectedfname,
            items: fnameList.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedfname = newValue!;
                // Fetch and populate user details when a name is selected
                fetchUserDetails(newValue);
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade300),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateFormWithHighlight() {
    bool isValid = true;

    for (String key in requiredFields) {
      if (controllers[key]?.text.trim().isEmpty ?? true) {
        setState(() {
          controllers[key]?.text = ''; // Reset the field
        });
        isValid = false;
      }
    }

    return isValid;
  }

  void _showSnackbar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      content: Text('$title: $message'),
      backgroundColor: title == 'Error' ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String _getLabelText(String fieldName) {
    switch (fieldName) {
      case 'dt':
        return 'DATE';
      case 'mname':
        return 'MIDDLE NAME';
      case 'lname':
        return 'LAST NAME';
      case 'ph':
        return 'PHONE NUMBER';
      case 'mail':
        return 'EMAIL ADDRESS';
      case 'dob':
        return 'DATE OF BIRTH';
      case 'occupation':
        return 'OCCUPATION';
      case 'adhar':
        return 'AADHAAR NUMBER';
      case 'nam':
        return 'NAME';
      case 'relation':
        return 'RELATION';
      case 'raddress':
        return 'RESIDENTIAL ADDRESS';
      case 'paddress':
        return 'PERMANENT ADDRESS';
      case 'executive_name':
        return 'EXECUTIVE NAME';
      case 'manager_name':
        return 'MANAGER NAME';
      case 'tel_name':
        return 'TELECALLER NAME';
      case 'p_mode':
        return 'PAYMENT MODE';
      case 'remark':
        return 'REMARK';
      case 'layout':
        return 'LAYOUT NAME';
      case 'nxt_dt':
        return 'NEXT DATE';
      case 'p_name':
        return 'PROJECT NAME';
      case 'sqft':
        return 'AREA (SQFT)';
      case 'rate':
        return 'RATE (PER SQFT)';
      case 'book_amt':
        return 'BOOKING AMOUNT';
      case 'tamount':
        return 'TOTAL AMOUNT';
      default:
        return fieldName.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Booking',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF800000),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select the project name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                TabBar(
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  labelColor: Colors.white,
                  tabs: [
                    Tab(text: 'DURGA'),
                    Tab(text: 'SAMBHAVI'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDropdownField(),
                  _buildDropdownname(),
                  ...controllers.entries.map(
                    (entry) => _buildTextField(entry.key, entry.value),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Second Tab (Summary)
            const Center(
              child: Text(
                'Summary Content Here',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BOOKING FIRM',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: bookingFirm,
            items: ['Durga'].map((value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                bookingFirm = newValue!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade300),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getLabelText(label),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          label == 'dt' || label == 'dob' || label == 'nxt_dt'
              ? GestureDetector(
                  onTap: () => _selectDate(context, controller),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        prefixIcon: Icon(fieldIcons[label]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blue.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 16),
                      ),
                    ),
                  ),
                )
              : TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(fieldIcons[label]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                  ),
                ),
        ],
      ),
    );
  }
}
