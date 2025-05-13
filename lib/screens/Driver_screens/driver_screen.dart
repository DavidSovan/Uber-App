import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/auth_api_service.dart' show ApiService;
import 'package:uber_taxi/screens/Driver_screens/vehicleList_screen.dart';
import 'package:uber_taxi/screens/Driver_screens/view_booking_for_driver.dart';
import 'package:uber_taxi/screens/auth_screens/login_screen.dart'
    show LoginScreen;
import 'package:uber_taxi/widgets/feature_card.dart' show FeatureCard;

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await ApiService.getCurrentUser();
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await ApiService.signOut();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.exit_to_app), onPressed: _signOut),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userData == null
              ? const Center(child: Text('Failed to load user data'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${_userData!['name']}!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isOnline ? 'You are ONLINE' : 'You are OFFLINE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isOnline ? Colors.green : Colors.red,
                              ),
                            ),
                            Switch(
                              value: _isOnline,
                              onChanged: (value) => _toggleOnlineStatus(),
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Driver Features:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    FeatureCard(
                      icon: Icons.car_repair,
                      title: 'Manage Vehicles',
                      description: 'Add, update, or remove your vehicles',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleListScreen(),
                          ),
                        );
                      },
                    ),
                    FeatureCard(
                      icon: Icons.car_repair,
                      title: 'View Bookings',
                      description: 'Go to accept customer bookings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewBookingForDriver(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
