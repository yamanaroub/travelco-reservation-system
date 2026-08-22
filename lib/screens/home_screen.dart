import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/booking_store.dart';
import '../data/hotel_booking_store.dart';
import 'bookings_screen.dart';
import 'hotel_search_screen.dart';
import 'login_screen.dart';
import 'trip_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  String _from = 'Cairo';
  String _to = 'Alexandria';
  String _travelReason = 'Relaxation';
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  int _passengers = 1;
  final GlobalKey _tripFormKey = GlobalKey();

  final _cities = const [
    'Cairo',
    'Alexandria',
    'Giza',
    'Hurghada',
    'Sharm El Sheikh',
    'Luxor',
    'Aswan',
  ];

  final _reasons = const ['Work', 'Relaxation'];

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _date = d);
  }

  String get _recommendedDestination {
    final options = switch (_travelReason) {
      'Work' => const ['Cairo', 'Alexandria', 'Giza'],
      _ => const ['Sharm El Sheikh', 'Hurghada', 'Luxor', 'Aswan'],
    };
    return options.firstWhere((city) => city != _from, orElse: () => 'Alexandria');
  }

  String get _recommendationText {
    return switch (_travelReason) {
      'Work' => 'Business-friendly routes with convenient departure times.',
      _ => 'A relaxing destination that is popular for leisure and sightseeing.',
    };
  }

  void _search() {
    if (_from == _to) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose different cities.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TripResultsScreen(
          from: _from,
          to: _to,
          date: _date,
          passengers: _passengers,
          travelReason: _travelReason,
        ),
      ),
    );
  }

  void _showTripForm() {
    final context = _tripFormKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.08,
    );
  }

  void _openHotels() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HotelSearchScreen(
          initialCity: _to,
          initialCheckIn: _date,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_home(), const BookingsScreen(embedded: true), _profile()];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (v) => setState(() => _index = v),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _home() {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F4C81), Color(0xFF147F98)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good evening', style: TextStyle(color: Colors.white70)),
                      Text(
                        'Welcome to Travelco',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.notifications_none, color: Colors.white),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'What would you like to book?',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ServiceCard(
                        title: 'Book a Trip',
                        subtitle: 'Bus trips & seats',
                        icon: Icons.directions_bus_filled,
                        colors: const [Color(0xFF0F4C81), Color(0xFF147F98)],
                        onTap: _showTripForm,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ServiceCard(
                        title: 'Book a Hotel',
                        subtitle: 'Rooms & stays',
                        icon: Icons.hotel,
                        colors: const [Color(0xFF7C3AED), Color(0xFFA855F7)],
                        onTap: _openHotels,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Plan your bus trip',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose your route, travel purpose and seats.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                Card(
                  key: _tripFormKey,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _from,
                          decoration: const InputDecoration(
                            labelText: 'From',
                            prefixIcon: Icon(Icons.trip_origin,color: Color(0xFF4CAF50),),
                          ),
                          items: _cities
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _from = v!),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _to,
                          decoration: const InputDecoration(
                            labelText: 'To',
                            prefixIcon: Icon(Icons.location_on_outlined ,color:Color(0xFFE53935) ,),
                          ),
                          items: _cities
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _to = v!),
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) => PopupMenuButton<String>(
                            initialValue: _travelReason,
                            position: PopupMenuPosition.under,
                            offset: const Offset(0, 4),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints.tightFor(
                              width: constraints.maxWidth,
                            ),
                            onSelected: (v) => setState(() => _travelReason = v),
                            itemBuilder: (context) => _reasons
                                .map(
                                  (r) => PopupMenuItem<String>(
                                    value: r,
                                    child: Text(r),
                                  ),
                                )
                                .toList(),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Reason for travel',
                                prefixIcon: ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [
                                      Color(0xFF7E57C2),
                                      Color(0xFFE53935),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: const Icon(
                                    Icons.travel_explore,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: Text(_travelReason)),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Travel date',
                              prefixIcon: Icon(Icons.calendar_month,color: Color(0xFF3F7CAC),),
                            ),
                            child: Text('${_date.day}/${_date.month}/${_date.year}'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Passengers',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            IconButton(
                              onPressed: _passengers > 1
                                  ? () => setState(() => _passengers--)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text(
                              '$_passengers',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            IconButton(
                              onPressed: _passengers < 10
                                  ? () => setState(() => _passengers++)
                                  : null,
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _search,
                          child: const Text('Search trips'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: const Color(0xFFFFF7ED),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFFFE7C2),
                          child: Icon(Icons.auto_awesome, color: Color(0xFFB45309)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommended for $_travelReason',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _recommendedDestination,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F4C81),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _recommendationText,
                                style: const TextStyle(color: Color(0xFF64748B)),
                              ),
                              const SizedBox(height: 10),
                              TextButton.icon(
                                onPressed: () => setState(() => _to = _recommendedDestination),
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Use this destination'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: BookingStore.bookings,
                  builder: (_, tripBookings, __) {
                    return ValueListenableBuilder(
                      valueListenable: HotelBookingStore.bookings,
                      builder: (_, hotelBookings, __) {
                        final total = tripBookings.length + hotelBookings.length;
                        if (total == 0) return const SizedBox.shrink();
                        return Card(
                          color: const Color(0xFFEAF8F7),
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF0F766E),
                            ),
                            title: Text(
                              '$total active booking${total == 1 ? '' : 's'}',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            subtitle: const Text('Open Bookings to view your reservations.'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => setState(() => _index = 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profile() {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
          const SizedBox(height: 14),
          Text(
            user?.displayName ?? 'User',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            user?.email ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 28),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle_outlined),
                  title: Text('Account information'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Help & support'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Positioned(
                  right: -18,
                  bottom: -20,
                  child: Icon(icon, size: 120, color: Colors.white.withOpacity(0.16)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(icon, color: Colors.white, size: 30),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(subtitle, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
