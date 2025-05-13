import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/vehicle_service.dart';
import 'package:uber_taxi/models/vehicle_model.dart';

class DeleteVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;

  const DeleteVehicleScreen({Key? key, required this.vehicle})
    : super(key: key);

  @override
  _DeleteVehicleScreenState createState() => _DeleteVehicleScreenState();
}

class _DeleteVehicleScreenState extends State<DeleteVehicleScreen> {
  final _vehicleService = VehicleService();
  bool _isLoading = false;

  Future<void> _deleteVehicle() async {
    setState(() => _isLoading = true);

    try {
      await _vehicleService.deleteVehicle(widget.vehicle.id);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete vehicle: ${e.toString()}')),
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
    return AlertDialog(
      title: const Text('Delete Vehicle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete this vehicle?'),
          const SizedBox(height: 16),
          Text(
            '${widget.vehicle.model} (${widget.vehicle.year})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            '${widget.vehicle.color} • ${widget.vehicle.type}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            widget.vehicle.vehicleNumber,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _deleteVehicle,
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child:
              _isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Delete'),
        ),
      ],
    );
  }
}
