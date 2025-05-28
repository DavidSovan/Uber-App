import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/vehicle_service.dart';
import 'package:uber_taxi/models/vehicle_model.dart';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleService = VehicleService();

  final _vehicleNumberController = TextEditingController();
  String _selectedModel = 'Honda';
  String _selectedColor = 'Black';
  String _selectedYear = '2020';
  String _selectedType = 'Sedan';

  final List<String> _vehicleTypes = [
    'Sedan',
    'SUV',
    'Van',
    'Hatchback',
    'Pickup',
    'MVP(Minivan)',
    'Bus',
    'Convertible',
    'Coupe',
    'Wagon',
    'Sport',
    'Luxury',
    'Other',
  ];
  final List<String> _vehicleModels = [
    'Toyota',
    'Honda',
    'Chevrolet',
    'Hyundai',
    'Mazda',
    'Nissan',
    'Ford',
    'Tesla',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Lexus',
    'Jaguar',
    'Porsche',
    'Land Rover',
    'Volvo',
    'other',
  ];
  final List<String> _colors = [
    'Black',
    'White',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Green',
    'Brown',
    'Gold',
    'Navy',
    'other',
  ];
  final List<String> _years = List.generate(
    25,
    (index) => (DateTime.now().year - index).toString(),
  );

  bool _isLoading = false;

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final vehicle = Vehicle(
        id: 0,
        driverId: 0,
        vehicleNumber: _vehicleNumberController.text,
        model: _selectedModel,
        color: _selectedColor,
        year: int.parse(_selectedYear),
        type: _selectedType,
        licensePlate: _vehicleNumberController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _vehicleService.addVehicle(vehicle);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add vehicle: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 8), child: child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Vehicle'),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor.withOpacity(0.05), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Vehicle illustration or icon
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Icon(
                    Icons.directions_car_rounded,
                    size: 80,
                    color: primaryColor.withOpacity(0.7),
                  ),
                ),

                // Section title
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Vehicle Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),

                // Vehicle number field
                _buildFormField(
                  label: 'Vehicle Number',
                  icon: Icons.credit_card,
                  child: TextFormField(
                    controller: _vehicleNumberController,
                    decoration: InputDecoration(
                      hintText: 'Enter registration number',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                    validator:
                        (value) =>
                            value?.isEmpty == true
                                ? 'Please enter vehicle number'
                                : null,
                    textInputAction: TextInputAction.next,
                  ),
                ),

                // Model dropdown
                _buildFormField(
                  label: 'Vehicle Model',
                  icon: Icons.business,
                  child: DropdownButtonFormField<String>(
                    value: _selectedModel,
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                    ),
                    items:
                        _vehicleModels.map((model) {
                          return DropdownMenuItem(
                            value: model,
                            child: Text(model),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedModel = value!);
                    },
                    validator:
                        (value) =>
                            value == null ? 'Please select a model' : null,
                  ),
                ),

                // Color dropdown
                _buildFormField(
                  label: 'Vehicle Color',
                  icon: Icons.color_lens,
                  child: DropdownButtonFormField<String>(
                    value: _selectedColor,
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                    ),
                    items:
                        _colors.map((color) {
                          return DropdownMenuItem(
                            value: color,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: _getColorFromString(color),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                Text(color),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedColor = value!);
                    },
                    validator:
                        (value) =>
                            value == null ? 'Please select a color' : null,
                  ),
                ),

                // Year dropdown
                _buildFormField(
                  label: 'Manufacturing Year',
                  icon: Icons.calendar_today,
                  child: DropdownButtonFormField<String>(
                    value: _selectedYear,
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                    ),
                    items:
                        _years.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedYear = value!);
                    },
                    validator:
                        (value) =>
                            value == null ? 'Please select a year' : null,
                  ),
                ),

                // Vehicle type dropdown
                _buildFormField(
                  label: 'Vehicle Type',
                  icon: Icons.category,
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                    ),
                    items:
                        _vehicleTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedType = value!);
                    },
                    validator:
                        (value) =>
                            value == null
                                ? 'Please select a vehicle type'
                                : null,
                  ),
                ),

                const SizedBox(height: 16),

                // Add vehicle button
                Container(
                  height: 55,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              'Add Vehicle',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'silver':
        return Colors.grey.shade300;
      case 'gray':
        return Colors.grey;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'brown':
        return Colors.brown;
      case 'gold':
        return Colors.amber.shade700;
      case 'navy':
        return Colors.indigo.shade900;
      default:
        return Colors.grey.shade200;
    }
  }
}
