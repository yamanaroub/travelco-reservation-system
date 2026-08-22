import 'package:flutter/material.dart';

import '../models/trip.dart';
import 'booking_summary_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({
    super.key,
    required this.trip,
    required this.date,
    required this.passengerCount,
    required this.travelReason,
  });

  final Trip trip;
  final DateTime date;
  final int passengerCount;
  final String travelReason;

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Set<int> _selected = {};
  final Set<int> _booked = {3, 7, 12, 18, 25, 30};

  void _toggle(int seat) {
    if (_booked.contains(seat)) return;
    setState(() {
      if (_selected.contains(seat)) {
        _selected.remove(seat);
      } else if (_selected.length < widget.passengerCount) {
        _selected.add(seat);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Select only ${widget.passengerCount} seat${widget.passengerCount > 1 ? 's' : ''}.',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose seats')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Legend(color: Color(0xFFFFFFFF), text: 'Available'),
                _Legend(color: Color(0xFF4CAF50), text: 'Selected'),
                _Legend(color: Color(0xFFE53935), text: 'Booked'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Icon(Icons.person_pin, size: 40, color: Color(0xFF64748B)),
          ),
          const Text('Driver', style: TextStyle(color: Color(0xFF2E2727))),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: 36,
              itemBuilder: (_, i) {
                final seat = i + 1;
                final booked = _booked.contains(seat);
                final selected = _selected.contains(seat);
                return InkWell(
                  onTap: () => _toggle(seat),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: booked
                          ? const Color(0xFFE53935)
                          : selected
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      '$seat',
                      style: TextStyle(
                        color: booked || selected
                            ? Colors.white
                            : const Color(0xFF334155),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
            child: ElevatedButton(
              onPressed: _selected.length == widget.passengerCount
                  ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BookingSummaryScreen(
                            trip: widget.trip,
                            date: widget.date,
                            seats: _selected.toList()..sort(),
                            travelReason: widget.travelReason,
                          ),
                        ),
                      )
                  : null,
              child: Text(
                _selected.length == widget.passengerCount
                    ? 'Continue'
                    : 'Select ${widget.passengerCount - _selected.length} more',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
