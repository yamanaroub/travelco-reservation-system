import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/booking.dart';

class BookingStore {
  BookingStore._();
  static final ValueNotifier<List<Booking>> bookings = ValueNotifier<List<Booking>>([]);

  static Future<void> add(Booking booking) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookings')
        .doc(booking.id)
        .set({
      'id': booking.id,
      'date': Timestamp.fromDate(booking.date),
      'seats': booking.seats,
      'total': booking.total,
      'paymentMethod': booking.paymentMethod,
      'travelReason': booking.travelReason,

      'trip': {
        'id': booking.trip.id,
        'from': booking.trip.from,
        'to': booking.trip.to,
        'departure': booking.trip.departure,
        'arrival': booking.trip.arrival,
        'price': booking.trip.price,
        'busType': booking.trip.busType,
        'rating': booking.trip.rating,
        'reviewCount': booking.trip.reviewCount,
      },

      'createdAt': FieldValue.serverTimestamp(),
    });

    bookings.value = [...bookings.value, booking];
  }
}
