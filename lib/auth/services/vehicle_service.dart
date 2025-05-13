import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_taxi/Api/api_config.dart';
import 'package:uber_taxi/models/vehicle_model.dart';

class VehicleService {
  // Get the auth token from shared preferences
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save the auth token to shared preferences
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get all vehicles
  Future<List<Vehicle>> getAllVehicles() async {
    final token = await getAuthToken();
    final response = await http.get(
      Uri.parse(ApiConfig.getvehicles),
      headers: ApiConfig.getHeaders(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> vehiclesJson = jsonDecode(response.body);
      return vehiclesJson.map((json) => Vehicle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vehicles: ${response.body}');
    }
  }

  // Add a new vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    final token = await getAuthToken();
    final response = await http.post(
      Uri.parse(ApiConfig.addVehicle),
      headers: ApiConfig.getHeaders(token),
      body: jsonEncode({
        'driver_id': vehicle.driverId,
        'vehicle_number': vehicle.vehicleNumber,
        'model': vehicle.model,
        'color': vehicle.color,
        'year': vehicle.year,
        'type': vehicle.type,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add vehicle: ${response.body}');
    }
  }

  // Update an existing vehicle
  Future<void> updateVehicle(Vehicle vehicle) async {
    final token = await getAuthToken();
    final response = await http.put(
      Uri.parse(
        ApiConfig.updateVehicle.replaceFirst('{id}', vehicle.id.toString()),
      ),
      headers: ApiConfig.getHeaders(token),
      body: jsonEncode({
        'vehicle_number': vehicle.vehicleNumber,
        'model': vehicle.model,
        'color': vehicle.color,
        'year': vehicle.year,
        'type': vehicle.type,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update vehicle: ${response.body}');
    }
  }

  // Delete a vehicle
  Future<void> deleteVehicle(int vehicleId) async {
    final token = await getAuthToken();
    final response = await http.delete(
      Uri.parse(
        ApiConfig.deleteVehicle.replaceFirst('{id}', vehicleId.toString()),
      ),
      headers: ApiConfig.getHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete vehicle: ${response.body}');
    }
  }
}
