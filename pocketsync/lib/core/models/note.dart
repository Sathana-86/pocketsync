// lib/core/models/note.dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  bool isLiked;

  @HiveField(6)
  final String userId;

  @HiveField(7)
  int version;

  @HiveField(8)  // Add this field
  DateTime? cachedAt;  // When this note was cached

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
    required this.userId,
    this.version = 1,
    this.cachedAt,
  });

  factory Note.create({
    required String title,
    required String content,
    required String userId,
  }) {
    final now = DateTime.now();
    return Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
      userId: userId,
      cachedAt: now,  // Set cache time on creation
    );
  }

  // Check if cache is still valid
  bool isCacheValid({Duration? ttl}) {
    if (cachedAt == null) return false;
    if (ttl == null) return true;
    return DateTime.now().difference(cachedAt!) < ttl;
  }

  Note copyWith({
    String? title,
    String? content,
    bool? isLiked,
    DateTime? updatedAt,
    int? version,
    DateTime? cachedAt,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isLiked: isLiked ?? this.isLiked,
      userId: userId,
      version: version ?? this.version + 1,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isLiked': isLiked,
    'userId': userId,
    'version': version,
    'cachedAt': cachedAt?.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    isLiked: json['isLiked'] ?? false,
    userId: json['userId'],
    version: json['version'] ?? 1,
    cachedAt: json['cachedAt'] != null ? DateTime.parse(json['cachedAt']) : null,
  );
}