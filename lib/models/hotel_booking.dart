import 'hotel.dart';

class HotelBooking {
  const HotelBooking({
    required this.id,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
    required this.total,
    required this.paymentMethod,
  });

  final String id;
  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;
  final double total;
  final String paymentMethod;
}
