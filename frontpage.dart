import 'package:durga/add_down_payment.dart';
import 'package:durga/visitors.dart';
import 'package:durga/visitors_table.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'SiteBooking.dart';
import 'calender.dart';
import 'customer_list.dart';
import 'followup.dart';
import 'sidebar.dart';

void main() {
  runApp(MaterialApp(
    home: const FrontPage(),
    routes: {
      '/Customers': (context) => const CustomerListScreen(),
      '/site_booking': (context) => const SiteBookingPage(),
      '/running_cases': (context) => const FollowUpPaymentsPage(),
      '/date_awaited_cases': (context) => const DownPaymentForm(),
      '/decided_cases': (context) => const FrontPage(),
      '/pending_cases': (context) => const FrontPage(),
    },
  ));
}

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shri Durga Developers',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF800000),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back button to white
        ),
      ),
      drawer: const SideBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCarouselSection(),
              const SizedBox(height: 20.0),
              _buildActionButtons(context),
              const SizedBox(height: 15.0),
              _buildBottomIcons(context),
              const SizedBox(height: 1.0),
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
        autoPlay: false,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 1.0,
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
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildElevatedButton(
              label: 'Visitors',
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VisitorsScreen()),
                );
              },
            ),
            _buildElevatedButton(
              label: 'Visitors Table',
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Visitorsdata()),
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
            Icons.search,
            'Search',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Visitorsdata()),
              );
            },
          ),
          _buildIconButton(
            Icons.calendar_today,
            'Calendar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeCalendarPage()),
              );
            },
          ),
          _buildIconButton(
            Icons.people,
            'Clients',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Visitorsdata()),
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
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              padding: const EdgeInsets.all(12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getButtonIcon(index),
                  size: 80.0,
                  color: const Color(0xFF800000),
                ),
                const SizedBox(height: 15.0),
                Text(
                  _getButtonLabel(index),
                  style: const TextStyle(
                    fontSize: 17.0,
                    color: Color(0xFF800000),
                  ),
                ),
              ],
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
        'color': const Color(0xFF800000),
        'image': 'assets/images/durga.jpg', // Path as string
        'text':
            'Stay updated on court schedules and automatic hearing date updates.',
      },
      {
        'color': const Color(0xFF800000),
        'image': 'assets/images/sam.webp', // Path as string
        'text': 'Upload and manage important case documents with ease.',
      },
      {
        'color': const Color(0xFF800000),
        'image': 'assets/images/durga.jpg', // Path as string
        'text': 'Chat with clients seamlessly through integrated messaging.',
      },
      {
        'color': const Color(0xFF800000),
        'image': 'assets/images/img_1.webp', // Path as string
        'text': 'Track the status of all your ongoing cases in real time.',
      },
      {
        'color': const Color(0xFF800000),
        'image': 'assets/images/img_2.webp', // Path as string
        'text': 'Keep track of all case-related payments and transactions.',
      },
      {
        'color': const Color(0xFF800000),
        'image': 'assets/images/img_3.webp', // Path as string
        'text': 'Set and monitor upcoming deadlines for each case.',
      },
    ];
    return carouselItems.map((item) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(1.0),
        child: Container(
          color: item['color'] as Color,
          padding: const EdgeInsets.all(0.0),
          child: Center(
            child: item['image'] != null
                ? Image.asset(
                    item['image'] as String, // This ensures it's a string path
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Icon(
                    item['icon'] as IconData,
                    size: 50.0,
                    color: Colors.white,
                  ),
          ),
        ),
      );
    }).toList();
  }

  // Helper Method for Buttons
  Widget _buildElevatedButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(label),
    );
  }

  // Helper Method for Icons
  Widget _buildIconButton(IconData icon, String label,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50.0,
            color: const Color(0xFF800000),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
              color: Color(0xFF800000),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Method for Case Buttons
  void _navigateToCase(BuildContext context, int index) {
    final caseRoutes = [
      const CustomerListScreen(),
      const SiteBookingPage(),
      const FollowUpPaymentsPage(),
      const DownPaymentForm(),
      const FrontPage(),
      const FrontPage(),
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
        return Icons.follow_the_signs;
      case 3:
        return Icons.payment;
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
        return 'Followup';
      case 3:
        return 'Payments';
      case 4:
        return 'upcoming';
      case 5:
        return 'upcoming';
      default:
        return 'Unknown';
    }
  }
}
