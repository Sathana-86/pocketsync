import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

//part 'sync_action.g.dart'; // Keep this even with manual adapter

enum ActionType { create, update, like, delete }
enum SyncStatus { pending, retrying, completed, failed }

@HiveType(typeId: 1)
class SyncAction {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ActionType type;

  @HiveField(2)
  final Map<String, dynamic> data;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  int retryCount;

  @HiveField(5)
  SyncStatus status;

  @HiveField(6)
  String? errorMessage;

  @HiveField(7)
  final String idempotencyKey;

  SyncAction({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.status = SyncStatus.pending,
    this.errorMessage,
    required this.idempotencyKey,
  });

  factory SyncAction.create({
    required ActionType type,
    required Map<String, dynamic> data,
  }) {
    final contentHash = '${type.name}_${DateTime.now().millisecondsSinceEpoch}_${data['id'] ?? data.hashCode}';
    return SyncAction(
      id: const Uuid().v4(),
      type: type,
      data: data,
      createdAt: DateTime.now(),
      idempotencyKey: contentHash,
    );
  }

  SyncAction copyWith({
    int? retryCount,
    SyncStatus? status,
    String? errorMessage,
  }) {
    return SyncAction(
      id: id,
      type: type,
      data: data,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      idempotencyKey: idempotencyKey,
    );
  }
}