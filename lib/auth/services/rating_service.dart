import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_taxi/Api/api_config.dart';
import 'package:uber_taxi/models/api_response.dart';

class RatingService {
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<ApiResponse<void>> submitRating({
    required String driverId,
    required int rating,
    required String feedback,
  }) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.submitRating),
            headers: ApiConfig.getHeaders(token),
            body: jsonEncode({
              'driver_id': driverId,
              'rating': rating,
              'feedback': feedback,
            }),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<void>(
          status: responseBody['status']?.toString() ?? 'success',
          message:
              responseBody['message']?.toString() ??
              'Rating submitted successfully',
          statusCode: response.statusCode,
        );
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to submit rating');
      }
    } catch (e) {
      throw Exception('Failed to submit rating: $e');
    }
  }
}
