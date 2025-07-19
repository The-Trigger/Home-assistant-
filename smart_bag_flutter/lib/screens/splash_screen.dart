import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import 'auth_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _fadeController.forward();
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize services
      final authService = Provider.of<AuthService>(context, listen: false);

      // Wait for minimum splash time
      await Future.delayed(const Duration(seconds: 3));

      // Check if user is already authenticated
      final isSessionValid = await authService.isSessionValid();
      
      if (mounted) {
        if (isSessionValid && authService.isAuthenticated) {
          // Navigate to main screen
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        } else {
          // Navigate to authentication screen
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AuthScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error during app initialization: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                FontAwesomeIcons.briefcase,
                                size: 60,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Animated Title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Smart Bag',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Controller',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w300,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Animated Subtitle
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          height: 50,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Secure fingerprint access',
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                              TypewriterAnimatedText(
                                'Bluetooth connectivity',
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                              TypewriterAnimatedText(
                                'Smart umbrella control',
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            repeatForever: true,
                            pause: const Duration(milliseconds: 1000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Loading indicator and version
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Initializing Smart Bag System...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Version 1.0.0',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
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