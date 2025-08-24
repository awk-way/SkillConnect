import 'package:flutter/material.dart';

class WorkerProfile extends StatefulWidget {
  const WorkerProfile({super.key});
  @override
  WorkerProfileState createState() => WorkerProfileState();
}

class WorkerProfileState extends State<WorkerProfile> {
  // Color scheme
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color mediumBlue = Color(0xFF545E75);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color grayBlue = Color(0xFF82A0BC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar & Name
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Worker Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
            Text(
              'worker@email.com',
              style: TextStyle(fontSize: 14, color: grayBlue),
            ),
            SizedBox(height: 20),

            // Stats Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Jobs', '12'),
                _buildStatCard('Rating', '4.8'),
                _buildStatCard('Wallet', '₹500'),
              ],
            ),

            SizedBox(height: 30),

            // Options List
            _buildOptionTile(Icons.edit, 'Edit Profile'),
            _buildOptionTile(Icons.settings, 'Settings'),
            _buildOptionTile(Icons.help_outline, 'Help & Support'),
            _buildOptionTile(Icons.logout, 'Logout', isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: grayBlue)),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : darkBlue),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: isLogout ? Colors.red : darkBlue),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: grayBlue, size: 18),
      onTap: () {
        // Add navigation logic here
      },
    );
  }
}
