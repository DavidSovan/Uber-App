import 'dart:convert';

class Booking {
  final int? id;
  final int? driverId;
  final int? customerId;
  final String? vehicle;
  final String bookingType;
  final String? status;
  final double? price;
  final String? currency;
  final String? pickupLocation;
  final String? dropoffLocation;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  var amount;

  Booking({
    this.id,
    this.driverId,
    this.customerId,
    this.vehicle,
    required this.bookingType,
    this.status = 'pending',
    this.price,
    this.currency = 'USD',
    this.pickupLocation,
    this.dropoffLocation,
    this.createdAt,
    this.updatedAt,
  }) : amount = price;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      driverId:
          json['driver_id'] is String
              ? int.parse(json['driver_id'])
              : json['driver_id'],
      customerId:
          json['customer_id'] is String
              ? int.parse(json['customer_id'])
              : json['customer_id'],
      vehicle: json['vehicle']?.toString(),
      bookingType: json['booking_type'] ?? 'standard',
      status: json['status']?.toString() ?? 'pending',
      price:
          json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      currency: json['currency']?.toString() ?? 'USD',
      pickupLocation: json['pickup_location']?.toString(),
      dropoffLocation: json['dropoff_location']?.toString(),
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'].toString())
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'customer_id': customerId,
      'vehicle': vehicle,
      'booking_type': bookingType,
      'status': status,
      'price': price,
      'currency': currency,
      'pickup_location': pickupLocation,
      'dropoff_location': dropoffLocation,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  Booking copyWith({
    int? id,
    int? driverId,
    int? customerId,
    String? vehicle,
    String? bookingType,
    String? status,
    double? price,
    String? currency,
    String? pickupLocation,
    String? dropoffLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      customerId: customerId ?? this.customerId,
      vehicle: vehicle ?? this.vehicle,
      bookingType: bookingType ?? this.bookingType,
      status: status ?? this.status,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
