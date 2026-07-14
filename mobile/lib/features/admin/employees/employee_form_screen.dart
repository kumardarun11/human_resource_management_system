import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'services/employee_service.dart';

class EmployeeFormScreen extends StatefulWidget {
  final int? employeeId;

  const EmployeeFormScreen({
    super.key,
    this.employeeId,
  });

  bool get isEditing => employeeId != null;

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final employeeIdController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final departmentController = TextEditingController();
  final designationController = TextEditingController();

  bool isLoading = false;
  bool isInitialLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      _loadEmployee();
    }
  }

  Future<void> _loadEmployee() async {
    setState(() {
      isInitialLoading = true;
    });

    try {
      final response = await EmployeeService.getEmployee(
        widget.employeeId!,
      );

      final rawData = response['data'];

      if (rawData is! Map) {
        throw Exception('Invalid employee response.');
      }

      final employee = Map<String, dynamic>.from(rawData);

      employeeIdController.text =
          employee['employee_id']?.toString() ?? '';

      nameController.text =
          employee['name']?.toString() ?? '';

      emailController.text =
          employee['email']?.toString() ?? '';

      phoneController.text =
          employee['phone']?.toString() ?? '';

      departmentController.text =
          employee['department_id']?.toString() ?? '';

      designationController.text =
          employee['designation']?.toString() ?? '';
    } finally {
      if (mounted) {
        setState(() {
          isInitialLoading = false;
        });
      }
    }
  }

  int? _departmentId() {
    final value = departmentController.text.trim();

    if (value.isEmpty) return null;

    return int.tryParse(value);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> response;

      if (widget.isEditing) {
        response = await EmployeeService.updateEmployee(
          id: widget.employeeId!,
          employeeId: employeeIdController.text.trim(),
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          departmentId: _departmentId(),
          designation: designationController.text.trim().isEmpty
              ? null
              : designationController.text.trim(),
        );
      } else {
        response = await EmployeeService.createEmployee(
          employeeId: employeeIdController.text.trim(),
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          departmentId: _departmentId(),
          designation: designationController.text.trim().isEmpty
              ? null
              : designationController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message']?.toString() ??
                'Employee saved successfully.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;
      String message = 'Unable to save employee.';

      if (data is Map) {
        message = data['message']?.toString() ?? message;

        final errors = data['errors'];

        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;

          if (first is List && first.isNotEmpty) {
            message = first.first.toString();
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: !isLoading,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (required &&
              (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }

          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    employeeIdController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    designationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Employee' : 'Add Employee',
        ),
      ),
      body: isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _field(
                    controller: employeeIdController,
                    label: 'Employee ID',
                    required: true,
                  ),
                  _field(
                    controller: nameController,
                    label: 'Name',
                    required: true,
                  ),
                  _field(
                    controller: emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    required: true,
                  ),
                  if (!widget.isEditing)
                    _field(
                      controller: passwordController,
                      label: 'Password',
                      obscureText: true,
                      required: true,
                    ),
                  _field(
                    controller: phoneController,
                    label: 'Phone',
                    keyboardType: TextInputType.phone,
                  ),
                  _field(
                    controller: departmentController,
                    label: 'Department ID',
                    keyboardType: TextInputType.number,
                  ),
                  _field(
                    controller: designationController,
                    label: 'Designation',
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _save,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        isLoading
                            ? 'Saving...'
                            : widget.isEditing
                                ? 'Update Employee'
                                : 'Create Employee',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}