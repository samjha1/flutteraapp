import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FollowUpPaymentsPage extends StatefulWidget {
  @override
  _FollowUpPaymentsPageState createState() => _FollowUpPaymentsPageState();
}

class _FollowUpPaymentsPageState extends State<FollowUpPaymentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> todayDue = [];
  List<Map<String, dynamic>> upcomingPayments = [];
  List<Map<String, dynamic>> overDue = [];
  List<Map<String, dynamic>> overlaps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://shridurgamanagement.in/followupapidurga.php'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> payments =
        List<Map<String, dynamic>>.from(data);

        DateTime today = DateTime.now();

        // Filter for Today Due
        todayDue = payments.where((payment) {
          DateTime nxtDt = DateTime.parse(payment['nxt_dt']);
          return nxtDt.year == today.year &&
              nxtDt.month == today.month &&
              nxtDt.day == today.day;
        }).toList();

        // Filter for Upcoming Payments
        upcomingPayments = payments.where((payment) {
          DateTime nxtDt = DateTime.parse(payment['nxt_dt']);
          return nxtDt.isAfter(today);
        }).toList();

        // Filter for Over Due
        overDue = payments.where((payment) {
          DateTime nxtDt = DateTime.parse(payment['nxt_dt']);
          return nxtDt.isBefore(today);
        }).toList();

        // Filter for Overlaps
        Map<String, List<Map<String, dynamic>>> projectGroups = {};
        for (var payment in payments) {
          String key = '${payment['p_name']}-${payment['nxt_dt']}';
          projectGroups.putIfAbsent(key, () => []).add(payment);
        }
        overlaps = projectGroups.values
            .where((group) => group.length > 1)
            .expand((group) => group)
            .toList();

        // Sort all lists
        todayDue.sort((a, b) => DateTime.parse(a['nxt_dt'])
            .compareTo(DateTime.parse(b['nxt_dt'])));
        upcomingPayments.sort((a, b) => DateTime.parse(a['nxt_dt'])
            .compareTo(DateTime.parse(b['nxt_dt'])));
        overDue.sort((a, b) => DateTime.parse(a['nxt_dt'])
            .compareTo(DateTime.parse(b['nxt_dt'])));
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildPaymentCard(Map<String, dynamic> payment) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payment['fname'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.business, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Project: ${payment['p_name'] ?? 'N/A'}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("Rate: ₹${payment['rate'] ?? '0'}"),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("Booked: ₹${payment['book_amt'] ?? '0'}"),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.money, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("Balance: ₹${payment['balance'] ?? '0'}"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  "Next Due: ${payment['nxt_dt'] ?? 'N/A'}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Edit"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentEditPage(paymentId: payment['id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return const Center(child: Text("No data available"));
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return buildPaymentCard(data[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000),
        title: const Text('Follow Up Payments',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black, // Color for the indicator under the tabs
          labelColor: Colors.black, // Color for the selected tab label
          unselectedLabelColor: Colors.white, // Color for unselected tab labels
          tabs: const [
            Tab(text: 'Today\'s Due'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Over Due'),
            Tab(text: 'Overlaps'),
          ],
        ),

      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          buildPaymentList(todayDue), // Today's Due
          buildPaymentList(upcomingPayments), // Upcoming Payments
          buildPaymentList(overDue), // Over Due
          buildPaymentList(overlaps), // Overlaps
        ],
      ),
    );
  }
}

class PaymentEditPage extends StatelessWidget {
  final String paymentId;

  const PaymentEditPage({Key? key, required this.paymentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Payment $paymentId'),
      ),
      body: Center(
        child: Text('Edit functionality for Payment ID: $paymentId'),
      ),
    );
  }
}
