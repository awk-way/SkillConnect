import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:skillconnect/pages/agent/myjobs.dart';
import 'package:skillconnect/pages/agent/profile.dart';
import 'package:skillconnect/pages/agent/workers.dart';

class Agent {
  final String organisationName;
  final String profilePicUrl;
  Agent({required this.organisationName, required this.profilePicUrl});
}

class Job {
  final String id;
  final String title;
  final String status;
  final Timestamp createdAt;
  final String customerName;

  Job({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.customerName,
  });
}

class AgentHomePage extends StatefulWidget {
  const AgentHomePage({super.key});

  @override
  State<AgentHomePage> createState() => _AgentHomePageState();
}

class _AgentHomePageState extends State<AgentHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const AgentDashboard(),
      const AgentJobsPage(),
      const MyWorkersPage(),
      const AgentProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF63ADF2), // lightBlue
        unselectedItemColor: const Color(0xFF82A0BC), // grayBlue
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_history_outlined),
            activeIcon: Icon(Icons.work_history),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: 'Workers',
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

  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF304D6D),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: const Color(0xFF63ADF2)),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: const TextStyle(fontSize: 24, color: Color(0xFF304D6D)),
            ),
            const Text(
              'Coming Soon!',
              style: TextStyle(color: Color(0xFF82A0BC)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Dashboard Screen ---
class AgentDashboard extends StatefulWidget {
  const AgentDashboard({super.key});

  @override
  State<AgentDashboard> createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {
  // --- UI Color Scheme ---
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);

  final String? agentId = FirebaseAuth.instance.currentUser?.uid;

  Future<Agent?> _fetchAgentData() async {
    if (agentId == null) return null;
    try {
      DocumentSnapshot agentDoc = await FirebaseFirestore.instance
          .collection('agents')
          .doc(agentId)
          .get();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(agentId)
          .get();

      if (agentDoc.exists && userDoc.exists) {
        return Agent(
          organisationName: agentDoc.get('orgName') ?? 'Agent',
          profilePicUrl: userDoc.get('profilePicUrl') ?? '',
        );
      }
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        title: FutureBuilder<Agent?>(
          future: _fetchAgentData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final agent = snapshot.data!;
            final initial = agent.organisationName.isNotEmpty
                ? agent.organisationName[0].toUpperCase()
                : 'A';
            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: paleBlue,
                  backgroundImage: agent.profilePicUrl.isNotEmpty
                      ? NetworkImage(agent.profilePicUrl)
                      : null,
                  child: agent.profilePicUrl.isEmpty
                      ? Text(initial, style: const TextStyle(color: darkBlue))
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  agent.organisationName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStatsSection(),
          const SizedBox(height: 24),
          _buildNewJobsSection(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('jobs')
          .where('agentId', isEqualTo: agentId)
          .snapshots(),
      builder: (context, snapshot) {
        int totalJobs = 0;
        if (snapshot.hasData) {
          totalJobs = snapshot.data!.docs.length;
        }
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Jobs',
                '$totalJobs',
                Icons.work_history,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Workers', '5', Icons.people, Colors.green),
            ), // Placeholder
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard('Rating', '4.5', Icons.star, Colors.blue),
            ), // Placeholder
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(color: color.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildNewJobsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "New Job Requests",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('status', isEqualTo: 'Pending')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: lightBlue),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text(
                "No new job requests at the moment.",
                style: TextStyle(color: Colors.grey),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return NewJobCard(
                  jobData: doc.data() as Map<String, dynamic>,
                  docId: doc.id,
                );
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
  final String docId;
  const NewJobCard({super.key, required this.jobData, required this.docId});

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
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists && mounted) {
        setState(() => _customerName = doc.data()?['name'] ?? 'Customer');
      }
    } catch (e) {
      if (mounted) setState(() => _customerName = 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.jobData['title'] ?? 'No Title';
    final timestamp = widget.jobData['createdAt'] as Timestamp?;
    final date = timestamp != null
        ? DateFormat('d MMM, h:mm a').format(timestamp.toDate())
        : 'No date';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "From: $_customerName",
              style: const TextStyle(color: Colors.grey),
            ),
            Text("On: $date"),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Decline",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF63ADF2),
                  ),
                  child: const Text(
                    "Accept",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
