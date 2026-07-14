import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../app/route_names.dart';
import 'services/employee_service.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  bool isLoading = true;
  String? error;
  List<dynamic> employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final response = await EmployeeService.getEmployees();
      final rawData = response['data'];

      if (!mounted) return;

      setState(() {
        if (rawData is List) {
          employees = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          employees = rawData['data'];
        } else {
          employees = [];
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

  Future<void> _deleteEmployee(Map<String, dynamic> employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text(
            'Delete ${employee['name'] ?? 'this employee'}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final response = await EmployeeService.deleteEmployee(
        employee['id'] as int,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message']?.toString() ??
                'Employee deleted successfully.',
          ),
        ),
      );

      await _loadEmployees();
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data is Map
                ? data['message']?.toString() ?? 'Delete failed.'
                : 'Delete failed.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            onPressed: _loadEmployees,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            RouteNames.addEmployee,
          );

          if (result == true) {
            _loadEmployees();
          }
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Employee'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: ElevatedButton(
                    onPressed: _loadEmployees,
                    child: Text('Retry\n$error'),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadEmployees,
                  child: employees.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 180),
                            Icon(Icons.people_outline, size: 70),
                            SizedBox(height: 16),
                            Center(
                              child: Text('No employees found.'),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            100,
                          ),
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            final employee =
                                Map<String, dynamic>.from(
                              employees[index],
                            );

                            final department = employee['department'];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  employee['name']?.toString() ??
                                      'Employee',
                                ),
                                subtitle: Text(
                                  '${employee['employee_id'] ?? 'N/A'}\n'
                                  '${employee['designation'] ?? 'No designation'}'
                                  '${department is Map ? '\n${department['department_name'] ?? ''}' : ''}',
                                ),
                                isThreeLine: true,
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      final result =
                                          await Navigator.pushNamed(
                                        context,
                                        RouteNames.editEmployee,
                                        arguments: employee['id'],
                                      );

                                      if (result == true) {
                                        _loadEmployees();
                                      }
                                    }

                                    if (value == 'delete') {
                                      _deleteEmployee(employee);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
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