import 'package:flutter/material.dart';

import '../data/booking_store.dart';
import '../data/hotel_booking_store.dart';
import 'hotel_ticket_screen.dart';
import 'ticket_screen.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = ValueListenableBuilder(
      valueListenable: BookingStore.bookings,
      builder: (_, tripBookings, __) {
        return ValueListenableBuilder(
          valueListenable: HotelBookingStore.bookings,
          builder: (_, hotelBookings, __) {
            if (tripBookings.isEmpty && hotelBookings.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        size: 64,
                        color: Color(0xFF94A3B8),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'No bookings yet',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Your trip and hotel reservations will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (tripBookings.isNotEmpty) ...[
                  const Text(
                    'Bus trips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  ...tripBookings.reversed.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.directions_bus)),
                          title: Text(
                            '${b.trip.from} → ${b.trip.to}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '${b.trip.departure} · Seats ${b.seats.join(', ')} · ${b.id}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => TicketScreen(booking: b)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (hotelBookings.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Hotels',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  ...hotelBookings.reversed.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFEDE9FE),
                            child: Icon(Icons.hotel, color: Color(0xFF7C3AED)),
                          ),
                          title: Text(
                            b.hotel.name,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '${b.hotel.city} · ${b.rooms} room${b.rooms == 1 ? '' : 's'} · ${b.id}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => HotelTicketScreen(booking: b)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );

    if (embedded) {
      return SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My bookings',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(appBar: AppBar(title: const Text('My bookings')), body: content);
  }
}
