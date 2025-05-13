import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/booking_service.dart';
import 'package:uber_taxi/models/booking_model.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingService _apiService = BookingService();
  bool _isLoading = false;
  String? _errorMessage;
  Booking? _createdBooking;
  String _selectedBookingType = 'UberX';

  final List<String> _bookingTypes = [
    'UberX',
    'UberPremium',
    'UberXL',
    'UberSUV',
    'UberWav',
  ];

  final Map<String, double> _bookingPrices = {
    'UberX': 15.0,
    'UberPremium': 25.0,
    'UberXL': 20.0,
    'UberSUV': 30.0,
    'UberWav': 18.0,
  };

  final Map<String, String> _bookingDescriptions = {
    'UberX': 'Affordable, everyday rides',
    'UberPremium': 'Luxury vehicles with professional drivers',
    'UberXL': 'Spacious rides for groups up to 6',
    'UberSUV': 'Luxury SUVs with extra space',
    'UberWav': 'Wheelchair accessible vehicles',
  };

  Future<void> _createBooking() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final booking = Booking(bookingType: _selectedBookingType);
      final response = await _apiService.createBooking(booking);

      setState(() {
        _createdBooking = response.data;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Book a Ride'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Your Ride',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ..._bookingTypes.map((type) => _buildRideTypeCard(type)).toList(),
            SizedBox(height: 20),
            if (_createdBooking != null) _buildBookingDetailsCard(),
            SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _createBooking,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                ),
                icon:
                    _isLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Icon(Icons.local_taxi),
                label: Text(
                  _isLoading ? 'Processing...' : 'Book Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideTypeCard(String type) {
    bool isSelected = _selectedBookingType == type;
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedBookingType = type),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                _getIconForType(type),
                size: 32,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _bookingDescriptions[type]!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${_bookingPrices[type]!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'UberX':
        return Icons.directions_car;
      case 'UberPremium':
        return Icons.stars;
      case 'UberXL':
        return Icons.airport_shuttle;
      case 'UberSUV':
        return Icons.directions_car;
      case 'UberWav':
        return Icons.accessible;
      default:
        return Icons.local_taxi;
    }
  }

  Widget _buildBookingDetailsCard() {
    final price = _bookingPrices[_createdBooking!.bookingType] ?? 0.0;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Booking Created Successfully',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(height: 24),
            _buildDetailRow('Booking ID', '${_createdBooking!.id}'),
            _buildDetailRow('Type', _createdBooking!.bookingType),
            _buildDetailRow('Status', _createdBooking!.status ?? 'N/A'),
            _buildDetailRow('Price', '\$${price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
