import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Add this dependency for date formatting

// Note: You will need to add this to your pubspec.yaml:
// intl: ^0.18.1

// --- Data Model for a Job ---
class Job {
  final String id;
  final String title;
  final String status;
  final Timestamp createdAt;
  final String? agentId;

  Job({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    this.agentId,
  });

  factory Job.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Job(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      status: data['status'] ?? 'Unknown',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      agentId: data['agentId'],
    );
  }
}

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  // --- UI Color Scheme ---
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color grayBlue = Color(0xFF82A0BC);
  static const Color mediumBlue = Color(0xFF545E75);

  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Ongoing and Past
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('My Jobs', style: TextStyle(color: Colors.white)),
          backgroundColor: darkBlue,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: lightBlue,
            labelColor: Colors.white,
            unselectedLabelColor: grayBlue,
            tabs: [
              Tab(text: 'Ongoing'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('userId', isEqualTo: currentUserId)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: lightBlue));
            }
            if (snapshot.hasError) {
              // Show the Firestore error message directly in the UI
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: ${snapshot.error}\n\nPlease ensure you have created the required Firestore index.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState();
            }

            final jobs = snapshot.data!.docs.map((doc) => Job.fromFirestore(doc)).toList();

            final ongoingJobs = jobs.where((job) =>
                job.status.toLowerCase() != 'completed' && job.status.toLowerCase() != 'canceled').toList();
            
            final pastJobs = jobs.where((job) =>
                job.status.toLowerCase() == 'completed' || job.status.toLowerCase() == 'canceled').toList();

            return TabBarView(
              children: [
                _buildJobsList(ongoingJobs, 'No ongoing jobs found.'),
                _buildJobsList(pastJobs, 'No past jobs found.'),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildJobsList(List<Job> jobs, String emptyMessage) {
    if (jobs.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: const TextStyle(color: grayBlue, fontSize: 16)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return JobCard(job: jobs[index]);
      },
    );
  }
  
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_history_outlined, size: 80, color: lightBlue),
          SizedBox(height: 20),
          Text(
            'No Jobs Yet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkBlue),
          ),
          SizedBox(height: 10),
          Text(
            'Your requested services will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: grayBlue),
          ),
        ],
      ),
    );
  }
}

// --- Reusable Job Card Widget (now StatefulWidget) ---
class JobCard extends StatefulWidget {
  final Job job;
  const JobCard({super.key, required this.job});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  String? _agentName;

  @override
  void initState() {
    super.initState();
    _fetchAgentName();
  }

  Future<void> _fetchAgentName() async {
    if (widget.job.agentId == null || widget.job.agentId!.isEmpty) {
      setState(() {
        _agentName = 'Not assigned';
      });
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance.collection('agents').doc(widget.job.agentId).get();
      if (doc.exists && mounted) {
        setState(() {
          _agentName = doc.data()?['organisationName'] ?? 'Unknown Agent';
        });
      }
    } catch (e) {
       if (mounted) {
         setState(() {
           _agentName = 'Error fetching agent';
         });
       }
    }
  }

  // Helper to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orangeAccent;
      case 'accepted': return Colors.blueAccent;
      case 'in progress': return Colors.lightBlue;
      case 'completed': return Colors.green;
      case 'canceled': return Colors.redAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.job.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _JobsPageState.darkBlue),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.job.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.job.status,
                    style: TextStyle(color: _getStatusColor(widget.job.status), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today_outlined, DateFormat('MMMM d, yyyy').format(widget.job.createdAt.toDate())),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.person_outline, _agentName ?? 'Loading agent...'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _JobsPageState.grayBlue),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, color: _JobsPageState.mediumBlue)),
      ],
    );
  }
}