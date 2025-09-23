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

class WorkerInfo {
  final String id;
<<<<<<< HEAD
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
=======
  final String name;
  WorkerInfo({required this.id, required this.name});
>>>>>>> 00472fa06424a8eb0b0c0cfc4f77d028e2a4d49f
}


// --- Main Agent Home Page Widget ---
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
<<<<<<< HEAD

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
=======
>>>>>>> 00472fa06424a8eb0b0c0cfc4f77d028e2a4d49f
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
          const SizedBox(height: 24),
          _buildActiveJobsSection(),
        ],
      ),
    );
  }

<<<<<<< HEAD
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
=======
   Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('jobs').where('agentId', isEqualTo: agentId).where('status', isEqualTo: 'Accepted').snapshots(),
            builder: (context, snapshot) {
              int totalJobs = 0;
              if (snapshot.hasData) {
                totalJobs = snapshot.data!.docs.length;
              }
              return _buildStatCard('Total Jobs', '$totalJobs', Icons.work_history, Colors.orange);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('workers').where('agentId', isEqualTo: agentId).snapshots(),
            builder: (context, snapshot) {
              int workerCount = 0;
              if (snapshot.hasData) {
                workerCount = snapshot.data!.docs.length;
              }
              return _buildStatCard('Workers', '$workerCount', Icons.people, Colors.green);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('agents').doc(agentId).snapshots(),
            builder: (context, snapshot) {
              double rating = 0.0;
              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                rating = (data['rating']?['average'] ?? 0.0).toDouble();
              }
              return _buildStatCard('Rating', rating.toStringAsFixed(1), Icons.star, Colors.blue);
            },
          ),
        ),
      ],
>>>>>>> 00472fa06424a8eb0b0c0cfc4f77d028e2a4d49f
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
              .where('agentId', isEqualTo: agentId)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: lightBlue),
              );
            }
<<<<<<< HEAD
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text(
                "No new job requests at the moment.",
                style: TextStyle(color: Colors.grey),
              );
            }

=======
             if (snapshot.hasError) {
              return const Text("Error loading jobs.", style: TextStyle(color: Colors.red));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("No new job requests.", style: TextStyle(color: Colors.grey));
            }
>>>>>>> 00472fa06424a8eb0b0c0cfc4f77d028e2a4d49f
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
  
  Widget _buildActiveJobsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Active Jobs",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('agentId', isEqualTo: agentId)
              .where('status', whereIn: ['Accepted', 'InProgress'])
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: lightBlue));
            }
             if (snapshot.hasError) {
              return const Text("Error loading jobs. Ensure Firestore indexes are built.", style: TextStyle(color: Colors.red));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("No active jobs at the moment.", style: TextStyle(color: Colors.grey));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return ActiveJobCard(jobData: doc.data() as Map<String, dynamic>);
              },
            );
          },
        ),
      ],
    );
  }
}

// --- Interactive New Job Card ---
class NewJobCard extends StatefulWidget {
  final Map<String, dynamic> jobData;
  final String docId;
  const NewJobCard({super.key, required this.jobData, required this.docId});

  @override
  State<NewJobCard> createState() => _NewJobCardState();
}

