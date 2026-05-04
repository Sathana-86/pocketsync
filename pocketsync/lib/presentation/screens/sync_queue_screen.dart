import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import '../../core/models/sync_action.dart';

class SyncQueueScreen extends ConsumerStatefulWidget {
  const SyncQueueScreen({super.key});

  @override
  ConsumerState<SyncQueueScreen> createState() => _SyncQueueScreenState();
}

class _SyncQueueScreenState extends ConsumerState<SyncQueueScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncQueueProvider.notifier).refresh();
      _listenToLogs();
    });
  }

  void _listenToLogs() {
    ref.read(syncServiceProvider).logs.listen((log) {
      if (mounted) {
        setState(() {
          _logs.insert(0, log);
          if (_logs.length > 100) _logs.removeLast();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = ref.watch(syncQueueProvider);
    final stats = ref.watch(syncStatsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pending = actions.where((a) => a.status == SyncStatus.pending).toList();
    final retrying = actions.where((a) => a.status == SyncStatus.retrying).toList();
    final failed = actions.where((a) => a.status == SyncStatus.failed).toList();

    final pendingActions = [...pending, ...retrying];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(syncQueueProvider.notifier).refresh();
              ref.read(syncServiceProvider).startSync();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending (${pendingActions.length})'),
            Tab(text: 'Failed (${failed.length})'),
            const Tab(text: 'Logs'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (stats.hasValue)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
              ),
              child: Row(
                children: [
                  _StatChip('Pending', stats.value!['pending'] ?? 0, Colors.orange, isDark),
                  const SizedBox(width: 8),
                  _StatChip('Retrying', 0, Colors.blue, isDark),
                  const SizedBox(width: 8),
                  _StatChip('Failed', stats.value!['failed'] ?? 0, Colors.red, isDark),
                  const Spacer(),
                  if (pendingActions.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => ref.read(syncServiceProvider).startSync(),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Retry All'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                pendingActions.isEmpty
                    ? Center(child: Text('No pending actions', style: TextStyle(color: Colors.grey.shade600)))
                    : ListView.builder(
                  itemCount: pendingActions.length,
                  itemBuilder: (context, index) {
                    final action = pendingActions[index];
                    return _ActionTile(action: action);
                  },
                ),
                failed.isEmpty
                    ? Center(child: Text('No failed actions', style: TextStyle(color: Colors.grey.shade600)))
                    : ListView.builder(
                  itemCount: failed.length,
                  itemBuilder: (context, index) {
                    final action = failed[index];
                    return _ActionTile(action: action);
                  },
                ),
                _logs.isEmpty
                    ? Center(child: Text('No logs yet', style: TextStyle(color: Colors.grey.shade600)))
                    : ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        _logs[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool isDark;

  const _StatChip(this.label, this.value, this.color, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final SyncAction action;

  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: action.type == ActionType.like
                  ? (isDark ? const Color(0xFF791F1F) : const Color(0xFFFCEBEB))
                  : (isDark ? const Color(0xFF3C3489) : const Color(0xFFEEEDFE)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              action.type == ActionType.like ? Icons.favorite : Icons.note,
              color: action.type == ActionType.like ? Colors.red : Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${action.type.name}: ${action.data['title'] ?? action.data['id']}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                if (action.retryCount > 0)
                  Text(
                    'Attempt ${action.retryCount}/3 · backoff ${action.retryCount * 2}s',
                    style: TextStyle(fontSize: 10, color: Colors.orange.shade700),
                  ),
                Text(
                  'ID: ${action.idempotencyKey.substring(0, 8)}...',
                  style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: action.status == SyncStatus.failed
                  ? (isDark ? const Color(0xFF791F1F) : const Color(0xFFFCEBEB))
                  : action.status == SyncStatus.retrying
                  ? (isDark ? const Color(0xFF633806) : const Color(0xFFFAEEDA))
                  : (isDark ? const Color(0xFF085041) : const Color(0xFFE1F5EE)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              action.status.name.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: action.status == SyncStatus.failed
                    ? Colors.red
                    : action.status == SyncStatus.retrying
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}