import 'package:durga/visitors.dart';
import 'package:durga/visitors_table.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'SiteBooking.dart';
import 'calender.dart';
import 'customer_list.dart';
import 'customers.dart';
import 'sidebar.dart';


void main() {
  runApp(MaterialApp(
    home: FrontPage(),
    routes: {
      '/Customers': (context) =>  CustomerListScreen(),
      '/site_booking': (context) => const SiteBookingPage(),
      '/running_cases': (context) =>  FrontPage(),
      '/date_awaited_cases': (context) => CustomerListScreen(),
      '/decided_cases': (context) =>  FrontPage(),
      '/pending_cases': (context) =>  FrontPage(),
    },
  ));
}

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Durga Welcomes',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Color(0xFF800000),
      ),
      drawer: const SideBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarouselSection(),
              const SizedBox(height: 20.0),
              _buildActionButtons(context),
              const SizedBox(height: 15.0),
              _buildBottomIcons(context),
              const SizedBox(height: 15.0),
              _buildCasesGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  // Carousel Section
  Widget _buildCarouselSection() {
    return CarouselSlider(
      items: _buildCarouselItems(),
      options: CarouselOptions(
        height: 250.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 1.5,
        enlargeFactor: 0.3,
        enableInfiniteScroll: true,
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }

  // Action Buttons Section
  Widget _buildActionButtons(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildElevatedButton(
              label: 'Visitors',
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VisitorsScreen()),
                );
              },
            ),
            _buildElevatedButton(
              label: 'visitors table',
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Visitorsdata()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Icons Section
  Widget _buildBottomIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
            Icons.search,
            'Search',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Visitorsdata()),
              );
            },
          ),
          _buildIconButton(
            Icons.calendar_today,
            'Calendar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeCalendarPage()),
              );
            },
          ),
          _buildIconButton(
            Icons.people,
            'Clients',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Visitorsdata()),
              );
            },
          ),
          _buildIconButton(
            Icons.person,
            'Users',
            onTap: () {
              // Define Users route
            },
          ),
          _buildIconButton(
            Icons.subscriptions,
            'Subscription',
            onTap: () {
              // Define Subscription route
            },
          ),
        ],
      ),
    );
  }

  // Cases Grid Section
  Widget _buildCasesGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemCount: 6, // Number of grid items
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () => _navigateToCase(context, index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getButtonIcon(index),
                  size: 50.0,
                  color: Color(0xFF800000),
                ),
                const SizedBox(height: 15.0),
                Text(
                  _getButtonLabel(index),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF800000),
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              padding: const EdgeInsets.all(12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper Methods for Carousel Items
  List<Widget> _buildCarouselItems() {
    final carouselItems = [
      {
        'color': Colors.lightBlueAccent,
        'icon': Icons.notifications_active,
        'text': 'Stay updated on court schedules and automatic hearing date updates.',
      },
      {
        'color': Colors.grey,
        'icon': Icons.description,
        'text': 'Upload and manage important case documents with ease.',
      },
      {
        'color': Colors.orangeAccent,
        'icon': Icons.chat_bubble,
        'text': 'Chat with clients seamlessly through integrated messaging.',
      },
      {
        'color': Colors.purple,
        'icon': Icons.track_changes,
        'text': 'Track the status of all your ongoing cases in real time.',
      },
      {
        'color': Colors.blueGrey,
        'icon': Icons.payment,
        'text': 'Keep track of all case-related payments and transactions.',
      },
      {
        'color': Colors.redAccent,
        'icon': Icons.timer,
        'text': 'Set and monitor upcoming deadlines for each case.',
      },
    ];

    return carouselItems.map((item) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          color: item['color'] as Color,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData, size: 60.0, color: Colors.blue.shade50),
                const SizedBox(height: 10.0),
                Text(
                  item['text'] as String,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade50,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // Helper Methods for Buttons
  Widget _buildElevatedButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, {VoidCallback? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 28.0,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, size: 30.0, color: const Color(0xFF800000)),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Navigation Method for Case Buttons
  void _navigateToCase(BuildContext context, int index) {
    final caseRoutes = [
       CustomerListScreen(),
      const SiteBookingPage(),
       FrontPage(),
      CustomerListScreen(),
       FrontPage(),
       FrontPage(),
    ];

    if (index >= 0 && index < caseRoutes.length) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => caseRoutes[index]),
      );
    }
  }

  // Helper Method for Icons
  IconData _getButtonIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person_2_rounded;
      case 1:
        return Icons.book;
      case 2:
        return Icons.upcoming;
      case 3:
        return Icons.upcoming;
      case 4:
        return Icons.upcoming;
      case 5:
        return Icons.upcoming;
      default:
        return Icons.help;
    }
  }

  String _getButtonLabel(int index) {
    switch (index) {
      case 0:
        return 'Customers';
      case 1:
        return 'Site Booking';
      case 2:
        return 'upcoming';
      case 3:
        return 'upcoming';
      case 4:
        return 'upcoming';
      case 5:
        return 'upcoming';
      default:
        return 'Unknown';
    }
  }
}
