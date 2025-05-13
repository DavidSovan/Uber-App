import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/vehicle_service.dart';
import 'package:uber_taxi/models/vehicle_model.dart';
import 'package:uber_taxi/screens/Driver_screens/add_vehicle_screen.dart';
import 'package:uber_taxi/screens/Driver_screens/update_vehicle_screen.dart';
import 'package:uber_taxi/screens/Driver_screens/delete_vehicle_screen.dart';

class VehicleListScreen extends StatefulWidget {
  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleService _apiService = VehicleService();
  late Future<List<Vehicle>> _vehiclesFuture;

  Future<void> _refreshVehicles() async {
    setState(() {
      _vehiclesFuture = _apiService.getAllVehicles();
    });
  }

  Future<void> _navigateToAddVehicle() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddVehicleScreen()),
    );
    if (result == true) {
      _refreshVehicles();
    }
  }

  Future<void> _navigateToUpdateVehicle(Vehicle vehicle) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateVehicleScreen(vehicle: vehicle),
      ),
    );
    if (result == true) {
      _refreshVehicles();
    }
  }

  Future<void> _showDeleteVehicleDialog(Vehicle vehicle) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteVehicleScreen(vehicle: vehicle),
    );
    if (result == true) {
      _refreshVehicles();
    }
  }

  void _showVehicleDetails(Vehicle vehicle) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${vehicle.model} Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Vehicle Number:', vehicle.vehicleNumber),
                _detailRow('Model:', vehicle.model),
                _detailRow('Type:', vehicle.type),
                _detailRow('Color:', vehicle.color),
                _detailRow('Year:', vehicle.year),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value.toString())),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = _apiService.getAllVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshVehicles,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddVehicle,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshVehicles,
        child: FutureBuilder<List<Vehicle>>(
          future: _vehiclesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load vehicles',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshVehicles,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text('No vehicles found'),
                  ],
                ),
              );
            } else {
              final vehicles = snapshot.data!;
              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text('${vehicle.model} (${vehicle.year})'),
                      subtitle: Text(
                        '${vehicle.color} • ${vehicle.type} • ${vehicle.vehicleNumber}',
                      ),
                      leading: const Icon(Icons.directions_car),
                      onTap: () => _showVehicleDetails(vehicle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => _navigateToUpdateVehicle(vehicle),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () => _showDeleteVehicleDialog(vehicle),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
