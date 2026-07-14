import 'package:flutter/material.dart';

import 'services/profile_service.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() =>
      _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState
    extends State<EmployeeProfileScreen> {
  bool isLoading = true;
  String? error;

  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await ProfileService.getProfile();

      if (!mounted) return;

      setState(() {
        user = Map<String, dynamic>.from(
          response['data'] ??
              response['user'] ??
              response['profile'] ??
              {},
        );

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

  Widget _profileItem(
    IconData icon,
    String title,
    dynamic value,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          value?.toString().isNotEmpty == true
              ? value.toString()
              : 'Not provided',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: _loadProfile,
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

                            _loadProfile();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadProfile,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          size: 55,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user['name']?.toString() ?? 'Employee',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['designation']?.toString() ??
                            'Employee',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _profileItem(
                        Icons.badge_outlined,
                        'Employee ID',
                        user['employee_id'],
                      ),
                      _profileItem(
                        Icons.email_outlined,
                        'Email',
                        user['email'],
                      ),
                      _profileItem(
                        Icons.phone_outlined,
                        'Phone',
                        user['phone'],
                      ),
                      _profileItem(
                        Icons.business_outlined,
                        'Department',
                        user['department'] is Map
                            ? user['department']['department_name']
                            : null,
                      ),
                      _profileItem(
                        Icons.work_outline,
                        'Designation',
                        user['designation'],
                      ),
                      _profileItem(
                        Icons.calendar_today_outlined,
                        'Joining Date',
                        user['joining_date'],
                      ),
                      _profileItem(
                        Icons.location_on_outlined,
                        'Address',
                        user['address'],
                      ),
                      _profileItem(
                        Icons.location_city,
                        'City',
                        user['city'],
                      ),
                      _profileItem(
                        Icons.public,
                        'Country',
                        user['country'],
                      ),
                    ],
                  ),
                ),
    );
  }
}