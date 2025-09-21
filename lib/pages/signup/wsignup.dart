import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgentSignUpScreen extends StatefulWidget {
  const AgentSignUpScreen({super.key});

  @override
  AgentSignUpScreenState createState() => AgentSignUpScreenState();
}

class AgentSignUpScreenState extends State<AgentSignUpScreen> {
  // --- Text Editing Controllers ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // --- Focus Nodes ---
  final FocusNode _orgNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _contactFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  // --- State Variables ---
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // --- Services Data ---
  // A simple list of strings for available services.
  final List<String> _availableServices = [
    'Plumbing',
    'Electrical Work',
    'Carpentry',
    'Painting',
    'Cleaning',
    'Gardening',
    'Appliance Repair',
    'HVAC Services',
    'Masonry',
    'Roofing',
    'Pest Control',
    'Moving Services',
    'Handyman Services',
    'Auto Repair',
    'Other',
  ];
  // This list will store the names of the selected services.
  final List<String> _selectedServices = [];

  // --- UI Color Scheme ---
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color mediumBlue = Color(0xFF545E75);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color grayBlue = Color(0xFF82A0BC);

  @override
  void dispose() {
    _nameController.dispose();
    _orgNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _orgNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _contactFocusNode.dispose();
    _addressFocusNode.dispose();
    _cityFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Agent Signup', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                const Icon(Icons.business, size: 60, color: lightBlue),
                const SizedBox(height: 20),
                const Text(
                  'Create Agent Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Manage workers and connect with customers',
                  style: TextStyle(color: paleBlue, fontSize: 16),
                ),
                const SizedBox(height: 30),

                // --- Input Fields ---
                _buildInputField(
                  controller: _nameController,
                  labelText: 'Your Full Name',
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _orgNameFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: _orgNameController,
                  focusNode: _orgNameFocusNode,
                  labelText: 'Organization Name',
                  icon: Icons.corporate_fare_outlined,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your organization name';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  labelText: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _contactFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: _contactController,
                  focusNode: _contactFocusNode,
                  labelText: 'Contact Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _addressFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid contact number';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: _addressController,
                  focusNode: _addressFocusNode,
                  labelText: 'Full Address',
                  icon: Icons.location_on_outlined,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _cityFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                 _buildInputField(
                  controller: _cityController,
                  focusNode: _cityFocusNode,
                  labelText: 'City',
                  icon: Icons.location_city_outlined,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),

                // Services Selection
                _buildServicesSelection(),

                // Password Fields
                _buildInputField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  labelText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      _confirmPasswordFocusNode.requestFocus(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: grayBlue,
                    ),
                    onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  labelText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: grayBlue,
                    ),
                    onPressed: () => setState(() =>
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // --- Signup Button ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _performAgentSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Create Agent Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Back to user selection',
                    style: TextStyle(
                      color: lightBlue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable Input Field Widget ---
  Widget _buildInputField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    Function(String)? onFieldSubmitted,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: mediumBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: grayBlue, width: 1),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          labelText: labelText,
          labelStyle: const TextStyle(color: paleBlue),
          prefixIcon: Icon(icon, color: lightBlue),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
        ),
      ),
    );
  }

  // --- Services Selection Widget ---
  Widget _buildServicesSelection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: mediumBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: grayBlue, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.work_outline, color: lightBlue),
              SizedBox(width: 10),
              Text(
                'Services Offered *',
                style: TextStyle(
                  color: paleBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Select one or more services your organization provides:',
            style: TextStyle(color: paleBlue.withOpacity(0.8), fontSize: 14),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableServices.map((service) {
              final isSelected = _selectedServices.contains(service);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedServices.remove(service);
                    } else {
                      _selectedServices.add(service);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? lightBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? lightBlue : grayBlue,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    service,
                    style: TextStyle(
                      color: isSelected ? Colors.white : paleBlue,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (_selectedServices.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Please select at least one service',
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // --- Main Sign Up Logic ---
  void _performAgentSignUp() async {
    if (!_formKey.currentState!.validate() || _selectedServices.isEmpty) {
       if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one service.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      WriteBatch batch = FirebaseFirestore.instance.batch();

      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      batch.set(userDocRef, {
        'uid': uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'contact': _contactController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'profilePicUrl': '', 
        'userType': 'Agent',
        'createdAt': FieldValue.serverTimestamp(),
      });

      DocumentReference agentDocRef =
          FirebaseFirestore.instance.collection('agents').doc(uid);
      batch.set(agentDocRef, {
        'orgName': _orgNameController.text.trim(),
        'availability': true,
        'rating': {
          'average': 0, // Initial rating
          'count': 0,
        },
        'services': _selectedServices,
      });

      await batch.commit();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/agent/home', 
        (Route<dynamic> route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agent account created successfully!'),
          backgroundColor: lightBlue,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';
      if (e.code == 'email-already-in-use') {
        message = 'This email address is already registered.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      }
      _showErrorSnackBar(message);
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  void _showErrorSnackBar(String message) {
     if (!mounted) return;
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
  }
}