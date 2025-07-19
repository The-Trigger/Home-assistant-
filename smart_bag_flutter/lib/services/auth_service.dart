import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'storage_service.dart';

class AuthService extends ChangeNotifier {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final StorageService _storage = StorageService();
  
  bool _isAuthenticated = false;
  bool _isAdminAuthenticated = false;
  bool _isBiometricSupported = false;
  bool _isBiometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];
  
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdminAuthenticated => _isAdminAuthenticated;
  bool get isBiometricSupported => _isBiometricSupported;
  bool get isBiometricAvailable => _isBiometricAvailable;
  List<BiometricType> get availableBiometrics => _availableBiometrics;

  AuthService() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      _isBiometricSupported = await _localAuth.isDeviceSupported();
      _isBiometricAvailable = await _localAuth.canCheckBiometrics;
      _availableBiometrics = await _localAuth.getAvailableBiometrics();
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking biometric support: $e');
      _isBiometricSupported = false;
      _isBiometricAvailable = false;
      _availableBiometrics = [];
      notifyListeners();
    }
  }

  Future<AuthResult> authenticateWithBiometrics() async {
    if (!_isBiometricSupported || !_isBiometricAvailable) {
      return AuthResult(
        success: false,
        message: 'Biometric authentication is not available on this device',
        errorType: AuthErrorType.notAvailable,
      );
    }

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your Smart Bag',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        _isAuthenticated = true;
        await _storage.setLastAuthTime(DateTime.now());
        notifyListeners();
        return AuthResult(
          success: true,
          message: 'Authentication successful',
        );
      } else {
        return AuthResult(
          success: false,
          message: 'Authentication failed',
          errorType: AuthErrorType.userCanceled,
        );
      }
    } on PlatformException catch (e) {
      debugPrint('Platform exception during authentication: $e');
      
      AuthErrorType errorType;
      String message;
      
      switch (e.code) {
        case 'NotAvailable':
          errorType = AuthErrorType.notAvailable;
          message = 'Biometric authentication is not available';
          break;
        case 'NotEnrolled':
          errorType = AuthErrorType.notEnrolled;
          message = 'No biometrics enrolled on this device';
          break;
        case 'LockedOut':
          errorType = AuthErrorType.lockedOut;
          message = 'Too many failed attempts. Please try again later';
          break;
        case 'PermanentlyLockedOut':
          errorType = AuthErrorType.permanentlyLockedOut;
          message = 'Biometric authentication is permanently locked';
          break;
        default:
          errorType = AuthErrorType.unknown;
          message = 'Authentication error: ${e.message}';
      }
      
      return AuthResult(
        success: false,
        message: message,
        errorType: errorType,
      );
    } catch (e) {
      debugPrint('Unexpected error during authentication: $e');
      return AuthResult(
        success: false,
        message: 'An unexpected error occurred',
        errorType: AuthErrorType.unknown,
      );
    }
  }

  Future<AuthResult> authenticateWithPin(String pin) async {
    try {
      final storedPin = await _storage.getAdminPin();
      
      if (storedPin == null) {
        return AuthResult(
          success: false,
          message: 'No admin PIN has been set',
          errorType: AuthErrorType.noPin,
        );
      }
      
      if (pin == storedPin) {
        _isAdminAuthenticated = true;
        await _storage.setLastAdminAuthTime(DateTime.now());
        notifyListeners();
        return AuthResult(
          success: true,
          message: 'Admin authentication successful',
        );
      } else {
        // Increment failed attempts
        final failedAttempts = await _storage.incrementFailedPinAttempts();
        
        if (failedAttempts >= 5) {
          await _storage.setPinLockoutTime(DateTime.now());
          return AuthResult(
            success: false,
            message: 'Too many failed attempts. PIN locked for 30 minutes',
            errorType: AuthErrorType.lockedOut,
          );
        }
        
        return AuthResult(
          success: false,
          message: 'Incorrect PIN. ${5 - failedAttempts} attempts remaining',
          errorType: AuthErrorType.incorrectPin,
        );
      }
    } catch (e) {
      debugPrint('Error during PIN authentication: $e');
      return AuthResult(
        success: false,
        message: 'An error occurred during PIN authentication',
        errorType: AuthErrorType.unknown,
      );
    }
  }

  Future<bool> setAdminPin(String newPin) async {
    try {
      if (newPin.length < 4 || newPin.length > 8) {
        return false;
      }
      
      await _storage.setAdminPin(newPin);
      await _storage.resetFailedPinAttempts();
      return true;
    } catch (e) {
      debugPrint('Error setting admin PIN: $e');
      return false;
    }
  }

  Future<bool> changeAdminPin(String currentPin, String newPin) async {
    try {
      final authResult = await authenticateWithPin(currentPin);
      if (!authResult.success) {
        return false;
      }
      
      return await setAdminPin(newPin);
    } catch (e) {
      debugPrint('Error changing admin PIN: $e');
      return false;
    }
  }

  Future<bool> isPinLocked() async {
    try {
      final lockoutTime = await _storage.getPinLockoutTime();
      if (lockoutTime == null) return false;
      
      final now = DateTime.now();
      final lockoutDuration = now.difference(lockoutTime);
      
      if (lockoutDuration.inMinutes >= 30) {
        await _storage.clearPinLockoutTime();
        await _storage.resetFailedPinAttempts();
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('Error checking PIN lock status: $e');
      return false;
    }
  }

  Future<Duration?> getRemainingLockoutTime() async {
    try {
      final lockoutTime = await _storage.getPinLockoutTime();
      if (lockoutTime == null) return null;
      
      final now = DateTime.now();
      final elapsed = now.difference(lockoutTime);
      final remaining = const Duration(minutes: 30) - elapsed;
      
      return remaining.isNegative ? null : remaining;
    } catch (e) {
      debugPrint('Error getting remaining lockout time: $e');
      return null;
    }
  }

  Future<bool> hasAdminPin() async {
    try {
      final pin = await _storage.getAdminPin();
      return pin != null && pin.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking if admin PIN exists: $e');
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _isAdminAuthenticated = false;
    notifyListeners();
  }

  void logoutAdmin() {
    _isAdminAuthenticated = false;
    notifyListeners();
  }

  Future<bool> isSessionValid() async {
    try {
      final lastAuth = await _storage.getLastAuthTime();
      if (lastAuth == null) return false;
      
      final now = DateTime.now();
      final sessionDuration = now.difference(lastAuth);
      
      // Session expires after 30 minutes
      return sessionDuration.inMinutes < 30;
    } catch (e) {
      debugPrint('Error checking session validity: $e');
      return false;
    }
  }

  Future<bool> isAdminSessionValid() async {
    try {
      final lastAuth = await _storage.getLastAdminAuthTime();
      if (lastAuth == null) return false;
      
      final now = DateTime.now();
      final sessionDuration = now.difference(lastAuth);
      
      // Admin session expires after 15 minutes
      return sessionDuration.inMinutes < 15;
    } catch (e) {
      debugPrint('Error checking admin session validity: $e');
      return false;
    }
  }

  Future<void> checkSessionValidity() async {
    if (_isAuthenticated && !await isSessionValid()) {
      logout();
    }
    
    if (_isAdminAuthenticated && !await isAdminSessionValid()) {
      logoutAdmin();
    }
  }
}

class AuthResult {
  final bool success;
  final String message;
  final AuthErrorType? errorType;

  AuthResult({
    required this.success,
    required this.message,
    this.errorType,
  });
}

enum AuthErrorType {
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
  userCanceled,
  incorrectPin,
  noPin,
  unknown,
}