class _NewJobCardState extends State<NewJobCard> {
  String _customerName = 'Loading...';
  bool _isActionInProgress = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomerName();
  }

  Future<void> _fetchCustomerName() async {
    try {
      final userId = widget.jobData['userId'];
<<<<<<< HEAD
      if (userId == null) {
        setState(() => _customerName = 'Unknown Customer');
        return;
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists && mounted) {
=======
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if(doc.exists && mounted) {
>>>>>>> 00472fa06424a8eb0b0c0cfc4f77d028e2a4d49f
        setState(() => _customerName = doc.data()?['name'] ?? 'Customer');
      }
    } catch (e) {
      if (mounted) setState(() => _customerName = 'Error');
    }
  }

  Future<void> _declineJob() async {
     final confirm = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
      title: const Text("Decline Job"),
      content: const Text("Are you sure you want to decline this job request?"),
      actions: [
        TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text("Cancel")),
        TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text("Decline", style: TextStyle(color: Colors.red))),
      ],
    )) ?? false;

    if (!confirm || !mounted) return;

    setState(() => _isActionInProgress = true);

    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.update(FirebaseFirestore.instance.collection('jobs').doc(widget.docId), {'status': 'Declined'});
      batch.set(FirebaseFirestore.instance.collection('notifications').doc(), {
        'receiver_id': widget.jobData['userId'],
        'title': 'Job Request Declined',
        'message': 'Your request for "${widget.jobData['title']}" was declined by the agent.',
        'status': 'unread',
        'type': 'job_declined',
        'time': FieldValue.serverTimestamp(),
      });
      await batch.commit();
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job declined.")));
    } catch (e) {
      if (mounted) setState(() => _isActionInProgress = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _acceptAndAssignJob(String workerId) async {
     setState(() => _isActionInProgress = true);
     try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      
      batch.update(FirebaseFirestore.instance.collection('jobs').doc(widget.docId), {
        'status': 'Accepted',
        'workerId': workerId,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
      
      batch.set(FirebaseFirestore.instance.collection('notifications').doc(), {
        'receiver_id': widget.jobData['userId'],
        'title': 'Job Accepted!',
        'message': 'Your request for "${widget.jobData['title']}" has been accepted.',
        'status': 'unread',
        'type': 'job_accepted',
        'time': FieldValue.serverTimestamp(),
      });
      
      batch.set(FirebaseFirestore.instance.collection('notifications').doc(), {
        'receiver_id': workerId,
        'title': 'New Job Assignment',
        'message': 'You have been assigned a new job: "${widget.jobData['title']}".',
        'status': 'unread',
        'type': 'new_assignment',
        'time': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job accepted and assigned!"), backgroundColor: Colors.green,));
    } catch (e) {
      if (mounted) setState(() => _isActionInProgress = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error assigning job: $e")));
    }
  }

  void _showAssignWorkerDialog() async {
    showDialog(
      context: context,
      builder: (context) => AssignWorkerDialog(
        serviceNeeded: widget.jobData['title'],
        onAssign: (workerId) {
          Navigator.of(context).pop();
          _acceptAndAssignJob(workerId);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.jobData['title'] ?? 'No Title';
    final timestamp = widget.jobData['createdAt'] as Timestamp?;
    final date = timestamp != null
        ? DateFormat('d MMM, h:mm a').format(timestamp.toDate())
        : 'No date';

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: _isActionInProgress 
      ? const SizedBox.shrink()
      : Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("From: $_customerName", style: const TextStyle(color: Colors.grey)),
              Text("On: $date"),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: _declineJob, child: const Text("Decline", style: TextStyle(color: Colors.red))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _showAssignWorkerDialog,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF63ADF2)),
                    child: const Text("Accept", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActiveJobCard extends StatefulWidget {
  final Map<String, dynamic> jobData;
  const ActiveJobCard({super.key, required this.jobData});

  @override
  State<ActiveJobCard> createState() => _ActiveJobCardState();
}

class _ActiveJobCardState extends State<ActiveJobCard> {
  String _customerName = '...';
  String _workerName = '...';

  @override
  void initState() {
    super.initState();
    _fetchNames();
  }

  Future<void> _fetchNames() async {
    try {
      final customerDoc = await FirebaseFirestore.instance.collection('users').doc(widget.jobData['userId']).get();
      if (customerDoc.exists) _customerName = customerDoc.data()?['name'] ?? 'Customer';

      final workerDoc = await FirebaseFirestore.instance.collection('users').doc(widget.jobData['workerId']).get();
      if (workerDoc.exists) _workerName = workerDoc.data()?['name'] ?? 'Worker';
      
      if (mounted) setState(() {});
    } catch (e) {
      print("Error fetching names for active job card: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.jobData['title'] ?? 'No Title';
    final status = widget.jobData['status'] ?? 'Unknown';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
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
=======
>>>>>>> 00472fa06424a8eb0b0c0cfc4f77d028e2a4d49f
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
<<<<<<< HEAD
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
=======
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(status),
                  backgroundColor: status == 'Accepted' ? Colors.blue.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  labelStyle: TextStyle(color: status == 'Accepted' ? Colors.blue : Colors.green, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 16),
            Text("Customer: $_customerName"),
            Text("Assigned to: $_workerName"),
>>>>>>> 00472fa06424a8eb0b0c0cfc4f77d028e2a4d49f
          ],
        ),
      ),
    );
  }
}
<<<<<<< HEAD
=======

class AssignWorkerDialog extends StatefulWidget {
  final String serviceNeeded;
  final Function(String workerId) onAssign;
  const AssignWorkerDialog({super.key, required this.serviceNeeded, required this.onAssign});

  @override
  State<AssignWorkerDialog> createState() => _AssignWorkerDialogState();
}

class _AssignWorkerDialogState extends State<AssignWorkerDialog> {
  String? _selectedWorkerId;

  @override
  Widget build(BuildContext context) {
    final agentId = FirebaseAuth.instance.currentUser?.uid;
    return AlertDialog(
      title: const Text("Assign a Worker"),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder<List<WorkerInfo>>(
          future: _getAvailableWorkers(agentId, widget.serviceNeeded),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No available workers found for this service.");
            }

            final workers = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];
                return RadioListTile<String>(
                  title: Text(worker.name),
                  value: worker.id,
                  groupValue: _selectedWorkerId,
                  onChanged: (value) => setState(() => _selectedWorkerId = value),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: _selectedWorkerId == null ? null : () => widget.onAssign(_selectedWorkerId!),
          child: const Text("Assign"),
        ),
      ],
    );
  }

  Future<List<WorkerInfo>> _getAvailableWorkers(String? agentId, String service) async {
    if (agentId == null) return [];

    final workerQuery = await FirebaseFirestore.instance
        .collection('workers')
        .where('agentId', isEqualTo: agentId)
        .where('availability', isEqualTo: true)
        .where('services', arrayContains: service)
        .get();

    if (workerQuery.docs.isEmpty) return [];

    List<Future<WorkerInfo?>> futures = workerQuery.docs.map((doc) async {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(doc.id).get();
      if(userDoc.exists) {
        return WorkerInfo(id: doc.id, name: userDoc.data()?['name'] ?? 'Unnamed');
      }
      return null;
    }).toList();
    
    final results = await Future.wait(futures);
    return results.where((w) => w != null).cast<WorkerInfo>().toList();
  }
}

>>>>>>> 00472fa06424a8eb0b0c0cfc4f77d028e2a4d49f
