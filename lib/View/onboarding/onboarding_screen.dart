import 'package:flutter/material.dart';
import '../../models/onboarding_item.dart';
import '../../widgets/brand_house_logo.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      imagePath: 'assets/images/onboarding1.jpg',
      networkFallback:
          'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=900&q=80',
      title1: 'ស្វែងរក',
      title2: 'ផ្ទះថ្មីរបស់អ្នក',
      description:
          'ស្វែងរកផ្ទះដ៏ស្រស់ស្អាត និងទីកន្លែង\nដ៏មានផាសុកភាពសម្រាប់ការរស់នៅ។',
      buttonText: 'បន្ទាប់',
      isLastPage: false,
    ),
    OnboardingItem(
      imagePath: 'assets/images/onboarding2.jpg',
      networkFallback:
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=900&q=80',
      title1: 'ស្វែងយល់ពី',
      title2: 'ជម្រើសល្អបំផុត',
      description:
          'ស្វែងរកផ្ទះ អាផាតមិន និងខុនដូ\nដែលស័ក្តិសមនឹងរបៀបរស់នៅរបស់អ្នក។',
      buttonText: 'បន្ទាប់',
      isLastPage: false,
    ),
    OnboardingItem(
      imagePath: 'assets/images/onboarding3.jpg',
      networkFallback:
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=900&q=80',
      title1: 'ចូលស្នាក់នៅ',
      title2: 'យ៉ាងងាយស្រួល',
      description:
          'ទាក់ទងម្ចាស់ផ្ទះ ណាត់មើលផ្ទះ\nនិងចូលរស់នៅប្រកបដោយភាពងាយស្រួល។',
      buttonText: 'ចាប់ផ្តើម',
      isLastPage: true,
    ),
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Full-screen PageView for seamless swiping anywhere on screen
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Top property image
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenSize.height * 0.58,
                    child: Image.asset(
                      page.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          page.networkFallback,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF163A35),
                              child: const Center(
                                child: Icon(
                                  Icons.home_work_outlined,
                                  size: 64,
                                  color: Colors.white54,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Bottom white curved sheet containing texts & logo
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: screenSize.height * 0.52,
                    child: ClipPath(
                      clipper: const OnboardingCurveClipper(dipHeight: 32.0),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                          top: 38.0,
                          left: 28.0,
                          right: 28.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // House Brand Logo
                            const BrandHouseLogo(
                              size: 46,
                              primaryColor: Color(0xFFC08A5E),
                            ),
                            const SizedBox(height: 18),

                            // Title line 1
                            Text(
                              page.title1,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1C1C1E),
                                letterSpacing: -0.3,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Title line 2 (golden amber)
                            Text(
                              page.title2,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFC08A5E),
                                letterSpacing: -0.3,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Subtitle description
                            Text(
                              page.description,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8E8E93),
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // 2. Fixed Bottom Controls (Indicator + Button)
          Positioned(
            left: 28.0,
            right: 28.0,
            bottom: bottomPadding > 0 ? bottomPadding + 14 : 26.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 3-Pill Indicators
                Row(
                  children: List.generate(_pages.length, (index) {
                    final isActive = _currentIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(right: 6),
                      height: 4,
                      width: isActive ? 26 : 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF1C1C1E)
                            : const Color(0xFFD1D1D6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 22),

                // Black Stadium Action Button
                InkWell(
                  onTap: _onNext,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withValues(alpha: 0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Button Text
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _pages[_currentIndex].buttonText,
                            key: ValueKey<String>(
                              _pages[_currentIndex].buttonText,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),

                        // Right Arrow Circle
                        Positioned(
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Skip Button (Top-Right)
          if (_currentIndex < _pages.length - 1)
            Positioned(
              top: topPadding + 14,
              right: 20,
              child: GestureDetector(
                onTap: _navigateToLogin,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000).withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'រំលង',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom Clipper producing a smooth concave scoop at the top of the card
class OnboardingCurveClipper extends CustomClipper<Path> {
  final double dipHeight;

  const OnboardingCurveClipper({this.dipHeight = 32.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    // Start at top-left
    path.moveTo(0, 0);

    // Smooth cubic bezier curve dipping down across the width
    path.cubicTo(
      size.width * 0.28,
      dipHeight * 1.35,
      size.width * 0.72,
      dipHeight * 1.35,
      size.width,
      0,
    );

    // Down to bottom-right
    path.lineTo(size.width, size.height);
    // Across to bottom-left
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant OnboardingCurveClipper oldClipper) =>
      oldClipper.dipHeight != dipHeight;
}
