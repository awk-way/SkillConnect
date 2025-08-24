import 'package:flutter/material.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});
  @override
  WorkerHomePageState createState() => WorkerHomePageState();
}

class WorkerHomePageState extends State<WorkerHomePage> {
  // Color scheme
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color mediumBlue = Color(0xFF545E75);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color grayBlue = Color(0xFF82A0BC);

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _currentIndex == 0 ? _buildHomeContent() : _buildOtherContent(),
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
            label: 'Jobs',
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with User Info
            _buildTopBar(),
            SizedBox(height: 32),

            Text(
              'What service do you need?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: darkBlue,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        // User Avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: paleBlue),
          child: ClipOval(
            child: Image.network(
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: darkBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 12),

        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Quick Location',
                    style: TextStyle(fontSize: 14, color: grayBlue),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: grayBlue, size: 20),
                ],
              ),
            ],
          ),
        ),

        // Notification Icon
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.notifications_outlined, color: darkBlue, size: 24),
        ),
      ],
    );
  }

  Widget _buildOtherContent() {
    String pageName = _currentIndex == 1 ? 'Jobs' : 'Profile';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _currentIndex == 1 ? Icons.work : Icons.person,
            size: 80,
            color: lightBlue,
          ),
          SizedBox(height: 20),
          Text(
            '$pageName Page',
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
}
