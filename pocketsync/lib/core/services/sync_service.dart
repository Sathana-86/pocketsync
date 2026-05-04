import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../repositories/note_repository.dart';
import '../models/sync_action.dart';

class SyncService {
  final NoteRepository _repository;
  final Connectivity _connectivity = Connectivity();
  Timer? _retryTimer;
  bool _isSyncing = false;

  final _logsController = StreamController<String>.broadcast();
  Stream<String> get logs => _logsController.stream;

  final _statsController = StreamController<Map<String, int>>.broadcast();
  Stream<Map<String, int>> get stats => _statsController.stream;

  SyncService(this._repository) {
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none && !_isSyncing) {
        _addLog('🌐 Network restored - starting sync');
        startSync();
      }
    });
  }

  // FIXED: startSync - check connectivity first
  Future<void> startSync() async {
    // Check if online
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      _addLog('📡 Device is OFFLINE - Cannot sync');
      return;
    }

    if (_isSyncing) {
      _addLog('⚠️ Sync already in progress');
      return;
    }

    _isSyncing = true;

    try {
      final pendingActions = await _repository.getPendingActions();
      if (pendingActions.isEmpty) {
        _addLog('📭 No pending actions to sync');
        _emitStats();
        return;
      }

      _addLog('🔄 Starting sync of ${pendingActions.length} actions');

      for (var action in pendingActions) {
        await _processActionWithRetry(action);
      }

      _addLog('✅ Sync completed successfully');
    } catch (e) {
      _addLog('❌ Sync error: $e');
    } finally {
      _isSyncing = false;
      _emitStats();
    }
  }

  Future<void> _processActionWithRetry(SyncAction action) async {
    const maxRetries = 3;
    const baseDelay = Duration(seconds: 2);

    int attempt = 0;
    while (attempt <= maxRetries) {
      final success = await _repository.syncAction(action);

      if (success) {
        _addLog('✅ Synced: ${action.type.name} (${action.data['title'] ?? action.data['id']})');
        return;
      }

      attempt++;
      if (attempt <= maxRetries) {
        _addLog('⚠️ Retry $attempt/$maxRetries for ${action.type.name} (backoff ${baseDelay.inSeconds * attempt}s)');
        await _repository.updateSyncActionStatus(action.id, SyncStatus.retrying);
        await Future.delayed(baseDelay * attempt);
      } else {
        _addLog('❌ Failed to sync after $maxRetries attempts: ${action.type.name}');
        await _repository.updateSyncActionStatus(action.id, SyncStatus.failed,
            error: 'Max retries exceeded');
      }
    }
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    _logsController.add('[$timestamp] $message');
    print('[NoteSync] $message');
  }

  void _emitStats() {
    _statsController.add({
      'pending': _repository.getPendingCount(),
      'retrying': _repository.getPendingCount(),
      'failed': _repository.getFailedCount(),
    });
  }

  void dispose() {
    _retryTimer?.cancel();
    _logsController.close();
    _statsController.close();
  }
}