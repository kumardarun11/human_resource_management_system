import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'services/admin_leave_service.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() =>
      _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  bool isLoading = true;
  int? actionLeaveId;
  List<dynamic> leaves = [];

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  Future<void> _loadLeaves() async {
    try {
      final response = await AdminLeaveService.getLeaveRequests();
      final rawData = response['data'];

      if (!mounted) return;

      setState(() {
        if (rawData is List) {
          leaves = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          leaves = rawData['data'];
        } else {
          leaves = [];
        }

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _updateLeave({
    required int id,
    required bool approve,
  }) async {
    setState(() {
      actionLeaveId = id;
    });

    try {
      final response = approve
          ? await AdminLeaveService.approveLeave(id)
          : await AdminLeaveService.rejectLeave(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message']?.toString() ??
                'Leave request updated.',
          ),
        ),
      );

      await _loadLeaves();
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data is Map
                ? data['message']?.toString() ??
                    'Unable to update leave.'
                : 'Unable to update leave.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          actionLeaveId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Requests'),
        actions: [
          IconButton(
            onPressed: _loadLeaves,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLeaves,
              child: leaves.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 200),
                        Icon(Icons.event_available, size: 70),
                        SizedBox(height: 16),
                        Center(
                          child: Text('No leave requests found.'),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: leaves.length,
                      itemBuilder: (context, index) {
                        final leave = Map<String, dynamic>.from(
                          leaves[index],
                        );

                        final id = leave['id'] as int;
                        final status =
                            leave['status']?.toString() ?? 'Pending';

                        final employee = leave['user'];

                        final employeeName = employee is Map
                            ? employee['name']?.toString() ??
                                'Employee'
                            : leave['employee'] is Map
                                ? leave['employee']['name']
                                        ?.toString() ??
                                    'Employee'
                                : 'Employee';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employeeName,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  leave['leave_type']?.toString() ??
                                      'Leave',
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'From: ${leave['from_date'] ?? 'N/A'}',
                                ),
                                Text(
                                  'To: ${leave['to_date'] ?? 'N/A'}',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Reason: ${leave['reason'] ?? 'No reason'}',
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Status: $status',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (status.toLowerCase() ==
                                    'pending') ...[
                                  const SizedBox(height: 18),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed:
                                              actionLeaveId != null
                                                  ? null
                                                  : () => _updateLeave(
                                                        id: id,
                                                        approve: true,
                                                      ),
                                          icon: const Icon(Icons.check),
                                          label:
                                              const Text('Approve'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed:
                                              actionLeaveId != null
                                                  ? null
                                                  : () => _updateLeave(
                                                        id: id,
                                                        approve: false,
                                                      ),
                                          icon: const Icon(Icons.close),
                                          label:
                                              const Text('Reject'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}