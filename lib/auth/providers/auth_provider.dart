// import 'package:flutter/material.dart';
// import 'package:uber_taxi/auth/services/auth_api_service.dart'
//     show AuthService, User;

// class AuthProvider extends ChangeNotifier {
//   User? _user;
//   bool _isLoading = false;
//   String? _error;

//   User? get user => _user;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isAuthenticated => _user != null;

//   AuthProvider() {
//     _loadUser();
//   }

//   Future<void> _loadUser() async {
//     _user = await AuthService.getUser();
//     notifyListeners();
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String? error) {
//     _error = error;
//     notifyListeners();
//   }

//   void _setUser(User? user) {
//     _user = user;
//     notifyListeners();
//   }

//   Future<bool> signIn(String email, String password) async {
//     _setLoading(true);
//     _setError(null);

//     try {
//       final response = await AuthService.signIn(email, password);

//       if (response.success && response.data != null) {
//         _setUser(response.data!.user);
//         return true;
//       } else {
//         _setError(response.message);
//         return false;
//       }
//     } catch (e) {
//       _setError('An unexpected error occurred: ${e.toString()}');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<bool> signUp({
//     required String name,
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//     String? phoneNumber,
//     required String userType,
//   }) async {
//     _setLoading(true);
//     _setError(null);

//     try {
//       final response = await AuthService.signUp(
//         name: name,
//         email: email,
//         password: password,
//         passwordConfirmation: passwordConfirmation,
//         phoneNumber: phoneNumber,
//         userType: userType,
//       );

//       if (response.success && response.data != null) {
//         _setUser(response.data!.user);
//         return true;
//       } else {
//         _setError(response.message);
//         return false;
//       }
//     } catch (e) {
//       _setError('An unexpected error occurred: ${e.toString()}');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<bool> signOut() async {
//     _setLoading(true);
//     _setError(null);

//     try {
//       final response = await AuthService.signOut();

//       if (response.success) {
//         _setUser(null);
//         return true;
//       } else {
//         _setError(response.message);
//         return false;
//       }
//     } catch (e) {
//       _setError('An unexpected error occurred: ${e.toString()}');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<bool> forgotPassword(String email) async {
//     _setLoading(true);
//     _setError(null);

//     try {
//       final response = await AuthService.forgotPassword(email);

//       if (response.success) {
//         return true;
//       } else {
//         _setError(response.message);
//         return false;
//       }
//     } catch (e) {
//       _setError('An unexpected error occurred: ${e.toString()}');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<bool> resetPassword({
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//   }) async {
//     _setLoading(true);
//     _setError(null);

//     try {
//       final response = await AuthService.resetPassword(
//         email: email,
//         password: password,
//         passwordConfirmation: passwordConfirmation,
//       );

//       if (response.success) {
//         return true;
//       } else {
//         _setError(response.message);
//         return false;
//       }
//     } catch (e) {
//       _setError('An unexpected error occurred: ${e.toString()}');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }
// }
