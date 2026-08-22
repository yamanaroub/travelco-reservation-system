import 'package:flutter/material.dart';

import '../models/trip.dart';
import 'seat_selection_screen.dart';

class TripResultsScreen extends StatelessWidget {
  const TripResultsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
    required this.travelReason,
  });

  final String from;
  final String to;
  final DateTime date;
  final int passengers;
  final String travelReason;

  @override
  Widget build(BuildContext context) {
    final trips = [
      Trip(
        id: 'TR101',
        from: from,
        to: to,
        departure: '08:00',
        arrival: '10:45',
        price: 180,
        busType: 'Comfort',
        rating: 4.8,
        reviewCount: 326,
      ),
      Trip(
        id: 'TR205',
        from: from,
        to: to,
        departure: '12:30',
        arrival: '15:15',
        price: 220,
        busType: 'Premium',
        rating: 4.9,
        reviewCount: 218,
      ),
      Trip(
        id: 'TR312',
        from: from,
        to: to,
        departure: '18:00',
        arrival: '20:50',
        price: 160,
        busType: 'Standard',
        rating: 4.5,
        reviewCount: 174,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Available trips')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: trips.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          if (i == 0) {
            return Card(
              color: const Color(0xFFEFF6FF),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.travel_explore)),
                title: Text(
                  'Travel purpose: $travelReason',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text('$from → $to · ${date.day}/${date.month}/${date.year}'),
              ),
            );
          }

          final t = trips[i - 1];
          return Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${t.departure}  →  ${t.arrival}',
                          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text(
                        '${t.price.toStringAsFixed(0)} EGP',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F4C81),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${t.from} → ${t.to}',
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${t.rating.toStringAsFixed(1)} (${t.reviewCount} ratings)',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${t.busType} · Trip ${t.id} · $passengers passenger${passengers > 1 ? 's' : ''}',
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SeatSelectionScreen(
                          trip: t,
                          date: date,
                          passengerCount: passengers,
                          travelReason: travelReason,
                        ),
                      ),
                    ),
                    child: const Text('Select seats'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
