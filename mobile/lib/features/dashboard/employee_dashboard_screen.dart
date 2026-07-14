import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import '../../core/storage/auth_storage.dart';
import 'services/dashboard_service.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState
    extends State<EmployeeDashboardScreen> {
  bool isLoading = true;
  String? error;
  Map<String, dynamic> dashboardData = {};

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final response =
          await DashboardService.getEmployeeDashboard();

      if (!mounted) return;

      setState(() {
        dashboardData =
            Map<String, dynamic>.from(response['data'] ?? {});
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

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
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

                            _loadDashboard();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDashboard,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Manage your workday from one place.',
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Today Overview',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Attendance: ${dashboardData['attendance_status'] ?? 'Not Checked In'}',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pending Leaves: ${dashboardData['pending_leaves'] ?? 0}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _menuCard(
                        icon: Icons.person_outline,
                        title: 'My Profile',
                        subtitle: 'View and update profile',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.employeeProfile,
                          );
                        },
                      ),
                      _menuCard(
                        icon: Icons.access_time,
                        title: 'Attendance',
                        subtitle: 'Check in, check out and history',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.attendance,
                          );
                        },
                      ),
                      _menuCard(
                        icon: Icons.event_note,
                        title: 'Apply Leave',
                        subtitle: 'Submit a new leave request',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.applyLeave,
                          );
                        },
                      ),
                      _menuCard(
                        icon: Icons.history,
                        title: 'Leave History',
                        subtitle: 'View your leave requests',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.leaveHistory,
                          );
                        },
                      ),
                      _menuCard(
                        icon: Icons.payments_outlined,
                        title: 'Payroll',
                        subtitle: 'View salary and payslips',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.payroll,
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}