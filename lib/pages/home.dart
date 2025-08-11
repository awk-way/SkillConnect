import 'package:flutter/material.dart';
import 'package:skillconnect/pages/services.dart';

// Service class definition
class Service {
  final String name;
  final String imageUrl;

  Service(this.name, this.imageUrl);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // Color scheme
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color mediumBlue = Color(0xFF545E75);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color grayBlue = Color(0xFF82A0BC);

  // Bottom navigation
  int _currentIndex = 0;

  List<Service> services = [
    Service(
      'Cleaning',
      'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
    ),
    Service(
      'Plumber',
      'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
    ),
    Service(
      'Electrician',
      'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png',
    ),
    Service(
      'Painter',
      'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png',
    ),
    Service('Carpenter', 'https://img.icons8.com/fluency/2x/drill.png'),
    Service(
      'Gardener',
      'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png',
    ),
  ];

  List<Map<String, dynamic>> workers = [
    {
      'name': 'Alfredo Schafer',
      'profession': 'Plumber',
      'avatar': 'AS',
      'rating': 4.8,
    },
    {
      'name': 'Michelle Baldwin',
      'profession': 'Cleaner',
      'avatar': 'MB',
      'rating': 4.6,
    },
    {
      'name': 'Brenon Kalu',
      'profession': 'Driver',
      'avatar': 'BK',
      'rating': 4.4,
    },
  ];

  // Service icon and color mapping
  Map<String, Map<String, dynamic>> serviceConfig = {
    'Cleaning': {'icon': Icons.cleaning_services, 'color': Color(0xFF4CAF50)},
    'Plumber': {'icon': Icons.plumbing, 'color': Color(0xFF2196F3)},
    'Electrician': {
      'icon': Icons.electrical_services,
      'color': Color(0xFFFF9800),
    },
    'Painter': {'icon': Icons.format_paint, 'color': Color(0xFF9C27B0)},
    'Carpenter': {'icon': Icons.carpenter, 'color': Color(0xFF795548)},
    'Gardener': {'icon': Icons.local_florist, 'color': Color(0xFF4CAF50)},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome to SkillConnect',
          style: TextStyle(
            color: darkBlue,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {},
              icon: Stack(
                children: [
                  Icon(Icons.notifications_outlined, color: darkBlue, size: 28),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildHomeContent()
          : _currentIndex == 1
          ? SelectService()
          : _buildProfileContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: lightBlue,
        unselectedItemColor: grayBlue,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Section
          _buildSectionHeader('Recent', 'View all'),
          SizedBox(height: 16),
          _buildRecentCard(),
          SizedBox(height: 32),

          // Categories Section
          _buildSectionHeader('Categories', 'View all'),
          SizedBox(height: 16),
          _buildCategoriesGrid(),
          SizedBox(height: 32),

          // Top Rated Section
          _buildSectionHeader('Top Rated', 'View all'),
          SizedBox(height: 16),
          _buildTopRatedList(),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 80, color: lightBlue),
          SizedBox(height: 20),
          Text(
            'Profile Page',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          SizedBox(height: 12),
          Text('Coming Soon!', style: TextStyle(fontSize: 16, color: grayBlue)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            actionText,
            style: TextStyle(
              color: lightBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(shape: BoxShape.circle, color: paleBlue),
            child: Center(
              child: Text(
                'IK',
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Isabel Kirkland',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Cleaner',
                  style: TextStyle(fontSize: 14, color: grayBlue),
                ),
              ],
            ),
          ),

          // View Profile Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              'View Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final config =
            serviceConfig[service.name] ??
            {'icon': Icons.work, 'color': lightBlue};

        return GestureDetector(
          onTap: () {
            // Navigate to category
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: config['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(config['icon'], color: config['color'], size: 28),
                ),
                SizedBox(height: 12),
                Text(
                  service.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: darkBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopRatedList() {
    return Column(
      children: workers.map((worker) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: paleBlue,
                ),
                child: Center(
                  child: Text(
                    worker['avatar'],
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      worker['profession'],
                      style: TextStyle(fontSize: 14, color: grayBlue),
                    ),
                  ],
                ),
              ),

              // Rating
              Row(
                children: [
                  Text(
                    worker['rating'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.star, color: Colors.amber, size: 18),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
