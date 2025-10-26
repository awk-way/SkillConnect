import 'package:flutter/material.dart';
// Import the screen you want to go to after onboarding
import 'package:skillconnect/pages/signup/signup.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- Define your colors from the image ---
  static const Color darkBlue = Color(0xFF304D6D);
  static const Color lightBlue = Color(0xFF63ADF2);
  static const Color grayBlue = Color(0xFF82A0BC);
  static const Color paleBlue = Color(0xFFA7CCED);
  static const Color textDark = Color(0xFF333333); // For titles
  static const Color textLight = Color(0xFF666666); // For subtitles

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- Navigation logic for "Skip" or "Get Started" ---
  void _completeOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UserTypeSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- PageView for the 4 screens ---
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // --- Page 1: SkillConnect ---
                  _buildPage(
                    title: "SkillConnect",
                    subtitle:
                        "SkillConnect at your service. One app for all your home repair and handyman needs.",
                    isLogo: true, // Special flag to use the app logo
                  ),

                  // --- Page 2: Easy Process ---
                  _buildPage(
                    title: "Easy Process",
                    subtitle:
                        "Booking made effortless. Find and hire the right handyman in just a few taps.",
                    // !! MODIFIED: Replaced placeholder with your image !!
                    imageWidget: Image.asset(
                      'assets/images/1.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback text if image fails to load
                        return const Text(
                          'Easy Process',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        );
                      },
                    ),
                  ),

                  // --- Page 3: Fast Transportation ---
                  _buildPage(
                    title: "Fast Transportation",
                    subtitle:
                        "Faster transport, quicker service. Your handyman arrives on time, every time.",
                    // !! MODIFIED: Replaced placeholder with your image !!
                    imageWidget: Image.asset(
                      'assets/images/2.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Fast Transportation',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        );
                      },
                    ),
                  ),

                  // --- Page 4: Expert People ---
                  _buildPage(
                    title: "Expert People",
                    subtitle:
                        "Skilled hands, trusted service. Get help from trained and verified experts.",
                    // !! MODIFIED: Replaced placeholder with your image !!
                    imageWidget: Image.asset(
                      'assets/images/3.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Expert People',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // --- Bottom Controls (Indicator + Button) ---
            Padding(
              // Consistent padding from the bottom
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 30.0),
              child: Column(
                children: [
                  _buildPageIndicator(),
                  const SizedBox(height: 40),
                  _buildBottomButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper to build each page's content ---
  Widget _buildPage({
    required String title,
    required String subtitle,
    Widget? imageWidget,
    bool isLogo = false,
  }) {
    // This Column matches the layout in the image
    return Column(
      children: [
        // --- Top blue container for the image ---
        Expanded(
          flex: 3, // Gives more space to the image area
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(30), // From image
            ),
            child: Stack(
              children: [
                // "Skip" Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: grayBlue.withAlpha(200), // Muted color
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                // Main Image/Logo
                Center(
                  child: isLogo
                      ? Container(
                          width: 150, // Logo size
                          height: 150,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Image.asset(
                            'assets/images/skillconnect_logo.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.build_circle,
                                color: Colors.white,
                                size: 80,
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: imageWidget, // Your placeholder/illustration
                        ),
                ),
              ],
            ),
          ),
        ),

        // --- Bottom area for text ---
        Expanded(
          flex: 2, // Gives less space to the text area
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: textLight,
                    fontSize: 16,
                    height: 1.4, // Line spacing
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Helper to build the 4-dot page indicator ---
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: _currentPage == index ? 24.0 : 8.0, // Active dot is wider
          decoration: BoxDecoration(
            color: _currentPage == index ? darkBlue : paleBlue,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }

  // --- Helper to build the "Next" / "Get Started" button ---
  Widget _buildBottomButton() {
    bool isLastPage = _currentPage == 3;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLastPage
            ? _completeOnboarding // Go to home/signup
            : () {
                // Go to next page
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // From image
          ),
          elevation: 3,
        ),
        child: Text(
          isLastPage ? 'Get Started' : 'Next',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
