import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:skillconnect/pages/worker/profile.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  int _currentIndex = 0;
  
  // --- UI Color Scheme ---
  static const Color darkBlue = Color(0xFF304D6D);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const WorkerDashboard(),
      _buildPlaceholderPage('My Jobs', Icons.work_history_outlined),
      const WorkerProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF63ADF2), 
        unselectedItemColor: const Color(0xFF82A0BC), 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.work_history_outlined), activeIcon: Icon(Icons.work_history), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Placeholder for other pages
  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: const Color(0xFF63ADF2)),
            const SizedBox(height: 20),
            Text('$title Page', style: const TextStyle(fontSize: 24, color: darkBlue)),
            const Text('Coming Soon!', style: TextStyle(color: Color(0xFF82A0BC))),
          ],
        ),
      ),
    );
  }
}

// --- Dashboard Screen ---
class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({super.key});

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  // --- UI Color Scheme ---
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color grayBlue = Color(0xFF82A0BC);
  
  final String? workerId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          _buildAvailabilityToggle(),
          const SizedBox(height: 24),
          _buildNewJobsSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(workerId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading...", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkBlue));
        }
        final userName = snapshot.data?.get('name') ?? 'Worker';
        return Text(
          'Hello, $userName 👋',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkBlue),
        );
      },
    );
  }

  Widget _buildAvailabilityToggle() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('workers').doc(workerId).snapshots(),
          builder: (context, snapshot) {
            bool isAvailable = false;
            if (snapshot.hasData) {
              isAvailable = snapshot.data?.get('availability') ?? false;
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Are you available for new jobs?", style: TextStyle(fontSize: 16, color: darkBlue)),
                Switch(
                  value: isAvailable,
                  onChanged: (value) {
                    FirebaseFirestore.instance
                        .collection('workers')
                        .doc(workerId)
                        .update({'availability': value});
                  },
                  activeColor: lightBlue,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewJobsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your New Assignments",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('workerId', isEqualTo: workerId)
              .where('status', isEqualTo: 'Assigned') // Or 'Accepted'
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: lightBlue));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("You have no new job assignments.", style: TextStyle(color: grayBlue));
            }
            
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return NewJobCard(jobData: doc.data() as Map<String, dynamic>);
              },
            );
          },
        ),
      ],
    );
  }
}

class NewJobCard extends StatefulWidget {
  final Map<String, dynamic> jobData;
  const NewJobCard({super.key, required this.jobData});

  @override
  State<NewJobCard> createState() => _NewJobCardState();
}

class _NewJobCardState extends State<NewJobCard> {
  String _customerName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchCustomerName();
  }

  Future<void> _fetchCustomerName() async {
    try {
      final userId = widget.jobData['userId'];
      if (userId == null) {
        setState(() => _customerName = 'Unknown Customer');
        return;
      }
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if(doc.exists && mounted) {
        setState(() => _customerName = doc.data()?['name'] ?? 'Customer');
      }
    } catch(e) {
      if(mounted) setState(() => _customerName = 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.jobData['title'] ?? 'No Title';
    final timestamp = widget.jobData['createdAt'] as Timestamp?;
    final date = timestamp != null ? DateFormat('d MMM, h:mm a').format(timestamp.toDate()) : 'No date';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 16),
            Text("Customer: $_customerName"),
            Text("Assigned On: $date"),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () { /* TODO: Implement Start Job Logic */ },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF63ADF2)),
                  child: const Text("Start Job", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}