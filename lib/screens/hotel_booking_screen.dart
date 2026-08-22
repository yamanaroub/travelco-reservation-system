import 'package:flutter/material.dart';

import '../models/hotel.dart';
import 'hotel_payment_screen.dart';

class HotelBookingScreen extends StatelessWidget {
  const HotelBookingScreen({
    super.key,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
  });

  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;

  @override
  Widget build(BuildContext context) {
    final nights = checkOut.difference(checkIn).inDays;
    final total = hotel.pricePerNight * nights * rooms;

    return Scaffold(
      appBar: AppBar(title: const Text('Hotel booking summary')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF59E0B)),
                      Text(' ${hotel.rating.toStringAsFixed(1)} · ${hotel.reviewCount} ratings'),
                    ],
                  ),
                  const Divider(height: 30),
                  _row('City', hotel.city),
                  _row('Check-in', '${checkIn.day}/${checkIn.month}/${checkIn.year}'),
                  _row('Check-out', '${checkOut.day}/${checkOut.month}/${checkOut.year}'),
                  _row('Nights', '$nights'),
                  _row('Guests', '$guests'),
                  _row('Rooms', '$rooms'),
                  _row('Per night', '${hotel.pricePerNight.toStringAsFixed(0)} EGP'),
                  const Divider(height: 30),
                  _row('Total', '${total.toStringAsFixed(0)} EGP', bold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HotelPaymentScreen(
                  hotel: hotel,
                  checkIn: checkIn,
                  checkOut: checkOut,
                  guests: guests,
                  rooms: rooms,
                  total: total,
                ),
              ),
            ),
            child: const Text('Proceed to payment'),
          ),
        ],
      ),
    );
  }

  Widget _row(String a, String b, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(a, style: const TextStyle(color: Color(0xFF64748B)))),
          Text(b, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w700)),
        ],
      ),
    );
  }
}
