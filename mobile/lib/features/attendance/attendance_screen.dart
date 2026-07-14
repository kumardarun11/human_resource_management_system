import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isLoading = true;
  bool isActionLoading = false;

  String? error;

  List<dynamic> attendance = [];

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    try {
      final response = await AttendanceService.getHistory();

      if (!mounted) return;

      final rawData = response['data'];

      setState(() {
        if (rawData is List) {
          attendance = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          attendance = rawData['data'];
        } else {
          attendance = [];
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

  Future<void> _performAction({
    required bool checkIn,
  }) async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = checkIn
          ? await AttendanceService.checkIn()
          : await AttendanceService.checkOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message']?.toString() ??
                (checkIn
                    ? 'Checked in successfully.'
                    : 'Checked out successfully.'),
          ),
        ),
      );

      await _loadAttendance();
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      String message = 'Attendance action failed.';

      if (data is Map) {
        message = data['message']?.toString() ?? message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Widget _attendanceCard(dynamic item) {
    final data = Map<String, dynamic>.from(item);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['attendance_date']?.toString() ?? 'Unknown Date',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Check In: ${data['check_in'] ?? 'Not checked in'}',
            ),
            const SizedBox(height: 6),
            Text(
              'Check Out: ${data['check_out'] ?? 'Not checked out'}',
            ),
            const SizedBox(height: 6),
            Text(
              'Status: ${data['status'] ?? 'N/A'}',
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
        title: const Text('Attendance'),
        actions: [
          IconButton(
            onPressed: _loadAttendance,
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

                            _loadAttendance();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAttendance,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'Today Attendance',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Record your daily check-in and check-out.',
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton.icon(
                                onPressed: isActionLoading
                                    ? null
                                    : () {
                                        _performAction(
                                          checkIn: true,
                                        );
                                      },
                                icon: const Icon(Icons.login),
                                label: const Text('Check In'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: isActionLoading
                                    ? null
                                    : () {
                                        _performAction(
                                          checkIn: false,
                                        );
                                      },
                                icon: const Icon(Icons.logout),
                                label: const Text('Check Out'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isActionLoading) ...[
                        const SizedBox(height: 20),
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                      const SizedBox(height: 32),
                      const Text(
                        'Attendance History',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (attendance.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(30),
                          child: Center(
                            child: Text(
                              'No attendance records found.',
                            ),
                          ),
                        )
                      else
                        ...attendance.map(_attendanceCard),
                    ],
                  ),
                ),
    );
  }
}