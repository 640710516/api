import 'dart:math';

class Movies {
  final int? id;
  final String? title;
  final String? posterURL;
  final String? imdbId;
  bool isFavorite;
  double randomRating;

  Movies({
    required this.id,
    required this.title,
    required this.posterURL,
    required this.imdbId,
    this.isFavorite = false,
  }): randomRating = Random().nextDouble() * 5;

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      id: json['id'],
      title: json['title'],
      posterURL: json['posterURL'],
      imdbId: json['imdbId'],
      isFavorite: false, // Set default value for isFavorite
      
    );
  }
}
