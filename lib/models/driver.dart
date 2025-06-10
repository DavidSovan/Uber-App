import 'package:uber_taxi/models/rating.dart';
import 'package:uber_taxi/models/vehicle_model.dart';

class Driver {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final double? averageRating;
  final int? ratingsCount;
  final List<String>? feedbacks;
  final List<Vehicle> vehicles;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.averageRating,
    this.ratingsCount,
    required this.feedbacks,
    required this.vehicles,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    // Safely extract id with a default value of 0
    int id = 0;
    final idValue = json['id'];
    if (idValue != null) {
      if (idValue is int) {
        id = idValue;
      } else if (idValue is String) {
        id = int.tryParse(idValue) ?? 0;
      }
    }

    // Safely extract string values with empty string defaults
    final name = json['name']?.toString() ?? '';
    final email = json['email']?.toString() ?? '';
    final phoneNumber = json['phone_number']?.toString() ?? '';

    // Safely extract average rating
    double? averageRating;
    final ratingValue = json['average_rating'];
    if (ratingValue != null) {
      if (ratingValue is num) {
        averageRating = ratingValue.toDouble();
      } else if (ratingValue is String) {
        averageRating = double.tryParse(ratingValue);
      }
    }

    // Safely extract ratings count
    int? ratingsCount;
    final countValue = json['ratings_count'];
    if (countValue != null) {
      if (countValue is int) {
        ratingsCount = countValue;
      } else if (countValue is String) {
        ratingsCount = int.tryParse(countValue);
      }
    }

    // Safely extract feedbacks list
    List<String> feedbacks = [];
    final feedbacksList = json['feedbacks'];
    if (feedbacksList != null && feedbacksList is List) {
      feedbacks = feedbacksList.map((item) => item?.toString() ?? '').toList();
    }

    // Safely extract vehicles list
    List<Vehicle> vehicles = [];
    final vehiclesList = json['vehicles'];
    if (vehiclesList != null && vehiclesList is List) {
      vehicles =
          vehiclesList.map((item) {
            if (item is Map<String, dynamic>) {
              return Vehicle.fromJson(item);
            } else {
              return Vehicle.empty(); // Assuming you have an empty constructor
            }
          }).toList();
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

class DriverRating {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final double? averageRating;
  final int? totalRatings;
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
    final Map<String, dynamic> driverJson =
        json.containsKey('driver')
            ? json['driver'] as Map<String, dynamic>
            : json;

    // Safely extract id
    int id = 0;
    final idValue = driverJson['id'];
    if (idValue is int) {
      id = idValue;
    } else if (idValue is String) {
      id = int.tryParse(idValue) ?? 0;
    }

    // Safely extract string values
    final name = driverJson['name']?.toString() ?? '';
    final email = driverJson['email']?.toString() ?? '';
    final phoneNumber = driverJson['phone_number']?.toString() ?? '';

    // Safely extract average rating
    double? averageRating;
    final ratingValue = driverJson['average_rating'];
    if (ratingValue is num) {
      averageRating = ratingValue.toDouble();
    } else if (ratingValue is String) {
      averageRating = double.tryParse(ratingValue);
    }

    // Safely extract total ratings
    int? totalRatings;
    final totalValue = driverJson['total_ratings'];
    if (totalValue is int) {
      totalRatings = totalValue;
    } else if (totalValue is String) {
      totalRatings = int.tryParse(totalValue);
    }

    // Safely extract ratings list
    final ratingsList = driverJson['ratings'] as List?;
    List<Rating> parsedRatings =
        ratingsList?.map((i) => Rating.fromJson(i)).toList() ?? [];

    // Safely extract vehicles list
    final vehiclesList = driverJson['vehicles'] as List?;
    List<Vehicle> parsedVehicles =
        vehiclesList?.map((i) => Vehicle.fromJson(i)).toList() ?? [];

    return DriverRating(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      averageRating: averageRating,
      totalRatings: totalRatings,
      ratings: parsedRatings,
      vehicles: parsedVehicles,
    );
  }
}
