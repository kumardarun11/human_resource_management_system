import 'package:flutter/material.dart';

import '../../app/route_names.dart';
import 'services/payroll_service.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  bool isLoading = true;
  String? error;

  List<dynamic> payrollRecords = [];

  @override
  void initState() {
    super.initState();
    _loadPayroll();
  }

  Future<void> _loadPayroll() async {
    try {
      final response = await PayrollService.getPayroll();

      if (!mounted) return;

      final rawData = response['data'];

      setState(() {
        if (rawData is List) {
          payrollRecords = rawData;
        } else if (rawData is Map && rawData['data'] is List) {
          payrollRecords = rawData['data'];
        } else {
          payrollRecords = [];
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

  Widget _payrollCard(dynamic item) {
    final payroll = Map<String, dynamic>.from(item);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final id = payroll['id'];

          if (id == null) {
            return;
          }

          Navigator.pushNamed(
            context,
            RouteNames.payslip,
            arguments: id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(
                      Icons.payments_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      payroll['salary_month']?.toString() ??
                          payroll['month']?.toString() ??
                          'Payroll',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _salaryRow(
                'Basic Salary',
                payroll['basic_salary'],
              ),
              _salaryRow(
                'Bonus',
                payroll['bonus'],
              ),
              _salaryRow(
                'Deductions',
                payroll['deductions'],
              ),
              const Divider(height: 24),
              _salaryRow(
                'Net Salary',
                payroll['net_salary'],
                bold: true,
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${payroll['payment_status'] ?? payroll['status'] ?? 'N/A'}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _salaryRow(
    String title,
    dynamic value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight:
                    bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '₹${value ?? '0'}',
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll'),
        actions: [
          IconButton(
            onPressed: _loadPayroll,
            icon: const Icon(
              Icons.refresh,
            ),
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

                            _loadPayroll();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPayroll,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'My Payroll',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${payrollRecords.length} payroll record(s)',
                      ),
                      const SizedBox(height: 24),
                      if (payrollRecords.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 60,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 70,
                              ),
                              SizedBox(height: 18),
                              Text(
                                'No payroll records found.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your payroll records will appear here.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ...payrollRecords.map(_payrollCard),
                    ],
                  ),
                ),
    );
  }
}