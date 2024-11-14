import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'visitors.dart';// Ensure you import the correct page

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header with Gradient Background and Profile Picture
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.book, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Advocate Diary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Run office from your pocket...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Navigate to the DashboardPage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Enquiry'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const VisitorsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Client'),
            onTap: () {
              Navigator.pushNamed(context, '/client');
            },
          ),
          ListTile(
            leading: const Icon(Icons.details),
            title: const Text('Detail'),
            onTap: () {
              Navigator.pushNamed(context, '/detail');
            },
          ),
          ListTile(
            leading: const Icon(Icons.meeting_room),
            title: const Text('Meeting'),
            onTap: () {
              Navigator.pushNamed(context, '/meeting');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Advocate'),
            onTap: () {
              Navigator.pushNamed(context, '/advocate');
            },
          ),
          const Divider(), // Adds a divider between sections
          ListTile(
            leading: const Icon(Icons.power_settings_new),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
