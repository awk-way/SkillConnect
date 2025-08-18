import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _userType = 'Customer';

  // SkillConnect Color Scheme
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color mediumBlue = Color(0xFF545E75);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color grayBlue = Color(0xFF82A0BC);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
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
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Create Account', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),

                Text(
                  'Join SkillConnect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Create your account to get started',
                  style: TextStyle(color: paleBlue, fontSize: 16),
                ),
                SizedBox(height: 30),

                // User Type Selection
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: mediumBlue.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: grayBlue, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I am a:',
                        style: TextStyle(color: paleBlue, fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(
                                'Customer',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'Customer',
                              groupValue: _userType,
                              activeColor: lightBlue,
                              onChanged: (value) {
                                setState(() {
                                  _userType = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(
                                'Worker',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: 'Worker',
                              groupValue: _userType,
                              activeColor: lightBlue,
                              onChanged: (value) {
                                setState(() {
                                  _userType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Full Name Field
                _buildInputField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  icon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),

                // Email Field
                _buildInputField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  labelText: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _phoneFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                // Phone Field
                _buildInputField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  labelText: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),

                // Password Field
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
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
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

                // Confirm Password Field
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
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
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

                SizedBox(height: 30),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _performSignUp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: paleBlue, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: lightBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: mediumBlue.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: grayBlue, width: 1),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(color: Colors.white, fontSize: 16),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          labelText: labelText,
          labelStyle: TextStyle(color: paleBlue),
          prefixIcon: Icon(icon, color: lightBlue),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _performSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(lightBlue),
          ),
        );
      },
    );

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      String uid = userCredential.user!.uid;

      // Determine collection name based on user type
      String collectionName = _userType == 'Customer'
          ? 'users'
          : 'serviceProvider';

      // Prepare common user data
      Map<String, dynamic> userData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'userType': _userType, // Store the user type for reference
      };

      // Add additional fields based on user type
      if (_userType == 'Worker') {
        // Add serviceProvider specific fields
        userData.addAll({
          'availability': true,
          'contact': _phoneController.text.trim(),
          'location': [0, 0], // Default location, can be updated later
          'password': _passwordController.text
              .trim(), // Note: Consider encrypting this
          'profilepic': '', // Empty initially
          'rating': {'0': '', '1': 1, '2': ''},
          'service': {'0': ''},
        });
      } else {
        // Add users (customer) specific fields
        userData.addAll({
          'address': [0, 0, 0], // Default address coordinates
          'city': '',
          'contact': _phoneController.text.trim(),
          'jobsHistory': {'0': ''},
          'profilePic': '',
        });
      }

      // Save user data in the appropriate Firestore collection
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(uid)
          .set(userData);

      // ✅ Check if widget is still mounted before using context
      if (!mounted) return;

      Navigator.of(context).pop(); // Close loading dialog

      // Navigate to appropriate screen based on user type
      String routeName = _userType == 'Customer' ? '/home' : '/home';
      Navigator.pushReplacementNamed(context, routeName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully! Welcome to SkillConnect',
          ),
          backgroundColor: lightBlue,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();

      String message = 'Something went wrong';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered';
      } else if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
