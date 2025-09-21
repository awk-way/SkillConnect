import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AgentEditProfilePage extends StatefulWidget {
  const AgentEditProfilePage({super.key});

  @override
  _AgentEditProfilePageState createState() => _AgentEditProfilePageState();
}

class _AgentEditProfilePageState extends State<AgentEditProfilePage> {
  // --- UI Color Scheme ---
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color grayBlue = Color(0xFF82A0BC);
  static const Color paleBlue = Color(0xFFA7CCED);

  // --- Form & State ---
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;
  File? _imageFile;
  String? _currentProfilePicUrl;

  final _orgNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final List<String> _selectedServices = [];

  final List<String> _availableServices = [
    'Plumbing', 'Electrical Work', 'Carpentry', 'Painting', 'Cleaning', 
    'Gardening', 'Appliance Repair', 'HVAC Services', 'Masonry', 'Roofing',
    'Pest Control', 'Moving Services', 'Handyman Services', 'Auto Repair', 'Other',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAgentData();
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchAgentData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not found");

      final agentDoc = await FirebaseFirestore.instance.collection('agents').doc(user.uid).get();
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (agentDoc.exists && userDoc.exists && mounted) {
        final agentData = agentDoc.data()!;
        final userData = userDoc.data()!;

        _orgNameController.text = agentData['name'] ?? '';
        _contactController.text = userData['contact'] ?? '';
        _addressController.text = agentData['address'] ?? '';
        _cityController.text = agentData['city'] ?? '';
        _currentProfilePicUrl = userData['profilePicUrl'];
        _selectedServices.addAll(List<String>.from(agentData['services'] ?? []));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load data: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Authentication error");

      String newProfilePicUrl = _currentProfilePicUrl ?? '';

      // 1. Upload new image if one was selected
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance.ref().child('profile_pics').child('${user.uid}.jpg');
        await ref.putFile(_imageFile!);
        newProfilePicUrl = await ref.getDownloadURL();
      }

      // 2. Use a batch write to update both documents
      WriteBatch batch = FirebaseFirestore.instance.batch();

      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      batch.update(userDocRef, {
        'contact': _contactController.text.trim(),
        'profilePicUrl': newProfilePicUrl,
        'name': _orgNameController.text.trim(), 
      });

      final agentDocRef = FirebaseFirestore.instance.collection('agents').doc(user.uid);
      batch.update(agentDocRef, {
        'organisationName': _orgNameController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'services': _selectedServices,
      });

      await batch.commit();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated successfully!")));
        Navigator.of(context).pop();
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile: $e")));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _updateProfile,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: lightBlue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 24),
                    TextFormField(controller: _orgNameController, decoration: const InputDecoration(labelText: 'Organisation Name')),
                    const SizedBox(height: 16),
                    TextFormField(controller: _contactController, decoration: const InputDecoration(labelText: 'Contact Number'), keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Full Address')),
                    const SizedBox(height: 16),
                    TextFormField(controller: _cityController, decoration: const InputDecoration(labelText: 'City')),
                    const SizedBox(height: 24),
                    _buildServicesSelection(),
                    const SizedBox(height: 24),
                     if (_isSaving) const Center(child: CircularProgressIndicator(color: lightBlue)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: paleBlue,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!)
                : (_currentProfilePicUrl != null && _currentProfilePicUrl!.isNotEmpty
                    ? NetworkImage(_currentProfilePicUrl!)
                    : null) as ImageProvider?,
            child: _imageFile == null && (_currentProfilePicUrl == null || _currentProfilePicUrl!.isEmpty)
                ? const Icon(Icons.business, size: 50, color: darkBlue)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: lightBlue,
                child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildServicesSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Update Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkBlue)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableServices.map((service) {
              bool isSelected = _selectedServices.contains(service);
              return GestureDetector(
                onTap: () => setState(() {
                  isSelected ? _selectedServices.remove(service) : _selectedServices.add(service);
                }),
                child: Chip(
                  label: Text(service),
                  backgroundColor: isSelected ? lightBlue : Colors.grey.shade200,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : darkBlue),
                  side: BorderSide.none,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}