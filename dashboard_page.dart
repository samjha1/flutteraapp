import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For external URLs
import 'analytics.dart';
import 'skill.dart';
import 'SiteBooking.dart';
import 'games.dart' as games; // Prefix for games.dart
import 'balance.dart' as balance; // Prefix for balance.dart

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

// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page')),
    );
  }
}

// Logout Screen
class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logout')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Are you sure you want to logout?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                    context,
                    (route) => route
                        .isFirst); // Go back to the first route (Login or Exit)
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
              icon: Icons.bar_chart, label: 'Analytics', color: Colors.orange),
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
              color: Colors.teal), // Added SiteBooking
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
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
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
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogoutScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard Item Widget
class DashboardItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;

  const DashboardItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.color});

  @override
  _DashboardItemState createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8.0,
      child: InkWell(
        onTap: () async {
          setState(() {
            _isTapped = !_isTapped;
          });

          if (widget.label == 'Analytics') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            );
          } else if (widget.label == 'Balance') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const balance.BalanceScreen()), // Use prefix
            );
          } else if (widget.label == 'Games') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const games.GameScreen()), // Use prefix
            );
          } else if (widget.label == 'Skills') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SkillScreen()),
            );
          } else if (widget.label == 'SiteBooking') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SiteBookingPage(
                  // Provide actual values
                  date: '2024-10-03',
                  fullName: 'John Doe',
                  relation: 'Son',
                  dob: '2000-01-01',
                  occupation: 'Engineer',
                  presentAddress: '123 Main St',
                  permanentAddress: '456 Elm St',
                  relationship: 'Father',
                  mobileNo: '1234567890',
                  nomineeName: 'Jane Doe',
                  chequeNo: '987654',
                  drawnOn: 'ABC Bank',
                  layoutTitle: 'Skyline Apartments',
                  plotNo: '1A',
                  plotSize: '1000 sq ft',
                  plotRate: '1500',
                  paymentMode: 'Cheque',
                  paymentAmount: '1500000',
                ),
              ),
            );
          } else if (widget.label == 'Social Media') {
            const url = 'https://www.instagram.com/';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: _isTapped ? 60.0 : 50.0,
                  color: widget.color,
                ),
                const SizedBox(height: 10.0),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
