import 'package:flutter/material.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});
  @override
  WorkerHomePageState createState() => WorkerHomePageState();
}

class WorkerHomePageState extends State<WorkerHomePage> {
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color mediumBlue = Color(0xFF545E75);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color grayBlue = Color(0xFF82A0BC);

  bool isAvailable = true;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _currentIndex == 0 ? _buildWorkerHome() : _buildOtherContent(),
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

  Widget _buildWorkerHome() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildEarningsCard(),
            SizedBox(height: 24),
            Text(
              'Your Jobs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
            SizedBox(height: 12),
            _buildJobsList(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: paleBlue,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Worker',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                Text(
                  isAvailable ? 'Available for work' : 'Currently Unavailable',
                  style: TextStyle(fontSize: 14, color: grayBlue),
                ),
              ],
            ),
          ],
        ),
        Switch(
          value: isAvailable,
          onChanged: (val) {
            setState(() {
              isAvailable = val;
            });
          },
          activeColor: lightBlue,
        ),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Earnings',
                style: TextStyle(color: grayBlue, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                '₹8,540',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ],
          ),
          Icon(
            Icons.account_balance_wallet_outlined,
            color: lightBlue,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    final jobs = [
      {'title': 'Job 1', 'date': 'Today, 4 PM'},
      {'title': 'Job 2', 'date': 'Tomorrow, 10 AM'},
    ];

    return Column(
      children: jobs
          .map(
            (job) => Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['title']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: darkBlue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        job['date']!,
                        style: TextStyle(fontSize: 14, color: grayBlue),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, color: grayBlue, size: 16),
                ],
              ),
            ),
          )
          .toList(),
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
