import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _showPinInput = false;
  bool _obscurePin = true;
  String _errorMessage = '';
  
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _bounceAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
    
    _bounceController.forward();
  }

  void _checkBiometricAvailability() {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (!authService.isBiometricAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showPinInput = true;
        });
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.authenticateWithBiometrics();
      
      if (result.success) {
        _navigateToMainScreen();
      } else {
        setState(() {
          _errorMessage = result.message;
          if (result.errorType == AuthErrorType.notAvailable ||
              result.errorType == AuthErrorType.notEnrolled) {
            _showPinInput = true;
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication error occurred';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _authenticateWithPin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.authenticateWithPin(_pinController.text);
      
      if (result.success) {
        _navigateToMainScreen();
      } else {
        setState(() {
          _errorMessage = result.message;
        });
        _pinController.clear();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'PIN authentication error occurred';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _togglePinVisibility() {
    setState(() {
      _obscurePin = !_obscurePin;
    });
  }

  void _showPinInputDialog() {
    setState(() {
      _showPinInput = true;
      _errorMessage = '';
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: AnimationLimiter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 600),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: [
                              // Logo
                              AnimatedBuilder(
                                animation: _bounceAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _bounceAnimation.value,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryBlue.withOpacity(0.3),
                                            spreadRadius: 3,
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        FontAwesomeIcons.briefcase,
                                        size: 50,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Title
                              Text(
                                'Welcome Back',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              Text(
                                'Authenticate to access your Smart Bag',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 48),
                              
                              // Error message
                              if (_errorMessage.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 24),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.error.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: AppColors.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _errorMessage,
                                          style: const TextStyle(
                                            color: AppColors.error,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              
                              // Biometric authentication
                              Consumer<AuthService>(
                                builder: (context, authService, child) {
                                  if (authService.isBiometricAvailable && !_showPinInput) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primaryBlue.withOpacity(0.2),
                                                spreadRadius: 3,
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(60),
                                              onTap: _isLoading ? null : _authenticateWithBiometrics,
                                              child: Center(
                                                child: _isLoading
                                                    ? const CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                          AppColors.primaryBlue,
                                                        ),
                                                      )
                                                    : const Icon(
                                                        FontAwesomeIcons.fingerprint,
                                                        size: 50,
                                                        color: AppColors.primaryBlue,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          'Touch the sensor to authenticate',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 32),
                                        TextButton.icon(
                                          onPressed: _showPinInputDialog,
                                          icon: const Icon(FontAwesomeIcons.keyboard),
                                          label: const Text('Use PIN instead'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: AppColors.primaryBlue,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              
                              // PIN authentication
                              if (_showPinInput)
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: _pinController,
                                        labelText: 'Enter PIN',
                                        hintText: 'Enter your 4-8 digit PIN',
                                        obscureText: _obscurePin,
                                        keyboardType: TextInputType.number,
                                        prefixIcon: FontAwesomeIcons.lock,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePin
                                                ? FontAwesomeIcons.eyeSlash
                                                : FontAwesomeIcons.eye,
                                            size: 16,
                                          ),
                                          onPressed: _togglePinVisibility,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your PIN';
                                          }
                                          if (value.length < 4 || value.length > 8) {
                                            return 'PIN must be 4-8 digits';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (_) => _authenticateWithPin(),
                                      ),
                                      const SizedBox(height: 24),
                                      CustomButton(
                                        text: 'Authenticate',
                                        onPressed: _isLoading ? null : _authenticateWithPin,
                                        isLoading: _isLoading,
                                        width: double.infinity,
                                      ),
                                      const SizedBox(height: 16),
                                      Consumer<AuthService>(
                                        builder: (context, authService, child) {
                                          if (authService.isBiometricAvailable) {
                                            return TextButton.icon(
                                              onPressed: () {
                                                setState(() {
                                                  _showPinInput = false;
                                                  _errorMessage = '';
                                                  _pinController.clear();
                                                });
                                              },
                                              icon: const Icon(FontAwesomeIcons.fingerprint),
                                              label: const Text('Use fingerprint instead'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: AppColors.primaryBlue,
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Footer
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    'Smart Bag Controller v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight,
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