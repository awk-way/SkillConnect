import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<XFile>? _selectedImages = [];
  bool _isUploading = false;
  List<String> _uploadedImageUrls = [];

  // Replace with your Cloudinary credentials
  final String cloudName = "dmtdn3s1e";
  final String uploadPreset = "skillconnect";

  // Pick multiple images
  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles;
      });
    }
  }

  // Upload images to Cloudinary
  Future<void> _uploadImages() async {
    if (_selectedImages == null || _selectedImages!.isEmpty) return;
    setState(() => _isUploading = true);

    List<String> urls = [];

    for (var image in _selectedImages!) {
      final uploadUrl = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      var request = http.MultipartRequest("POST", uploadUrl)
        ..fields["upload_preset"] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath("file", image.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = json.decode(await response.stream.bytesToString());
        urls.add(responseData["secure_url"]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload ${image.name}. Please retry."),
          ),
        );
      }
    }

    setState(() {
      _uploadedImageUrls = urls;
      _isUploading = false;
    });
  }

  // Handle submission
  Future<void> _submitJobDetails() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages!.isNotEmpty && _uploadedImageUrls.isEmpty) {
        await _uploadImages();
      }

      // Example of saving to Firestore or your API
      // await FirebaseFirestore.instance.collection('jobs').add({
      //   'description': _descriptionController.text,
      //   'images': _uploadedImageUrls,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job details submitted successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Brief Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Describe your job requirements...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter a description" : null,
              ),
              const SizedBox(height: 20),

              const Text(
                "Upload Images",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              _selectedImages != null && _selectedImages!.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_selectedImages![index].path),
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
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Text("No images selected"),
                    ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text("Select Images"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitJobDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Submit Job Details",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
