import 'package:flutter/foundation.dart';
import '../models/hotel_booking.dart';

class HotelBookingStore {
  HotelBookingStore._();

  static final ValueNotifier<List<HotelBooking>> bookings =
      ValueNotifier<List<HotelBooking>>([]);

  static void add(HotelBooking booking) {
    bookings.value = [...bookings.value, booking];
  }
}
