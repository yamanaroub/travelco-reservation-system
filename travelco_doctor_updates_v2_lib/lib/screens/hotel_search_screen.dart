import 'package:flutter/material.dart';

import 'hotel_results_screen.dart';

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({
    super.key,
    this.initialCity,
    this.initialCheckIn,
  });

  final String? initialCity;
  final DateTime? initialCheckIn;

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  late String _city;
  late DateTime _checkIn;
  late DateTime _checkOut;
  int _guests = 1;
  int _rooms = 1;

  final _cities = const [
    'Cairo',
    'Alexandria',
    'Giza',
    'Hurghada',
    'Sharm El Sheikh',
    'Luxor',
    'Aswan',
  ];

  @override
  void initState() {
    super.initState();
    _city = _cities.contains(widget.initialCity) ? widget.initialCity! : 'Cairo';
    _checkIn = widget.initialCheckIn ?? DateTime.now().add(const Duration(days: 1));
    _checkOut = _checkIn.add(const Duration(days: 2));
  }

  Future<void> _pickCheckIn() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkIn,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _checkIn = date;
        if (!_checkOut.isAfter(_checkIn)) {
          _checkOut = _checkIn.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickCheckOut() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkOut,
      firstDate: _checkIn.add(const Duration(days: 1)),
      lastDate: _checkIn.add(const Duration(days: 60)),
    );
    if (date != null) setState(() => _checkOut = date);
  }

  void _searchHotels() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HotelResultsScreen(
          city: _city,
          checkIn: _checkIn,
          checkOut: _checkOut,
          guests: _guests,
          rooms: _rooms,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a hotel')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  Positioned(
                    right: -18,
                    bottom: -26,
                    child: Icon(
                      Icons.apartment,
                      size: 170,
                      color: Colors.white.withOpacity(0.16),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.hotel, color: Colors.white, size: 36),
                        SizedBox(height: 8),
                        Text(
                          'Find your stay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Search hotels independently or after booking a trip.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _city,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    items: _cities
                        .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                        .toList(),
                    onChanged: (v) => setState(() => _city = v!),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _pickCheckIn,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Check-in',
                        prefixIcon: Icon(Icons.login),
                      ),
                      child: Text('${_checkIn.day}/${_checkIn.month}/${_checkIn.year}'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _pickCheckOut,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Check-out',
                        prefixIcon: Icon(Icons.logout),
                      ),
                      child: Text('${_checkOut.day}/${_checkOut.month}/${_checkOut.year}'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CounterRow(
                    label: 'Guests',
                    value: _guests,
                    onMinus: _guests > 1 ? () => setState(() => _guests--) : null,
                    onPlus: _guests < 10 ? () => setState(() => _guests++) : null,
                  ),
                  _CounterRow(
                    label: 'Rooms',
                    value: _rooms,
                    onMinus: _rooms > 1 ? () => setState(() => _rooms--) : null,
                    onPlus: _rooms < 5 ? () => setState(() => _rooms++) : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _searchHotels,
                    icon: const Icon(Icons.search),
                    label: const Text('Search hotels'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
        IconButton(onPressed: onMinus, icon: const Icon(Icons.remove_circle_outline)),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w900)),
        IconButton(onPressed: onPlus, icon: const Icon(Icons.add_circle_outline)),
      ],
    );
  }
}
