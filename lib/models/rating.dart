class Rating {
  final int rating;
  final String feedback;
  final int customerId;
  final String createdAt;

  Rating({
    required this.rating,
    required this.feedback,
    required this.customerId,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json['rating'],
      feedback: json['feedback'],
      customerId: json['customer_id'],
      createdAt: json['created_at'],
    );
  }
}
