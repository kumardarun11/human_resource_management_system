import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'services/admin_attendance_service.dart';

class AdminAttendanceScreen extends StatefulWidget {
  const AdminAttendanceScreen({super.key});

  @override
  State<AdminAttendanceScreen> createState() =>
      _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState
    extends State<AdminAttendanceScreen> {
  bool isLoading = true;
  String? error;

  List<dynamic> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    try {
      final response =
          await AdminAttendanceService.getAttendanceRecords();

      final rawData = response['data'];

      if (!mounted) return;

      setState(() {
        if (rawData is List) {
          attendanceRecords = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          attendanceRecords = rawData['data'];
        } else {
          attendanceRecords = [];
        }

        isLoading = false;
        error = null;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      setState(() {
        error = data is Map
            ? data['message']?.toString() ??
                'Unable to load attendance.'
            : 'Unable to load attendance.';

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  String _employeeName(Map<String, dynamic> attendance) {
    final user = attendance['user'];

    if (user is Map) {
      return user['name']?.toString() ?? 'Employee';
    }

    final employee = attendance['employee'];

    if (employee is Map) {
      return employee['name']?.toString() ?? 'Employee';
    }

    return 'Employee';
  }

  String _employeeId(Map<String, dynamic> attendance) {
    final user = attendance['user'];

    if (user is Map) {
      return user['employee_id']?.toString() ?? 'N/A';
    }

    final employee = attendance['employee'];

    if (employee is Map) {
      return employee['employee_id']?.toString() ?? 'N/A';
    }

    return 'N/A';
  }

  Widget _detailRow(
    String label,
    dynamic value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceCard(dynamic item) {
    final attendance = Map<String, dynamic>.from(item);

    final status =
        attendance['status']?.toString() ?? 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        _employeeName(attendance),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _employeeId(attendance),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(status),
                ),
              ],
            ),
            const Divider(height: 28),
            _detailRow(
              'Date',
              attendance['attendance_date'] ??
                  attendance['date'],
            ),
            _detailRow(
              'Check In',
              attendance['check_in'],
            ),
            _detailRow(
              'Check Out',
              attendance['check_out'],
            ),
            _detailRow(
              'Work Hours',
              attendance['working_hours'] ??
                  attendance['work_hours'],
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
        title: const Text('Attendance Management'),
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
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
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
                  child: attendanceRecords.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 180),
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 70,
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: Text(
                                'No attendance records found.',
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: attendanceRecords.length,
                          itemBuilder: (context, index) {
                            return _attendanceCard(
                              attendanceRecords[index],
                            );
                          },
                        ),
                ),
    );
  }
}