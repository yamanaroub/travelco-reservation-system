import 'package:flutter/material.dart';

import '../models/booking.dart';
import 'home_screen.dart';
import 'hotel_search_screen.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key, required this.booking});

  final Booking booking;

  String get _nextDestination {
    final choices = switch (booking.travelReason) {
      'Work' => const ['Cairo', 'Alexandria', 'Giza'],
      _ => const ['Sharm El Sheikh', 'Hurghada', 'Luxor', 'Aswan'],
    };
    return choices.firstWhere(
      (city) => city != booking.trip.to,
      orElse: () => 'Alexandria',
    );
  }

  Future<void> _rateTrip(BuildContext context) async {
    var rating = 5;
    final comment = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Rate your trip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    onPressed: () => setState(() => rating = i + 1),
                    icon: Icon(
                      i < rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: const Color(0xFFF59E0B),
                      size: 34,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: comment,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  hintText: 'How was your trip?',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Thanks! Your $rating-star rating was submitted.')),
                );
              },
              child: const Text('Submit rating'),
            ),
          ],
        ),
      ),
    );

    comment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-ticket'), automaticallyImplyLeading: false),
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
                  'Booking confirmed!',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        const Icon(Icons.qr_code_2, size: 120, color: Color(0xFF0F172A)),
                        const SizedBox(height: 10),
                        Text(
                          booking.id,
                          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
                        ),
                        const Divider(height: 30),
                        Text(
                          '${booking.trip.from} → ${booking.trip.to}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        _line('Date', '${booking.date.day}/${booking.date.month}/${booking.date.year}'),
                        _line('Departure', booking.trip.departure),
                        _line('Reason', booking.travelReason),
                        _line('Seats', booking.seats.join(', ')),
                        _line('Payment', booking.paymentMethod),
                        _line('Total', '${booking.total.toStringAsFixed(0)} EGP'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  color: const Color(0xFFFFF7ED),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFFFE7C2),
                      child: Icon(Icons.auto_awesome, color: Color(0xFFB45309)),
                    ),
                    title: Text(
                      'Your next ${booking.travelReason.toLowerCase()} trip',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(
                      'Based on your travel purpose, we recommend $_nextDestination next.',
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: const Color(0xFFF5F3FF),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFFEDE9FE),
                              child: Icon(Icons.hotel, color: Color(0xFF7C3AED)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Need a hotel in ${booking.trip.to}?',
                                    style: const TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                  const Text(
                                    'We already know your destination and travel date.',
                                    style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HotelSearchScreen(
                                initialCity: booking.trip.to,
                                initialCheckIn: booking.date,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.hotel),
                          label: Text('Find hotels in ${booking.trip.to}'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _rateTrip(context),
                  icon: const Icon(Icons.star_outline),
                  label: const Text('Rate this trip'),
                ),
                const SizedBox(height: 12),
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
