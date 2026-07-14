import 'package:flutter/material.dart';

import 'services/payroll_service.dart';

class PayslipScreen extends StatefulWidget {
  final int payrollId;

  const PayslipScreen({
    super.key,
    required this.payrollId,
  });

  @override
  State<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  bool isLoading = true;
  String? error;

  Map<String, dynamic> payroll = {};

  @override
  void initState() {
    super.initState();
    _loadPayslip();
  }

  Future<void> _loadPayslip() async {
    try {
      final response = await PayrollService.getPayrollById(
        widget.payrollId,
      );

      if (!mounted) return;

      final rawData = response['data'];

      setState(() {
        if (rawData is Map) {
          payroll = Map<String, dynamic>.from(rawData);
        } else {
          payroll = {};
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

  Widget _detailRow(
    String title,
    dynamic value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight:
                    bold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value?.toString() ?? 'N/A',
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
        title: const Text('Payslip'),
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

                            _loadPayslip();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 70,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Salary Payslip',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _detailRow(
                              'Salary Month',
                              payroll['salary_month'] ??
                                  payroll['month'],
                            ),
                            _detailRow(
                              'Basic Salary',
                              '₹${payroll['basic_salary'] ?? '0'}',
                            ),
                            _detailRow(
                              'Bonus',
                              '₹${payroll['bonus'] ?? '0'}',
                            ),
                            _detailRow(
                              'Deductions',
                              '₹${payroll['deductions'] ?? '0'}',
                            ),
                            const Divider(),
                            _detailRow(
                              'Net Salary',
                              '₹${payroll['net_salary'] ?? '0'}',
                              bold: true,
                            ),
                            const Divider(),
                            _detailRow(
                              'Payment Status',
                              payroll['payment_status'] ??
                                  payroll['status'],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}