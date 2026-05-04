// lib/core/models/sync_action_adapter.dart
import 'package:hive/hive.dart';
import 'sync_action.dart';

class SyncActionAdapter extends TypeAdapter<SyncAction> {
  @override
  final int typeId = 1;

  @override
  SyncAction read(BinaryReader reader) {
    return SyncAction(
      id: reader.readString(),
      type: ActionType.values[reader.readInt()],
      data: reader.readMap().cast<String, dynamic>(),
      createdAt: DateTime.parse(reader.readString()),
      retryCount: reader.readInt(),
      status: SyncStatus.values[reader.readInt()],
      errorMessage: reader.readString(),
      idempotencyKey: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, SyncAction obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.type.index);
    writer.writeMap(obj.data);
    writer.writeString(obj.createdAt.toIso8601String());
    writer.writeInt(obj.retryCount);
    writer.writeInt(obj.status.index);
    writer.writeString(obj.errorMessage ?? '');
    writer.writeString(obj.idempotencyKey);
  }
}