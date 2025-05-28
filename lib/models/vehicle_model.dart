class Vehicle {
  final int id;
  final int driverId;
  final String vehicleNumber;
  final String model;
  final String color;
  final int year;
  final String type;
  final String? licensePlate;

  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.driverId,
    required this.vehicleNumber,
    required this.model,
    required this.color,
    required this.year,
    required this.type,
    required this.licensePlate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    try {
      return Vehicle(
        id: json['id'] ?? 0,
        driverId: json['driver_id'] ?? 0,
        vehicleNumber: json['vehicle_number']?.toString() ?? '',
        model: json['model']?.toString() ?? '',
        color: json['color']?.toString() ?? '',
        year: json['year'] is String ? int.tryParse(json['year']) ?? 0 : (json['year'] ?? 0),
        type: json['type']?.toString() ?? '',
        licensePlate: json['license_plate']?.toString(),
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing Vehicle: $e');
      return Vehicle.empty();
    }
  }
  
  // Empty constructor for creating default vehicles when data is missing or invalid
  factory Vehicle.empty() {
    return Vehicle(
      id: 0,
      driverId: 0,
      vehicleNumber: '',
      model: 'Unknown',
      color: 'Unknown',
      year: 0,
      type: 'Unknown',
      licensePlate: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
