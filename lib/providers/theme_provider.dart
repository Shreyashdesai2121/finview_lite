import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Manages light/dark theme and saves user's preference
// Preference persists across app restarts
class ThemeProvider extends ChangeNotifier {
  // Key for storing in SharedPreferences
  static const String _themeKey = 'is_dark_mode';
  
  // Current theme state
  bool _isDarkMode = false;

  // Getter for dark mode status
  bool get isDarkMode => _isDarkMode;
  
  // Convert to ThemeMode enum for MaterialApp
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Load saved preference when provider is created
  ThemeProvider() {
    _loadTheme();
  }

  // Read saved theme preference from device storage
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get saved value, default to light mode if nothing saved
      final savedValue = prefs.getBool(_themeKey);
      _isDarkMode = savedValue ?? false;
      
      // Only notify if we have listeners (not disposed)
      if (hasListeners) {
        notifyListeners();
      }
    } catch (e) {
      // If we can't read it, default to light mode
      // This handles cases where SharedPreferences is unavailable
      _isDarkMode = false;
      // Don't notify on error to avoid issues if provider is disposed
    }
  }

  // Switch between light and dark mode
  // Also saves the preference so it persists
  Future<void> toggleTheme() async {
    try {
      // Flip the boolean
      _isDarkMode = !_isDarkMode;
      
      // Notify listeners first so UI updates immediately
      if (hasListeners) {
        notifyListeners();
      }
      
      // Save to device (this can happen in background)
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_themeKey, _isDarkMode);
      } catch (e) {
        // If saving fails, that's okay - theme still changed for this session
        // We don't want to revert the theme change if storage fails
      }
    } catch (e) {
      // If something goes wrong, try to keep the state consistent
      // Don't revert the change since user already saw it
      if (hasListeners) {
        notifyListeners();
      }
    }
  }
}
