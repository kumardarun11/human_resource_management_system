import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import 'services/leave_service.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();

  final List<String> leaveTypes = [
    'Paid Leave',
    'Sick Leave',
    'Casual Leave',
    'Emergency Leave',
    'Unpaid Leave',
  ];

  String? selectedLeaveType;
  DateTime? fromDate;
  DateTime? toDate;

  bool isLoading = false;

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> _selectFromDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      fromDate = date;

      if (toDate != null && toDate!.isBefore(date)) {
        toDate = null;
      }
    });
  }

  Future<void> _selectToDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: toDate ?? fromDate ?? DateTime.now(),
      firstDate: fromDate ?? DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      toDate = date;
    });
  }

  Future<void> _applyLeave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedLeaveType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a leave type.'),
        ),
      );

      return;
    }

    if (fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select leave dates.'),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await LeaveService.applyLeave(
        leaveType: selectedLeaveType!,
        fromDate: _formatDate(fromDate!),
        toDate: _formatDate(toDate!),
        reason: reasonController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response['message']?.toString() ??
                'Leave request submitted successfully.',
          ),
        ),
      );

      Navigator.pushReplacementNamed(
        context,
        RouteNames.leaveHistory,
      );
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      String message = 'Unable to submit leave request.';

      if (data is Map) {
        message = data['message']?.toString() ?? message;

        final errors = data['errors'];

        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;

          if (firstError is List && firstError.isNotEmpty) {
            message = firstError.first.toString();
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

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Leave'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'New Leave Request',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Submit your leave request for approval.',
              ),
              const SizedBox(height: 28),

              DropdownButtonFormField<String>(
                initialValue: selectedLeaveType,
                decoration: const InputDecoration(
                  labelText: 'Leave Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event_note),
                ),
                items: leaveTypes
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() {
                          selectedLeaveType = value;
                        });
                      },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a leave type';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              ListTile(
                onTap: isLoading ? null : _selectFromDate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                leading: const Icon(Icons.calendar_today),
                title: const Text('From Date'),
                subtitle: Text(
                  fromDate == null
                      ? 'Select start date'
                      : _formatDate(fromDate!),
                ),
                trailing: const Icon(Icons.arrow_drop_down),
              ),

              const SizedBox(height: 18),

              ListTile(
                onTap: isLoading ? null : _selectToDate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                leading: const Icon(Icons.event_available),
                title: const Text('To Date'),
                subtitle: Text(
                  toDate == null
                      ? 'Select end date'
                      : _formatDate(toDate!),
                ),
                trailing: const Icon(Icons.arrow_drop_down),
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: reasonController,
                enabled: !isLoading,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  hintText: 'Enter reason for leave',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  if (value != null && value.length > 500) {
                    return 'Reason cannot exceed 500 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _applyLeave,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    isLoading
                        ? 'Submitting...'
                        : 'Submit Leave Request',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}