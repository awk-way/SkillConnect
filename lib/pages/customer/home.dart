import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillconnect/pages/customer/jobs.dart';
import 'package:skillconnect/pages/customer/notifications.dart';
import 'package:skillconnect/pages/customer/profile.dart';
import 'package:skillconnect/pages/customer/ser_agents.dart';
import 'package:skillconnect/pages/customer/services.dart';

class Service {
  final String name;
  final String imageUrl;

  Service(this.name, this.imageUrl);
}

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});
  @override
  CustomerHomePageState createState() => CustomerHomePageState();
}

class CustomerHomePageState extends State<CustomerHomePage> {
  // --- State Variables ---
  String? _userName;
  String? _userCity;
  String? _userProfilePicUrl;
  bool _isDataLoading = true;
  int _currentIndex = 0;

  // --- UI Color Scheme ---
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color grayBlue = Color(0xFF82A0BC);

  // --- Quick Services Data ---
  final List<Service> quickServices = [
    Service(
      'AC Repair',
      'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
    ),
    Service(
      'Plumbing',
      'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png',
    ),
    Service(
      'More',
      'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user logged in");
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && mounted) {
        setState(() {
          _userName = userDoc.get('name');
          _userCity = userDoc.get('city');
          _userProfilePicUrl = userDoc.get('profilePicUrl');
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isDataLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const JobsPage(),
      const CustomerProfile(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isDataLoading
          ? const Center(child: CircularProgressIndicator(color: lightBlue))
          : pages[_currentIndex],
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
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        items: const [
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            const SizedBox(height: 32),
            Text(
              'Hello, ${_userName ?? 'User'} 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'What service do you need today?',
              style: TextStyle(fontSize: 16, color: grayBlue),
            ),
            const SizedBox(height: 24),
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildQuickServicesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    String initial = _userName != null && _userName!.isNotEmpty
        ? _userName![0].toUpperCase()
        : 'U';

    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: paleBlue,
          backgroundImage:
              _userProfilePicUrl != null && _userProfilePicUrl!.isNotEmpty
              ? NetworkImage(_userProfilePicUrl!)
              : null,
          child: (_userProfilePicUrl == null || _userProfilePicUrl!.isEmpty)
              ? Text(
                  initial,
                  style: const TextStyle(
                    color: darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location',
                style: TextStyle(fontSize: 12, color: grayBlue),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, color: lightBlue, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _userCity ?? 'Not set',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // MODIFIED: Added StreamBuilder and Stack for notification badge
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .where(
                'receiver_id',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid,
              )
              .where(
                'status',
                isEqualTo: 'unread',
              ) // Requires a composite index
              .snapshots(),
          builder: (context, snapshot) {
            int unreadCount = 0;
            if (snapshot.hasData) {
              unreadCount = snapshot.data!.docs.length;
            }
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: darkBlue,
                      size: 24,
                    ),
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search for services...',
          hintStyle: TextStyle(fontSize: 16, color: grayBlue),
          prefixIcon: Icon(Icons.search, color: grayBlue, size: 24),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildQuickServicesGrid() {
    return Row(
      children: quickServices.map((service) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (service.name == 'More') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectService(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AvailableAgentsPage(selectedService: service.name),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    child: service.name == 'More'
                        ? const Icon(
                            Icons.arrow_forward,
                            color: lightBlue,
                            size: 28,
                          )
                        : Image.network(
                            service.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.work,
                                size: 28,
                                color: lightBlue,
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
