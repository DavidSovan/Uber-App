class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Map<String, String> getHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  //duration for timeout in seconds
  static const int timeoutDuration = 30;

  // Authentication endpoints
  static const String login = '$baseUrl/auth/sign-in';
  static const String signup = '$baseUrl/auth/sign-up';
  static const String logout = '$baseUrl/auth/sign-out';
  static const String forgotpassword = '$baseUrl/auth/forgot-password';
  static const String updateProfile = '$baseUrl/users/profile';

  // Vehicle endpoints
  static const String getvehicles = '$baseUrl/vehicles';
  static const String addVehicle = '$baseUrl/vehicles';
  static const String updateVehicle = '$baseUrl/vehicles/{id}';
  static const String deleteVehicle = '$baseUrl/vehicles/{id}';

  // Booking endpoints customer
  static const String createbooking = '/booking';
  static const String cancelbooking = '$baseUrl/customer/cancel';
  static const String getBooking = '$baseUrl/booking/current';
  //full booking url
  static String getBookingUrl() => baseUrl + createbooking;
  // Booking endpoints driver
  static const String viewAllBookings = '$baseUrl/driver/bookings';
  static const String acceptBooking = '$baseUrl/driver/accept';
  static const String completeTrip = '$baseUrl/driver/complete';

  // Rating endpoints
  static const String submitRating = '$baseUrl/ratings';
}
