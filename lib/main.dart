import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/auth_api_service.dart' show ApiService;
import 'package:uber_taxi/screens/Customer_screens/customer_screen.dart'
    show CustomerHomeScreen;
import 'package:uber_taxi/screens/Driver_screens/driver_screen.dart'
    show DriverHomeScreen;
import 'package:uber_taxi/screens/auth_screens/login_screen.dart'
    show LoginScreen;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uber Taxi',
      theme: ThemeData(
        primaryColor: Color(0xFF80CBC4),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            0xFF80CBC4, // Base color for swatch
            {
              50: Color(0xFF80CBC4).withOpacity(0.1),
              100: Color(0xFF80CBC4).withOpacity(0.2),
              200: Color(0xFF80CBC4).withOpacity(0.3),
              300: Color(0xFF80CBC4).withOpacity(0.4),
              400: Color(0xFF80CBC4).withOpacity(0.5),
              500: Color(0xFF80CBC4).withOpacity(0.6),
              600: Color(0xFF80CBC4).withOpacity(0.7),
              700: Color(0xFF80CBC4).withOpacity(0.8),
              800: Color(0xFF80CBC4).withOpacity(0.9),
              900: Color(0xFF80CBC4).withOpacity(1.0),
            },
          ),
        ).copyWith(secondary: Color(0xFF26A69A)),
      ),

      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    final isAuthenticated = await ApiService.isAuthenticated();

    if (!mounted) return;

    if (!isAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }

    final role = await ApiService.getUserRole();
    if (!mounted) return;

    if (role == 'driver') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF80CBC4),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF80CBC4), Color(0xFF26A69A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2), // Light overlay color
                  ),
                  child: const Icon(
                    Icons.local_taxi_outlined,
                    size: 80,
                    color: Colors.white, // Icon color stays white for contrast
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Uber Taxi',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your ride, your way',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 50),
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
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
