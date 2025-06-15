import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/vehicle_service.dart';
import 'package:uber_taxi/models/vehicle_model.dart';

class UpdateVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;

  const UpdateVehicleScreen({Key? key, required this.vehicle})
    : super(key: key);

  @override
  _UpdateVehicleScreenState createState() => _UpdateVehicleScreenState();
}

class _UpdateVehicleScreenState extends State<UpdateVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleService = VehicleService();

  final _vehicleNumberController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _yearController = TextEditingController();
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current vehicle data
    _vehicleNumberController.text = widget.vehicle.vehicleNumber;
    _modelController.text = widget.vehicle.model;
    _colorController.text = widget.vehicle.color;
    _yearController.text = widget.vehicle.year.toString();
    _selectedType = widget.vehicle.type;
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedVehicle = Vehicle(
        id: widget.vehicle.id,
        driverId: widget.vehicle.driverId,
        vehicleNumber: _vehicleNumberController.text,
        model: _modelController.text,
        color: _colorController.text,
        year: int.parse(_yearController.text),
        type: _selectedType,
        licensePlate: _vehicleNumberController.text,
        createdAt: widget.vehicle.createdAt,
        updatedAt: DateTime.now(),
      );

      await _vehicleService.updateVehicle(updatedVehicle);
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update vehicle: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Update Vehicle'),
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
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Update Vehicle Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildInputField(
                      controller: _vehicleNumberController,
                      label: 'Vehicle Number',
                      hint: 'Enter vehicle registration number',
                      icon: Icons.directions_car,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _modelController,
                      label: 'Model',
                      hint: 'Enter vehicle model',
                      icon: Icons.car_repair,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _colorController,
                      label: 'Color',
                      hint: 'Enter vehicle color',
                      icon: Icons.color_lens,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _yearController,
                      label: 'Year',
                      hint: 'Enter vehicle year',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty == true) return 'Please enter year';
                        final year = int.tryParse(value!);
                        if (year == null) return 'Please enter a valid year';
                        if (year < 1900 || year > 2100) {
                          return 'Please enter a valid year';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26A69A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'UPDATE VEHICLE',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: keyboardType,
      validator:
          validator ??
          (value) => value?.isEmpty == true ? 'This field is required' : null,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: 'Vehicle Type',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items:
          _vehicleTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
      onChanged: (value) {
        setState(() => _selectedType = value!);
      },
    );
  }
}
