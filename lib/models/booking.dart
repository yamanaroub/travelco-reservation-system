import 'trip.dart';

class Booking {
  const Booking({
    required this.id,
    required this.trip,
    required this.seats,
    required this.date,
    required this.total,
    required this.paymentMethod,
    required this.travelReason,
  });

  final String id;
  final Trip trip;
  final List<int> seats;
  final DateTime date;
  final double total;
  final String paymentMethod;
  final String travelReason;
}
