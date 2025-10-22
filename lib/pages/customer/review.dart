import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewPage extends StatefulWidget {
  final String jobId;
  final String workerId;
  final String workerName;
  final String agentId;

  const ReviewPage({
    super.key,
    required this.jobId,
    required this.workerId,
    required this.workerName,
    required this.agentId,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color grayBlue = Color(0xFF82A0BC);

  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating before submitting.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final firestore = FirebaseFirestore.instance;

    try {
      // ✅ Step 1: Store rating and review inside the job document
      await firestore.collection('jobs').doc(widget.jobId).update({
        'rating': _rating,
        'review': _reviewController.text.trim(),
        'reviewedAt': FieldValue.serverTimestamp(),
      });

      // ✅ Step 2: Update worker’s average rating
      final workerJobsSnapshot = await firestore
          .collection('jobs')
          .where('workerId', isEqualTo: widget.workerId)
          .where('rating', isGreaterThan: 0)
          .get();

      double totalWorkerRating = 0;
      for (var doc in workerJobsSnapshot.docs) {
        totalWorkerRating += (doc['rating'] as num).toDouble();
      }
      double avgWorkerRating = workerJobsSnapshot.docs.isNotEmpty
          ? totalWorkerRating / workerJobsSnapshot.docs.length
          : _rating;

      await firestore.collection('workers').doc(widget.workerId).update({
        'rating': avgWorkerRating,
        'ratingCount': workerJobsSnapshot.docs.length,
      });

      // ✅ Step 3: Update agent’s average rating (average of all workers under them)
      final workersSnapshot = await firestore
          .collection('workers')
          .where('agentId', isEqualTo: widget.agentId)
          .where('rating', isGreaterThan: 0)
          .get();

      double totalAgentRating = 0;
      for (var doc in workersSnapshot.docs) {
        totalAgentRating += (doc['rating'] as num).toDouble();
      }

      double avgAgentRating = workersSnapshot.docs.isNotEmpty
          ? totalAgentRating / workersSnapshot.docs.length
          : avgWorkerRating;

      await firestore.collection('agents').doc(widget.agentId).update({
        'rating': avgAgentRating,
        'ratingCount': workersSnapshot.docs.length,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error submitting review: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: lightBlue,
            size: 36,
          ),
          onPressed: () {
            setState(() => _rating = (index + 1).toDouble());
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: const Text(
          'Provide a Review',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Rate your experience with',
                  style: TextStyle(color: grayBlue, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.workerName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 20),
                _buildStarRating(),
                const SizedBox(height: 20),
                TextField(
                  controller: _reviewController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Write your review (optional)',
                    hintStyle: TextStyle(color: grayBlue.withOpacity(0.7)),
                    filled: true,
                    fillColor: paleBlue.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: grayBlue.withOpacity(0.5)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
