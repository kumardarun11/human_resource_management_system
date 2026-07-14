import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'services/department_service.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  bool isLoading = true;
  String? error;

  List<dynamic> departments = [];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      final response = await DepartmentService.getDepartments();
      final rawData = response['data'];

      if (!mounted) return;

      setState(() {
        if (rawData is List) {
          departments = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          departments = rawData['data'];
        } else {
          departments = [];
        }

        isLoading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  Future<void> _addDepartment() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const _AddDepartmentDialog(),
    );

    if (!mounted) return;

    if (created == true) {
      await _loadDepartments();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Department created successfully.'),
        ),
      );
    }
  }

  Future<void> _deleteDepartment(
    Map<String, dynamic> department,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Department'),
          content: Text(
            'Delete ${department['department_name'] ?? 'this department'}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await DepartmentService.deleteDepartment(
        department['id'] as int,
      );

      if (!mounted) return;

      await _loadDepartments();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Department deleted successfully.'),
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _extractErrorMessage(
              data,
              fallback: 'Unable to delete department.',
            ),
          ),
        ),
      );
    }
  }

  static String _extractErrorMessage(
    dynamic data, {
    required String fallback,
  }) {
    if (data is! Map) {
      return fallback;
    }

    final errors = data['errors'];

    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;

      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }

      return firstError.toString();
    }

    return data['message']?.toString() ?? fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departments'),
        actions: [
          IconButton(
            onPressed: _loadDepartments,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDepartment,
        icon: const Icon(Icons.add_business),
        label: const Text('Add Department'),
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

                            _loadDepartments();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadDepartments,
                  child: departments.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 180),
                            Icon(
                              Icons.business_outlined,
                              size: 70,
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: Text(
                                'No departments found.',
                              ),
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
                          itemCount: departments.length,
                          itemBuilder: (context, index) {
                            final department =
                                Map<String, dynamic>.from(
                              departments[index],
                            );

                            return Card(
                              margin: const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.business),
                                ),
                                title: Text(
                                  department['department_name']
                                          ?.toString() ??
                                      'Department',
                                ),
                                subtitle: Text(
                                  '${department['department_code'] ?? 'N/A'}\n'
                                  '${department['status'] ?? 'N/A'}',
                                ),
                                isThreeLine: true,
                                trailing: IconButton(
                                  onPressed: () {
                                    _deleteDepartment(department);
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}

class _AddDepartmentDialog extends StatefulWidget {
  const _AddDepartmentDialog();

  @override
  State<_AddDepartmentDialog> createState() =>
      _AddDepartmentDialogState();
}

class _AddDepartmentDialogState
    extends State<_AddDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  String status = 'Active';

  bool isSaving = false;

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  String _errorMessage(dynamic data) {
    if (data is! Map) {
      return 'Unable to create department.';
    }

    final errors = data['errors'];

    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;

      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }

      return firstError.toString();
    }

    return data['message']?.toString() ??
        'Unable to create department.';
  }

  Future<void> _createDepartment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await DepartmentService.createDepartment(
        departmentCode: codeController.text.trim(),
        departmentName: nameController.text.trim(),
        email: emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        status: status,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _errorMessage(data),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to create department: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Department'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: codeController,
                  enabled: !isSaving,
                  decoration: const InputDecoration(
                    labelText: 'Department Code',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Department code is required';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: nameController,
                  enabled: !isSaving,
                  decoration: const InputDecoration(
                    labelText: 'Department Name',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Department name is required';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  enabled: !isSaving,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: phoneController,
                  enabled: !isSaving,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  enabled: !isSaving,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Active',
                      child: Text('Active'),
                    ),
                    DropdownMenuItem(
                      value: 'Inactive',
                      child: Text('Inactive'),
                    ),
                  ],
                  onChanged: isSaving
                      ? null
                      : (value) {
                          if (value == null) return;

                          setState(() {
                            status = value;
                          });
                        },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving
              ? null
              : () {
                  Navigator.pop(context, false);
                },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: isSaving
              ? null
              : _createDepartment,
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}