import 'package:flutter/material.dart';
import 'package:uber_taxi/auth/services/booking_service.dart';
import 'package:uber_taxi/models/booking_model.dart';
import 'package:uber_taxi/models/api_response.dart';
import 'package:uber_taxi/screens/Driver_screens/on_trip_screen.dart';

class ViewBookingForDriver extends StatefulWidget {
  const ViewBookingForDriver({super.key});

  @override
  State<ViewBookingForDriver> createState() => _ViewBookingForDriverState();
}

class _ViewBookingForDriverState extends State<ViewBookingForDriver> {
  final BookingService _bookingService = BookingService();
  List<Booking> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      ApiResponse<List<Booking>> response =
          await _bookingService.viewDriverBookings();
      setState(() {
        _bookings = response.data ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Bookings'),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: $_error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadBookings,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadBookings,
                child:
                    _bookings.isEmpty
                        ? const Center(child: Text('No bookings available'))
                        : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _bookings.length,
                          itemBuilder: (context, index) {
                            final booking = _bookings[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              child: ListTile(
                                title: Text(
                                  'Booking ID: ${booking.id?.toString().substring(0, booking.id!.toString().length > 8 ? 8 : booking.id!.toString().length)}${booking.id!.toString().length > 8 ? "..." : ""}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text('Type: ${booking.bookingType}'),
                                    Text(
                                      'Status: ${booking.status}',
                                      style: TextStyle(
                                        color:
                                            booking.status == 'pending'
                                                ? Colors.orange
                                                : Colors.green,
                                      ),
                                    ),

                                    Text(
                                      'Created: ${booking.createdAt.toString().substring(0, 16)}',
                                    ),
                                  ],
                                ),
                                trailing:
                                    booking.status == 'pending'
                                        ? ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              final response =
                                                  await _bookingService
                                                      .acceptBooking(
                                                        booking.id!.toString(),
                                                      );

                                              if (response.data != null) {
                                                if (!mounted) return;

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            OnTripScreen(
                                                              booking:
                                                                  response
                                                                      .data!,
                                                            ),
                                                  ),
                                                );
                                              }

                                              if (!mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Booking accepted successfully',
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                              _loadBookings();
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to accept booking: $e',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Accept'),
                                        )
                                        : null,
                              ),
                            );
                          },
                        ),
              ),
    );
  }
}
