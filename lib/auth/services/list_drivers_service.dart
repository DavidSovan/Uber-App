import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uber_taxi/models/driver.dart';
import 'package:uber_taxi/Api/api_config.dart';

class ApiService {
  Future<List<Driver>> fetchDrivers() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getdrivers));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          List<Driver> drivers = [];
          for (int i = 0; i < jsonData.length; i++) {
            try {
              final driver = Driver.fromJson(
                jsonData[i] as Map<String, dynamic>,
              );
              drivers.add(driver);
            } catch (e) {
              continue;
            }
          }
          return drivers;
        } else {
          throw Exception(
            'Failed to load drivers: API response format is not as expected',
          );
        }
      } else {
        throw Exception('Failed to load drivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load drivers: $e');
    }
  }

  Future<DriverRating> fetchDriverRatings(int driverId) async {
    final response = await http.get(
      Uri.parse(ApiConfig.getDriverRatings(driverId.toString())),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DriverRating.fromJson(jsonData);
    } else {
      throw Exception('Failed to load driver details: ${response.statusCode}');
    }
  }
}
