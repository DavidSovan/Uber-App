import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_taxi/Api/api_config.dart';
import 'package:uber_taxi/models/booking_model.dart';
import 'package:uber_taxi/models/api_response.dart';

class BookingService {
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

  // Create a booking
  Future<ApiResponse<Booking>> createBooking(Booking booking) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login first.');
    }

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.getBookingUrl()),
            headers: ApiConfig.getHeaders(token),
            body: booking.toJsonString(),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return ApiResponse<Booking>(
          status: responseBody['status']?.toString() ?? 'unknown',
          message: responseBody['message']?.toString() ?? '',
          statusCode:
              responseBody['status_code'] is int
                  ? responseBody['status_code']
                  : int.tryParse(
                        responseBody['status_code']?.toString() ?? '',
                      ) ??
                      response.statusCode,
          data:
              responseBody['data'] != null
                  ? Booking.fromJson(responseBody['data'])
                  : null,
        );
      } else {
        throw Exception(
          'Failed to create booking: ${responseBody['message'] ?? 'Unknown error'}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Cancel a booking
  Future<ApiResponse<Booking>> cancelBooking(String bookingId) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login first.');
    }

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.cancelbooking),
            headers: ApiConfig.getHeaders(token),
            body: jsonEncode({'id': bookingId}),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return ApiResponse<Booking>(
          status: responseBody['status']?.toString() ?? 'unknown',
          message: responseBody['message']?.toString() ?? '',
          statusCode:
              responseBody['status_code'] is int
                  ? responseBody['status_code']
                  : int.tryParse(
                        responseBody['status_code']?.toString() ?? '',
                      ) ??
                      response.statusCode,
          data:
              responseBody['data'] != null
                  ? Booking.fromJson(responseBody['data'])
                  : null,
        );
      } else {
        throw Exception(
          'Failed to cancel booking: ${responseBody['message'] ?? 'Unknown error'}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get all booking for customer
  Future<ApiResponse<List<Booking>>> getAllBookings() async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login first.');
    }

    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.getBooking),
            headers: ApiConfig.getHeaders(token),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        List<Booking> bookings = [];

        var data = responseBody['data'];
        if (data is Map<String, dynamic>) {
          bookings.add(Booking.fromJson(data));
        } else if (data is List) {
          bookings = data.map((item) => Booking.fromJson(item)).toList();
        }

        return ApiResponse<List<Booking>>(
          status: responseBody['status']?.toString() ?? 'unknown',
          message: responseBody['message']?.toString() ?? '',
          statusCode: responseBody['status_code'] ?? response.statusCode,
          data: bookings,
        );
      } else {
        throw Exception(
          'Failed to fetch bookings: ${responseBody['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // View bookings for driver
  Future<ApiResponse<List<Booking>>> viewDriverBookings() async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login first.');
    }

    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.viewAllBookings),
            headers: ApiConfig.getHeaders(token),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        List<Booking> bookings = [];

        if (responseBody['data'] is List) {
          bookings =
              (responseBody['data'] as List)
                  .map((item) => Booking.fromJson(item))
                  .toList();
        }

        return ApiResponse<List<Booking>>(
          status: responseBody['status']?.toString() ?? 'unknown',
          message: responseBody['message']?.toString() ?? '',
          statusCode: responseBody['code'] ?? response.statusCode,
          data: bookings,
        );
      } else {
        throw Exception(
          'Failed to fetch driver bookings: ${responseBody['message'] ?? 'Unknown error'}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Driver accept booking
  Future<ApiResponse<Booking>> acceptBooking(String bookingId) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login first.');
    }

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.acceptBooking),
            headers: ApiConfig.getHeaders(token),
            body: jsonEncode({'id': bookingId}),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return ApiResponse<Booking>(
          status: responseBody['status']?.toString() ?? 'unknown',
          message: responseBody['message']?.toString() ?? '',
          statusCode:
              responseBody['status_code'] is int
                  ? responseBody['status_code']
                  : int.tryParse(
                        responseBody['status_code']?.toString() ?? '',
                      ) ??
                      response.statusCode,
          data:
              responseBody['data'] != null
                  ? Booking.fromJson(responseBody['data'])
                  : null,
        );
      } else {
        throw Exception(
          'Failed to accept booking: ${responseBody['message'] ?? 'Unknown error'}',
        );
      }
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Complete trip
  Future<ApiResponse<void>> completeTrip(String bookingId) async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login first.');
    }

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.completeTrip),
            headers: ApiConfig.getHeaders(token),
            body: jsonEncode({'id': bookingId}),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutDuration));

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return ApiResponse<void>(
          status: responseBody['status']?.toString() ?? 'unknown',
          message: responseBody['message']?.toString() ?? '',
          statusCode: responseBody['code'] ?? response.statusCode,
        );
      } else {
        throw Exception(
          'Failed to complete trip: ${responseBody['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
