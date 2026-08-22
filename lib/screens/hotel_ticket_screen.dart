import 'package:flutter/material.dart';

import '../models/hotel_booking.dart';
import 'home_screen.dart';

class HotelTicketScreen extends StatelessWidget {
  const HotelTicketScreen({super.key, required this.booking});

  final HotelBooking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel confirmation'), automaticallyImplyLeading: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF19A7A0), size: 64),
                const SizedBox(height: 10),
                const Text(
                  'Hotel booked!',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        const Icon(Icons.hotel, size: 70, color: Color(0xFF7C3AED)),
                        const SizedBox(height: 10),
                        Text(
                          booking.hotel.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        Text(booking.id, style: const TextStyle(fontWeight: FontWeight.w800)),
                        const Divider(height: 30),
                        _line('City', booking.hotel.city),
                        _line(
                          'Check-in',
                          '${booking.checkIn.day}/${booking.checkIn.month}/${booking.checkIn.year}',
                        ),
                        _line(
                          'Check-out',
                          '${booking.checkOut.day}/${booking.checkOut.month}/${booking.checkOut.year}',
                        ),
                        _line('Guests', '${booking.guests}'),
                        _line('Rooms', '${booking.rooms}'),
                        _line('Payment', booking.paymentMethod),
                        _line('Total', '${booking.total.toStringAsFixed(0)} EGP'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false,
                  ),
                  child: const Text('Back to home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _line(String a, String b) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(a, style: const TextStyle(color: Color(0xFF64748B)))),
          Text(b, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
