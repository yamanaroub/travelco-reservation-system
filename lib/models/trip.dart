class Trip {
  const Trip({
    required this.id,
    required this.from,
    required this.to,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.busType,
    this.rating = 4.7,
    this.reviewCount = 120,
  });

  final String id;
  final String from;
  final String to;
  final String departure;
  final String arrival;
  final double price;
  final String busType;
  final double rating;
  final int reviewCount;
}
