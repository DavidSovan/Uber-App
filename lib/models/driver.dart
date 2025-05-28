import 'package:uber_taxi/models/rating.dart';
import 'package:uber_taxi/models/vehicle_model.dart';

class Driver {
  final int id; // Keep as non-nullable
  final String name;
  final String email;
  final String phoneNumber;
  final double? averageRating; // Make nullable
  final int? ratingsCount; // Make nullable
  final List<String>? feedbacks;
  final List<Vehicle> vehicles;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.averageRating, // Remove required
    this.ratingsCount, // Remove required
    required this.feedbacks,
    required this.vehicles,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    // Print the raw JSON for debugging
    print('Raw driver JSON: $json');
    
    // Safely extract id with a default value of 0
    int id = 0;
    try {
      final idValue = json['id'];
      if (idValue != null) {
        if (idValue is int) {
          id = idValue;
        } else if (idValue is String) {
          id = int.tryParse(idValue) ?? 0;
        }
      }
    } catch (e) {
      print('Error parsing id: $e');
    }
    
    // Safely extract string values with empty string defaults
    String name = '';
    try {
      name = json['name']?.toString() ?? '';
    } catch (e) {
      print('Error parsing name: $e');
    }
    
    String email = '';
    try {
      email = json['email']?.toString() ?? '';
    } catch (e) {
      print('Error parsing email: $e');
    }
    
    String phoneNumber = '';
    try {
      phoneNumber = json['phone_number']?.toString() ?? '';
    } catch (e) {
      print('Error parsing phone_number: $e');
    }
    
    // Safely extract average rating
    double? averageRating;
    try {
      final ratingValue = json['average_rating'];
      if (ratingValue != null) {
        if (ratingValue is num) {
          averageRating = ratingValue.toDouble();
        } else if (ratingValue is String) {
          averageRating = double.tryParse(ratingValue);
        }
      }
    } catch (e) {
      print('Error parsing average_rating: $e');
    }
    
    // Safely extract ratings count
    int? ratingsCount;
    try {
      final countValue = json['ratings_count'];
      if (countValue != null) {
        if (countValue is int) {
          ratingsCount = countValue;
        } else if (countValue is String) {
          ratingsCount = int.tryParse(countValue);
        }
      }
    } catch (e) {
      print('Error parsing ratings_count: $e');
    }
    
    // Safely extract feedbacks list
    List<String> feedbacks = [];
    try {
      final feedbacksList = json['feedbacks'];
      if (feedbacksList != null && feedbacksList is List) {
        feedbacks = feedbacksList.map((item) => item?.toString() ?? '').toList();
      }
    } catch (e) {
      print('Error parsing feedbacks: $e');
    }
    
    // Safely extract vehicles list
    List<Vehicle> vehicles = [];
    try {
      final vehiclesList = json['vehicles'];
      if (vehiclesList != null && vehiclesList is List) {
        vehicles = vehiclesList.map((item) {
          if (item is Map<String, dynamic>) {
            return Vehicle.fromJson(item);
          } else {
            return Vehicle.empty(); // Assuming you have an empty constructor or similar
          }
        }).toList();
      }
    } catch (e) {
      print('Error parsing vehicles: $e');
    }
    
    return Driver(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      feedbacks: feedbacks,
      vehicles: vehicles,
    );
  }
}

// ... (DriverDetail class, apply similar nullability if needed for its fields)
class DriverRating {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final double? averageRating; // Make nullable
  final int? totalRatings; // Make nullable
  final List<Rating> ratings;
  final List<Vehicle> vehicles;

  DriverRating({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.averageRating,
    this.totalRatings,
    required this.ratings,
    required this.vehicles,
  });

  factory DriverRating.fromJson(Map<String, dynamic> json) {
    // Check if we need to access 'driver' key first or if we already have the driver object
    final Map<String, dynamic> driverJson = json.containsKey('driver') 
        ? json['driver'] as Map<String, dynamic>
        : json;

    var ratingsList = driverJson['ratings'] as List?;
    List<Rating> parsedRatings =
        ratingsList?.map((i) => Rating.fromJson(i)).toList() ?? [];

    var vehiclesList = driverJson['vehicles'] as List?;
    List<Vehicle> parsedVehicles =
        vehiclesList?.map((i) => Vehicle.fromJson(i)).toList() ?? [];

    return DriverRating(
      id: driverJson['id'] as int,
      name: driverJson['name'] as String,
      email: driverJson['email'] as String,
      phoneNumber: driverJson['phone_number'] as String,
      averageRating: (driverJson['average_rating'] as num?)?.toDouble(),
      totalRatings: driverJson['total_ratings'] as int?,
      ratings: parsedRatings,
      vehicles: parsedVehicles,
    );
  }
}
