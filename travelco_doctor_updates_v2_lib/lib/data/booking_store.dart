import 'package:flutter/foundation.dart';
import '../models/booking.dart';

class BookingStore {
  BookingStore._();
  static final ValueNotifier<List<Booking>> bookings = ValueNotifier<List<Booking>>([]);

  static void add(Booking booking) {
    bookings.value = [...bookings.value, booking];
  }
}
