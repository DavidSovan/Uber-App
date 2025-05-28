import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uber_taxi/models/driver.dart';
import 'package:uber_taxi/Api/api_config.dart';

class ApiService {
  Future<List<Driver>> fetchDrivers() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getdrivers));

      if (response.statusCode == 200) {
        print('API Response for drivers: ${response.body}');
        
        // Parse the JSON response
        final jsonData = json.decode(response.body);
        print('Decoded JSON type: ${jsonData.runtimeType}');
        
        // Check if the response is a List
        if (jsonData is List) {
          // Create a list to hold valid driver objects
          List<Driver> drivers = [];
          
          // Process each driver object individually to handle errors
          for (int i = 0; i < jsonData.length; i++) {
            try {
              print('Processing Driver $i: ${jsonData[i]}');
              final driver = Driver.fromJson(jsonData[i] as Map<String, dynamic>);
              drivers.add(driver);
            } catch (e) {
              // Log the error but continue processing other drivers
              print('Error processing driver $i: $e');
            }
          }
          
          return drivers;
        } else {
          // Handle case where response is not a list
          print('API response is not a list: $jsonData');
          throw Exception('Failed to load drivers: API response format is not as expected');
        }
      } else {
        throw Exception(
          'Failed to load drivers: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in fetchDrivers: $e');
      throw Exception('Failed to load drivers: $e');
    }
  }

  Future<DriverRating> fetchDriverRatings(int driverId) async {
    final response = await http.get(
      Uri.parse(ApiConfig.getDriverRatings(driverId.toString())),
    );

    if (response.statusCode == 200) {
      print('API Response for driver ratings: ${response.body}'); // Add logging
      final jsonData = json.decode(response.body);
      return DriverRating.fromJson(jsonData);
    } else {
      throw Exception('Failed to load driver details: ${response.statusCode}');
    }
  }
}
