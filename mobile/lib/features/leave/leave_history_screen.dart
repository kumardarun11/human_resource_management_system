import 'package:flutter/material.dart';

import 'services/leave_service.dart';

class LeaveHistoryScreen extends StatefulWidget {
  const LeaveHistoryScreen({super.key});

  @override
  State<LeaveHistoryScreen> createState() =>
      _LeaveHistoryScreenState();
}

class _LeaveHistoryScreenState extends State<LeaveHistoryScreen> {
  bool isLoading = true;
  String? error;

  List<dynamic> leaves = [];

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  Future<void> _loadLeaves() async {
    try {
      final response = await LeaveService.getLeaves();

      if (!mounted) return;

      final rawData = response['data'];

      setState(() {
        if (rawData is List) {
          leaves = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          leaves = rawData['data'];
        } else {
          leaves = [];
        }

        isLoading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _leaveCard(dynamic item) {
    final leave = Map<String, dynamic>.from(item);

    final String status =
        leave['status']?.toString() ?? 'Pending';

    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'approved':
        statusIcon = Icons.check_circle_outline;
        break;

      case 'rejected':
        statusIcon = Icons.cancel_outlined;
        break;

      default:
        statusIcon = Icons.schedule;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    leave['leave_type']?.toString() ??
                        'Leave Request',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(statusIcon),
                const SizedBox(width: 6),
                Text(
                  status,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'From: ${leave['from_date'] ?? 'N/A'}',
            ),

            const SizedBox(height: 6),

            Text(
              'To: ${leave['to_date'] ?? 'N/A'}',
            ),

            const SizedBox(height: 6),

            Text(
              'Total Days: ${leave['total_days'] ?? 'N/A'}',
            ),

            const SizedBox(height: 12),

            const Text(
              'Reason',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              leave['reason']?.toString().isNotEmpty == true
                  ? leave['reason'].toString()
                  : 'No reason provided',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave History'),
        actions: [
          IconButton(
            onPressed: _loadLeaves,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              error = null;
                            });

                            _loadLeaves();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadLeaves,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'My Leave Requests',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${leaves.length} leave request(s)',
                      ),

                      const SizedBox(height: 24),

                      if (leaves.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text(
                              'No leave requests found.',
                            ),
                          ),
                        )
                      else
                        ...leaves.map(_leaveCard),
                    ],
                  ),
                ),
    );
  }
}