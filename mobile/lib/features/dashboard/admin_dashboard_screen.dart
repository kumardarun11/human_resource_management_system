import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/storage/auth_storage.dart';
import 'services/dashboard_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {
  bool isLoading = true;
  String? error;
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final response =
          await DashboardService.getAdminDashboard();

      if (!mounted) return;

      setState(() {
        data = Map<String, dynamic>.from(
          response['data'] ?? {},
        );

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

  Future<void> _logout() async {
    await AuthStorage.clear();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
      (route) => false,
    );
  }

  Widget _statCard(String title, dynamic value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              value?.toString() ?? '0',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _menu(
    IconData icon,
    String title,
    String route,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Text(error!),
                )
              : RefreshIndicator(
                  onRefresh: _loadDashboard,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'HRMS Administration',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.5,
                        children: [
                          _statCard(
                            'Employees',
                            data['total_employees'],
                          ),
                          _statCard(
                            'Departments',
                            data['total_departments'],
                          ),
                          _statCard(
                            'Attendance',
                            data['attendance_records'],
                          ),
                          _statCard(
                            'Leave Requests',
                            data['leave_requests'],
                          ),
                          _statCard(
                            'Payroll',
                            data['payroll_records'],
                          ),
                          _statCard(
                            'Present Today',
                            data['present_today'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _menu(
                        Icons.people,
                        'Employee Management',
                        RouteNames.employees,
                      ),
                      _menu(
                        Icons.business,
                        'Departments',
                        RouteNames.departments,
                      ),
                      _menu(
                        Icons.access_time,
                        'Attendance Management',
                        RouteNames.adminAttendance,
                      ),
                      _menu(
                        Icons.event_note,
                        'Leave Requests',
                        RouteNames.leaveRequests,
                      ),
                      _menu(
                        Icons.payments,
                        'Payroll Management',
                        RouteNames.adminPayroll,
                      ),
                    ],
                  ),
                ),
    );
  }
}