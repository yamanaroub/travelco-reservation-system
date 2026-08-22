import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/hotel_booking_store.dart';
import '../models/hotel.dart';
import '../models/hotel_booking.dart';
import 'hotel_ticket_screen.dart';

class HotelPaymentScreen extends StatefulWidget {
  const HotelPaymentScreen({
    super.key,
    required this.hotel,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
    required this.total,
  });

  final Hotel hotel;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;
  final double total;

  @override
  State<HotelPaymentScreen> createState() => _HotelPaymentScreenState();
}

class _HotelPaymentScreenState extends State<HotelPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _number = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  String _method = 'Card';
  bool _processing = false;

  @override
  void dispose() {
    _name.dispose();
    _number.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    if (_method == 'Card' && !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final booking = HotelBooking(
      id: 'HTB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      hotel: widget.hotel,
      checkIn: widget.checkIn,
      checkOut: widget.checkOut,
      guests: widget.guests,
      rooms: widget.rooms,
      total: widget.total,
      paymentMethod: _method,
    );
    HotelBookingStore.add(booking);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HotelTicketScreen(booking: booking)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel payment')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: const Color(0xFFF5F3FF),
            child: ListTile(
              leading: const Icon(Icons.hotel, color: Color(0xFF7C3AED)),
              title: Text(widget.hotel.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${widget.rooms} room${widget.rooms == 1 ? '' : 's'}'),
              trailing: Text(
                '${widget.total.toStringAsFixed(0)} EGP',
                style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF7C3AED)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...['Card', 'Pay at hotel'].map(
            (m) => Card(
              color: Colors.white,
              child: RadioListTile<String>(
                value: m,
                groupValue: _method,
                onChanged: (v) => setState(() => _method = v!),
                title: Text(m),
                secondary: Icon(m == 'Card' ? Icons.credit_card : Icons.hotel_class_outlined),
              ),
            ),
          ),
          if (_method == 'Card') ...[
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Visa / Mastercard details',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                          ),
                          Icon(Icons.credit_card, color: Color(0xFF0F4C81)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Cardholder name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v ?? '').trim().length >= 3 ? null : 'Enter cardholder name',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _number,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Card number',
                          hintText: '1234 5678 9012 3456',
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        validator: (v) => (v ?? '').length == 16 ? null : 'Enter 16 digits',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _expiry,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                labelText: 'Expiry (MM/YY)',
                                prefixIcon: Icon(Icons.calendar_month),
                              ),
                              inputFormatters: [LengthLimitingTextInputFormatter(5)],
                              validator: (v) => RegExp(r'^\d{2}/\d{2}$').hasMatch(v ?? '')
                                  ? null
                                  : 'Use MM/YY',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _cvv,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'CVV',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: (v) => (v ?? '').length == 3 ? null : 'Enter 3 digits',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Demo only — card information is not saved.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _processing ? null : _pay,
            child: Text(_processing ? 'Processing...' : 'Confirm hotel booking'),
          ),
        ],
      ),
    );
  }
}
