import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/booking_store.dart';
import '../models/booking.dart';
import '../models/trip.dart';
import 'ticket_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.trip,
    required this.date,
    required this.seats,
    required this.total,
    required this.travelReason,
  });

  final Trip trip;
  final DateTime date;
  final List<int> seats;
  final double total;
  final String travelReason;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardholder = TextEditingController();
  final _cardNumber = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();

  String _method = 'Card';
  bool _processing = false;

  @override
  void dispose() {
    _cardholder.dispose();
    _cardNumber.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  String get _previewNumber {
    final digits = _cardNumber.text.replaceAll(' ', '');
    if (digits.isEmpty) return '••••  ••••  ••••  ••••';
    final padded = digits.padRight(16, '•').substring(0, 16);
    return '${padded.substring(0, 4)}  ${padded.substring(4, 8)}  ${padded.substring(8, 12)}  ${padded.substring(12, 16)}';
  }

  Future<void> _pay() async {
    if (_method == 'Card' && !(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final booking = Booking(
      id: 'BK${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      trip: widget.trip,
      seats: widget.seats,
      date: widget.date,
      total: widget.total,
      paymentMethod: _method,
      travelReason: widget.travelReason,
    );
    BookingStore.add(booking);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => TicketScreen(booking: booking)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: const Color(0xFFEFF6FF),
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: Color(0xFF0F4C81)),
              title: const Text('Amount to pay', style: TextStyle(fontWeight: FontWeight.w700)),
              trailing: Text(
                '${widget.total.toStringAsFixed(0)} EGP',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F4C81),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Choose payment method',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          ...['Card', 'Cash at station', 'Mobile wallet'].map(
            (m) => Card(
              color: Colors.white,
              child: RadioListTile<String>(
                value: m,
                groupValue: _method,
                onChanged: (v) => setState(() => _method = v!),
                title: Text(m),
                secondary: Icon(
                  m == 'Card'
                      ? Icons.credit_card
                      : m == 'Cash at station'
                          ? Icons.payments_outlined
                          : Icons.phone_android,
                ),
              ),
            ),
          ),
          if (_method == 'Card') ...[
            const SizedBox(height: 18),
            _cardPreview(),
            const SizedBox(height: 18),
            Form(
              key: _formKey,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Card details',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1434CB),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Text(
                              'VISA',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Text(
                              'Mastercard',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cardholder,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Cardholder name',
                          hintText: 'NAME AS ON CARD',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (v) => (v ?? '').trim().length >= 3
                            ? null
                            : 'Enter the cardholder name',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _cardNumber,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Card number',
                          hintText: '1234 5678 9012 3456',
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          _CardNumberFormatter(),
                        ],
                        onChanged: (_) => setState(() {}),
                        validator: (v) => (v ?? '').replaceAll(' ', '').length == 16
                            ? null
                            : 'Card number must contain 16 digits',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _expiry,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Expiry date',
                                hintText: 'MM/YY',
                                prefixIcon: Icon(Icons.calendar_month_outlined),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                _ExpiryFormatter(),
                              ],
                              onChanged: (_) => setState(() {}),
                              validator: _validateExpiry,
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
                                hintText: '123',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: (v) => (v ?? '').length == 3
                                  ? null
                                  : 'Enter 3 digits',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.lock, size: 17, color: Color(0xFF0F766E)),
                          SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              'Demo payment: card details are validated locally and are not stored.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _processing ? null : _pay,
            icon: const Icon(Icons.lock_outline),
            label: Text(
              _processing
                  ? 'Processing...'
                  : _method == 'Card'
                      ? 'Pay ${widget.total.toStringAsFixed(0)} EGP'
                      : 'Confirm payment',
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardPreview() {
    return Container(
      height: 205,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.contactless, color: Colors.white, size: 30),
              Spacer(),
              Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _previewNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CARDHOLDER',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                    Text(
                      _cardholder.text.trim().isEmpty
                          ? 'YOUR NAME'
                          : _cardholder.text.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(color: Colors.white60, fontSize: 10),
                  ),
                  Text(
                    _expiry.text.isEmpty ? 'MM/YY' : _expiry.text,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _validateExpiry(String? value) {
    final text = value ?? '';
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(text)) return 'Use MM/YY';
    final month = int.tryParse(text.substring(0, 2)) ?? 0;
    if (month < 1 || month > 12) return 'Invalid month';
    return null;
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final text = digits.length <= 2
        ? digits
        : '${digits.substring(0, 2)}/${digits.substring(2)}';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
