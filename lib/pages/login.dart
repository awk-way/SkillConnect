import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // SkillConnect Color Scheme
  static const Color darkBlue = Color(0xFF304D6D); // Primary dark
  static const Color mediumBlue = Color(0xFF545E75); // Secondary dark
  static const Color lightBlue = Color(0xFF63ADF2); // Accent blue
  static const Color paleBlue = Color(0xFFA7CCED); // Light accent
  static const Color grayBlue = Color(0xFF82A0BC); // Medium accent

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
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
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // App Logo/Title
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.build_circle,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'SkillConnect',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  'Login To Continue!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Connect with skilled professionals in your area',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: paleBlue, fontSize: 16),
                ),
                SizedBox(height: 40),

                // Email Field
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: mediumBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: grayBlue, width: 1),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: paleBlue),
                      prefixIcon: Icon(Icons.email_outlined, color: lightBlue),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
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
                ),

                // Password Field
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: mediumBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: grayBlue, width: 1),
                  ),
                  child: TextFormField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(color: paleBlue),
                      prefixIcon: Icon(Icons.lock_outline, color: lightBlue),
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
                      border: InputBorder.none,
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Implement forgot password
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Forgot password feature coming soon!'),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: lightBlue, fontSize: 14),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Login Button
                Container(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simulate login process
                        _performLogin();
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
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: grayBlue, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('OR', style: TextStyle(color: paleBlue)),
                    ),
                    Expanded(child: Divider(color: grayBlue, thickness: 1)),
                  ],
                ),

                SizedBox(height: 20),

                // Google Sign In Button
                Container(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      // Implement Google Sign In
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Google Sign In coming soon!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: grayBlue, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login, color: paleBlue),
                        SizedBox(width: 10),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: paleBlue, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to sign up page
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Sign Up',
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

  void _performLogin() {
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

    // Simulate API call delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog

      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/home');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Successful! Welcome to SkillConnect'),
          backgroundColor: Color(0xFF63ADF2),
        ),
      );
    });
  }
}
