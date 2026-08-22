class Hotel {
  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.pricePerNight,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.amenities,
  });

  final String id;
  final String name;
  final String city;
  final double pricePerNight;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> amenities;
}
