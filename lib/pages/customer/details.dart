import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // <-- IMPORTED
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- IMPORTED
import 'package:firebase_auth/firebase_auth.dart'; // <-- IMPORTED

class JobDetailsPage extends StatefulWidget {
  final String agentId;
  final String selectedService;

  const JobDetailsPage({
    super.key,
    required this.agentId,
    required this.selectedService,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  // --- UI Color Scheme ---
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color grayBlue = Color(0xFF82A0BC);
  static const Color paleBlue = Color(0xFFA7CCED);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<XFile> _selectedImages = []; // No longer nullable
  bool _isSubmitting = false; // Changed from _isUploading
  List<String> _uploadedImageUrls = [];

  // Replace with your Cloudinary credentials
  final String cloudName = "dmtdn3s1e";
  final String uploadPreset = "skillconnect";

  // Pick multiple images
  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _selectedImages = pickedFiles;
    });
  }

  // --- ✅ FIXED: UPLOAD IMAGES (Works on Mobile AND Web) ---
  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;
    setState(() => _isSubmitting = true);

    List<String> urls = [];
    final uploadUrl = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    for (var image in _selectedImages) {
      try {
        var request = http.MultipartRequest("POST", uploadUrl)
          ..fields["upload_preset"] = uploadPreset;

        if (kIsWeb) {
          // --- Web upload ---
          request.files.add(
            http.MultipartFile.fromBytes(
              "file",
              await image.readAsBytes(),
              filename: image.name,
            ),
          );
        } else {
          // --- Mobile upload ---
          request.files.add(
            await http.MultipartFile.fromPath("file", image.path),
          );
        }

        var response = await request.send();

        if (response.statusCode == 200) {
          final responseData = json.decode(
            await response.stream.bytesToString(),
          );
          urls.add(responseData["secure_url"]);
        } else {
          // Handle non-200 response
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to upload ${image.name}.")),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading ${image.name}: $e")),
          );
        }
      }
    }

    setState(() {
      _uploadedImageUrls = urls;
      // We set _isSubmitting to false in the _submitJobDetails function
    });
  }

  // --- ✅ FIXED: Handle final submission to Firestore ---
  Future<void> _submitJobDetails() async {
    if (!_formKey.currentState!.validate()) return; // Check form first

    setState(() => _isSubmitting = true);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to post a job.')),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      // Step 1: Upload images if they exist and haven't been uploaded
      if (_selectedImages.isNotEmpty && _uploadedImageUrls.isEmpty) {
        await _uploadImages();
      }

      // Step 2: Save the new job to Firestore
      await FirebaseFirestore.instance.collection('jobs').add({
        'title': widget.selectedService,
        'description': _descriptionController.text,
        'imageUrls': _uploadedImageUrls,
        'agentId': widget.agentId,
        'userId': currentUser.uid,
        'status': 'Pending', // Initial status
        'createdAt': FieldValue.serverTimestamp(),
        'workerId': null, // No worker assigned yet
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job request sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to the customer's home page
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/customer/home', (route) => false);
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit job: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- ✅ FIXED: Matched your app theme ---
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Brief Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Describe your job requirements...",
                  hintStyle: TextStyle(color: grayBlue.withAlpha(178)),
                  filled: true,
                  fillColor: paleBlue.withAlpha(25),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: grayBlue.withAlpha(128)),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a description" : null,
              ),
              const SizedBox(height: 20),
              const Text(
                "Upload Images (Optional)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 8),

              // --- ✅ FIXED: Image Preview (Works on Mobile AND Web) ---
              _selectedImages.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          final image = _selectedImages[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: kIsWeb
                                  ? Image.network(
                                      // Use network for web preview
                                      image.path,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      // Use file for mobile preview
                                      File(image.path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: grayBlue),
                      ),
                      child: Text(
                        "No images selected",
                        style: TextStyle(color: grayBlue),
                      ),
                    ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library, color: darkBlue),
                label: const Text(
                  "Select Images",
                  style: TextStyle(color: darkBlue),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: paleBlue.withAlpha(150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),

              const SizedBox(height: 30),

              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitJobDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightBlue, // Matched theme
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Submit Job Request",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
