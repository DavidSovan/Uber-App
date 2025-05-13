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

  final List<String> _vehicleTypes = ['Sedan', 'SUV', 'Van', 'Hatchback'];
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
      appBar: AppBar(title: const Text('Update Vehicle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  hintText: 'Enter vehicle registration number',
                ),
                validator:
                    (value) =>
                        value?.isEmpty == true
                            ? 'Please enter vehicle number'
                            : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  hintText: 'Enter vehicle model',
                ),
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Please enter model' : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'Enter vehicle color',
                ),
                validator:
                    (value) =>
                        value?.isEmpty == true ? 'Please enter color' : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  hintText: 'Enter vehicle year',
                ),
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
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Vehicle Type'),
                items:
                    _vehicleTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() => _selectedType = value!);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Update Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
