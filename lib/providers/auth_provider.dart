import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Manages login state and saves it to device storage
// This way users stay logged in even after closing the app
class AuthProvider extends ChangeNotifier {
  // Internal state - private so it can't be changed directly
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Public getters so other widgets can read the state
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // When provider is created, check if user was already logged in
  AuthProvider() {
    _checkLoginStatus();
  }

  // Check device storage to see if user logged in before
  // This runs on app startup to restore login state
  // For now, we always start logged out to show the login page
  // We also clear any saved login state to ensure clean start
  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Always start logged out - clear any saved login state
      // This ensures the login page is always shown first
      await prefs.setBool('loggedIn', false);
      _isLoggedIn = false;
      
      // Only notify if we're still valid (not disposed)
      if (hasListeners) {
        notifyListeners();
      }
    } catch (e) {
      // If we can't read it, assume not logged in
      // This handles cases where SharedPreferences is unavailable
      _isLoggedIn = false;
      // Don't notify on error to avoid issues if provider is disposed
    }
  }

  // Try to log in with username and password
  // For this demo, any non-empty values work
  // In real app, this would call an API
  Future<bool> login(String email, String password) async {
    try {
      // Show loading state
      _isLoading = true;
      _errorMessage = null;
      if (hasListeners) {
        notifyListeners();
      }

      // Validate input length to prevent issues
      if (email.length > 1000 || password.length > 1000) {
        _errorMessage = 'Email and password are too long';
        _isLoading = false;
        if (hasListeners) {
          notifyListeners();
        }
        return false;
      }

      // Simulate network delay (real API would take time)
      await Future.delayed(const Duration(milliseconds: 500));

      // Basic validation - need both fields filled
      final trimmedEmail = email.trim();
      final trimmedPassword = password.trim();
      
      if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
        _errorMessage = 'Email and password are required';
        _isLoading = false;
        if (hasListeners) {
          notifyListeners();
        }
        return false;
      }

      // Login successful!
      _isLoggedIn = true;
      _isLoading = false;
      _errorMessage = null;

      // Save to device so they stay logged in next time
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', true);
      } catch (e) {
        // If saving fails, that's okay - they're still logged in for this session
        // We don't want to fail the login just because storage failed
      }

      if (hasListeners) {
        notifyListeners();
      }
      return true;
    } catch (e) {
      // Handle any unexpected errors
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred: $e';
      if (hasListeners) {
        notifyListeners();
      }
      return false;
    }
  }

  // Log out and clear saved login state
  Future<void> logout() async {
    try {
      _isLoggedIn = false;
      _errorMessage = null;

      // Clear from device storage
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', false);
      } catch (e) {
        // If clearing fails, continue anyway
        // User is still logged out for this session
      }

      if (hasListeners) {
        notifyListeners();
      }
    } catch (e) {
      // Even if something goes wrong, mark as logged out
      _isLoggedIn = false;
      _errorMessage = null;
      if (hasListeners) {
        notifyListeners();
      }
    }
  }
}
