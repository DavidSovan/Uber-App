class Vehicle {
  final int id;
  final int driverId;
  final String vehicleNumber;
  final String model;
  final String color;
  final int year;
  final String type;
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      driverId: json['driver_id'],
      vehicleNumber: json['vehicle_number'],
      model: json['model'],
      color: json['color'],
      year: json['year'] is String ? int.parse(json['year']) : json['year'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
