import 'package:flutter/material.dart';

import '../models/trip.dart';
import 'payment_screen.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({
    super.key,
    required this.trip,
    required this.date,
    required this.seats,
    required this.travelReason,
  });

  final Trip trip;
  final DateTime date;
  final List<int> seats;
  final String travelReason;

  @override
  Widget build(BuildContext context) {
    final total = trip.price * seats.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Booking summary')),
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
                    '${trip.from} → ${trip.to}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 16),
                  _row('Trip', trip.id),
                  _row('Time', '${trip.departure} - ${trip.arrival}'),
                  _row('Date', '${date.day}/${date.month}/${date.year}'),
                  _row('Reason', travelReason),
                  _row('Seats', seats.join(', ')),
                  _row('Bus', trip.busType),
                  _row('Rating', '${trip.rating.toStringAsFixed(1)} ★'),
                  const Divider(height: 28),
                  _row('Total', '${total.toStringAsFixed(0)} EGP', bold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PaymentScreen(
                  trip: trip,
                  date: date,
                  seats: seats,
                  total: total,
                  travelReason: travelReason,
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
          Expanded(
            child: Text(a, style: const TextStyle(color: Color(0xFF64748B))),
          ),
          Text(
            b,
            style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
