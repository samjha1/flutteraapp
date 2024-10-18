import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For external URLs
import 'visitors.dart'; // Ensure this import matches your file name
import 'skill.dart';
import 'SiteBooking.dart';
import 'games.dart' as games; // Prefix for games.dart
import 'balance.dart' as balance; // Prefix for balance.dart
import 'profile.dart'; // Import the ProfileScreen
import 'login_page.dart';

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome to Home Page')),
    );
  }
}

// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}

// Dashboard Screen
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: const [
          DashboardItem(
              icon: Icons.group, label: 'Visitors', color: Colors.blueAccent),
          DashboardItem(
              icon: Icons.account_balance_outlined,
              label: 'Balance',
              color: Colors.green),
          DashboardItem(
              icon: Icons.videogame_asset,
              label: 'Games',
              color: Colors.purple),
          DashboardItem(icon: Icons.code, label: 'Skills', color: Colors.blue),
          DashboardItem(
              icon: Icons.event_available,
              label: 'SiteBooking',
              color: Colors.teal),
          DashboardItem(
              icon: Icons.facebook,
              label: 'Social Media',
              color: Colors.blueAccent),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue.shade800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                // Define LoginPage if you haven't
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard Item Widget
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 8.0,
      child: InkWell(
        onTap: () async {
          try {
            if (label == 'Visitors') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VisitorsScreen()));
            } else if (label == 'Balance') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => balance.Visitorsdata()));
            } else if (label == 'Games') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const games.GameScreen()));
            } else if (label == 'Skills') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SkillScreen()));
            } else if (label == 'SiteBooking') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SiteBookingPage()));
            } else if (label == 'Social Media') {
              const url = 'https://www.instagram.com/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 50.0, color: color),
                const SizedBox(height: 10.0),
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
