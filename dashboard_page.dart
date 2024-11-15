
import 'package:flutter/material.dart';
import 'fetchdairy_records.dart';
import 'sidebar.dart';  // Import the Sidebar widget
import 'visitors.dart';
import 'home.dart';
import 'visitors_table.dart' as visitors_table;
import 'profile.dart';
import 'dairyScreen.dart';
import 'SiteBooking.dart';
import 'settings.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to the notification page
              print('Notification Icon Pressed');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
      ),
      drawer:  const SideBar(),  // Use the Sidebar widget here
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Profile Section at the top
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/SAM.jpeg'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'wereads',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Indian Law Practice',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Dashboard Items
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(20.0),
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: const [
                  DashboardItem(
                    icon: Icons.question_mark_outlined,
                    label: 'Enquiry',
                    color: Colors.blueAccent,
                  ),//AIzaSyAAbCAuT9ZhuDx9cH6_qqdZZTGSgL57Ims
                  DashboardItem(
                    icon: Icons.app_registration_outlined,
                    label: 'Registration',
                    color: Colors.teal,
                  ),
                  DashboardItem(
                    icon: Icons.book_outlined,
                    label: 'Diary',
                    color: Colors.deepPurple,
                  ),
                  DashboardItem(
                    icon: Icons.lightbulb_outline,
                    label: 'Diary List',
                    color: Colors.orange,
                  ),
                  DashboardItem(
                    icon: Icons.event_available_outlined,
                    label: 'Site Booking',
                    color: Colors.green,
                  ),
                  DashboardItem(
                    icon: Icons.share_outlined,
                    label: 'Social Media',
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {
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

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const DashboardItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8.0,
      shadowColor: Colors.black54,
      child: InkWell(
        onTap: () async {
          try {
            // Navigate to the appropriate page based on the label
            if (label == 'Enquiry') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VisitorsScreen()),
              );
            } else if (label == 'Registration') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const visitors_table.Visitorsdata(),
                ),
              );
            } else if (label == 'Diary') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const dairyScreen()),
              );
            } else if (label == 'Diary List') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  fetchdairy_records()),
              );
            } else if (label == 'Site Booking') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SiteBookingPage()),
              );
            } else if (label == 'Social Media') {
              // Add your navigation here for Social Media page if needed
            }
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.6), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 50.0, color: Colors.white),
                  const SizedBox(height: 10.0),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Center(child: Text('This is the notification details page')),
    );
  }
}
