import 'package:uuid/uuid.dart';

class Films {
  final String id;
  final String title;
  final String description;
  bool isFavorite;
  Films({
    required this.title,
    required this.description,
    required this.isFavorite,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Films copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
  }) {
    return Films(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Films(id: $id, title: $title, description: $description, isFavorite: $isFavorite)';
  }

  static List<Films> listFilms = [
    Films(
      id: const Uuid().v4(),
      title: 'The Shawshank Redemption',
      description: 'Two imprisoned',
      isFavorite: false,
    ),
    Films(
      id: const Uuid().v4(),
      title: 'The Godfather',
      description:
          'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      isFavorite: false,
    ),
    Films(
      id: const Uuid().v4(),
      title: 'The Dark Knight',
      description:
          'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, the caped crusader must come to terms with one of the greatest psychological tests of his ability to fight injustice.',
      isFavorite: false,
    ),
    Films(
      id: const Uuid().v4(),
      title: 'The Godfather: Part II',
      description:
          'The early life and career of Vito Corleone in 1920s New York is portrayed while his son, Michael, expands and tightens his grip on the family crime syndicate.',
      isFavorite: false,
    ),
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isFavourite': isFavorite,
    };
  }

  factory Films.fromJson(Map<String, dynamic> map) {
    return Films(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isFavorite: map['isFavourite'] ?? false,
    );
  }
}
