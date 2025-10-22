import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewPage extends StatefulWidget {
  final String jobId;
  final String workerId;
  final String workerName;
  final String? agentId; // ✅ Agent handling this worker
  final bool isEditing; // Flag to indicate edit mode

  const ReviewPage({
    super.key,
    required this.jobId,
    required this.workerId,
    required this.workerName,
    this.agentId,
    required this.isEditing,
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
  String? _reviewDocId; // Firestore doc ID for editing

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadExistingReview();
    }
  }

  Future<void> _loadExistingReview() async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('reviews')
          .where('jobId', isEqualTo: widget.jobId)
          .where('workerId', isEqualTo: widget.workerId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty && mounted) {
        final doc = query.docs.first;
        _reviewDocId = doc.id;
        final data = doc.data();
        setState(() {
          _rating = (data['rating'] as num?)?.toDouble() ?? 0;
          _reviewController.text = data['review'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading review: $e')));
    }
  }

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

    try {
      final reviewsCollection = FirebaseFirestore.instance.collection(
        'reviews',
      );

      // 1️⃣ Add or update review
      if (widget.isEditing && _reviewDocId != null) {
        await reviewsCollection.doc(_reviewDocId).update({
          'rating': _rating,
          'review': _reviewController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await reviewsCollection.add({
          'jobId': widget.jobId,
          'workerId': widget.workerId,
          'workerName': widget.workerName,
          'rating': _rating,
          'review': _reviewController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 2️⃣ Update worker's average rating and ratingCount
      final workerRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.workerId);
      final workerSnapshot = await workerRef.get();

      double currentAvg = 0;
      int currentCount = 0;

      if (workerSnapshot.exists) {
        final data = workerSnapshot.data()!;
        currentAvg = (data['averageRating'] as num?)?.toDouble() ?? 0;
        currentCount = (data['ratingCount'] as int?) ?? 0;

        if (widget.isEditing && _reviewDocId != null) {
          // Editing: recalc average based on new rating
          // We'll fetch old rating first
          final oldRatingDoc = await reviewsCollection.doc(_reviewDocId).get();
          final oldRating =
              (oldRatingDoc.data()?['rating'] as num?)?.toDouble() ?? 0;

          final totalRating = currentAvg * currentCount - oldRating + _rating;
          currentAvg = totalRating / currentCount;
        } else {
          // New review: include new rating
          final totalRating = currentAvg * currentCount + _rating;
          currentCount += 1;
          currentAvg = totalRating / currentCount;
        }

        await workerRef.update({
          'averageRating': currentAvg,
          'ratingCount': currentCount,
        });
      }

      // 3️⃣ Update agent's rating if agentId is provided
      if (widget.agentId != null && widget.agentId!.isNotEmpty) {
        final agentRef = FirebaseFirestore.instance
            .collection('agents')
            .doc(widget.agentId);

        // Fetch all workers under this agent
        final workerQuery = await FirebaseFirestore.instance
            .collection('users')
            .where('agentId', isEqualTo: widget.agentId)
            .get();

        double sumRatings = 0;
        int totalWorkersWithRatings = 0;

        for (var w in workerQuery.docs) {
          final wData = w.data();
          final avgRating = (wData['averageRating'] as num?)?.toDouble() ?? 0;
          final ratingCount = (wData['ratingCount'] as int?) ?? 0;
          if (ratingCount > 0) {
            sumRatings += avgRating;
            totalWorkersWithRatings += 1;
          }
        }

        double agentAvgRating = 0;
        if (totalWorkersWithRatings > 0) {
          agentAvgRating = sumRatings / totalWorkersWithRatings;
        }

        await agentRef.update({'averageRating': agentAvgRating});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Review updated successfully!'
                : 'Review submitted successfully!',
          ),
        ),
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
        title: Text(
          widget.isEditing ? 'Edit Review' : 'Provide a Review',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                        : Text(
                            widget.isEditing
                                ? 'Update Review'
                                : 'Submit Review',
                            style: const TextStyle(
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
