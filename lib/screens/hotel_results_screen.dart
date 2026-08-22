import 'package:flutter/material.dart';

import '../models/hotel.dart';
import 'hotel_booking_screen.dart';

class HotelResultsScreen extends StatelessWidget {
  const HotelResultsScreen({
    super.key,
    required this.city,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
  });

  final String city;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;

  List<Hotel> get _hotels => [
        Hotel(
          id: 'HT101',
          name: '$city Grand Hotel',
          city: city,
          pricePerNight: 1450,
          rating: 4.8,
          reviewCount: 842,
          description: 'Modern rooms near the city center with breakfast included.',
          amenities: const ['Wi-Fi', 'Breakfast', 'Pool'],
        ),
        Hotel(
          id: 'HT205',
          name: 'Travelco City Suites',
          city: city,
          pricePerNight: 980,
          rating: 4.5,
          reviewCount: 516,
          description: 'Comfortable suites for short stays, business and families.',
          amenities: const ['Wi-Fi', 'Parking', 'Gym'],
        ),
        Hotel(
          id: 'HT312',
          name: 'Skyline Stay $city',
          city: city,
          pricePerNight: 1720,
          rating: 4.9,
          reviewCount: 331,
          description: 'Premium stay with spacious rooms and a city-view restaurant.',
          amenities: const ['Restaurant', 'Room service', 'Spa'],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final nights = checkOut.difference(checkIn).inDays;
    return Scaffold(
      appBar: AppBar(title: Text('Hotels in $city')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _hotels.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, index) {
          if (index == 0) {
            return Card(
              color: const Color(0xFFF5F3FF),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.hotel)),
                title: Text('$nights night${nights == 1 ? '' : 's'} · $rooms room${rooms == 1 ? '' : 's'}'),
                subtitle: Text('$guests guest${guests == 1 ? '' : 's'} · ${checkIn.day}/${checkIn.month} - ${checkOut.day}/${checkOut.month}'),
              ),
            );
          }

          final hotel = _hotels[index - 1];
          return Card(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 135,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF312E81)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 8,
                        bottom: -22,
                        child: Icon(
                          Icons.apartment,
                          size: 145,
                          color: Colors.white.withOpacity(0.17),
                        ),
                      ),
                      const Positioned(
                        left: 18,
                        top: 18,
                        child: Icon(Icons.hotel, color: Colors.white, size: 34),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        hotel.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${hotel.rating.toStringAsFixed(1)} (${hotel.reviewCount} ratings)',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(hotel.description, style: const TextStyle(color: Color(0xFF64748B))),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: hotel.amenities
                            .map(
                              (a) => Chip(
                                label: Text(a),
                                visualDensity: VisualDensity.compact,
                                side: BorderSide.none,
                                backgroundColor: const Color(0xFFF1F5F9),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${hotel.pricePerNight.toStringAsFixed(0)} EGP / night',
                              style: const TextStyle(
                                color: Color(0xFF0F4C81),
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HotelBookingScreen(
                              hotel: hotel,
                              checkIn: checkIn,
                              checkOut: checkOut,
                              guests: guests,
                              rooms: rooms,
                            ),
                          ),
                        ),
                        child: const Text('Book hotel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
