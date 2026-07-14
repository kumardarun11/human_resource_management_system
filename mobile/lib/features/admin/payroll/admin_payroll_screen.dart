import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'services/admin_payroll_service.dart';

class AdminPayrollScreen extends StatefulWidget {
  const AdminPayrollScreen({super.key});

  @override
  State<AdminPayrollScreen> createState() => _AdminPayrollScreenState();
}

class _AdminPayrollScreenState extends State<AdminPayrollScreen> {
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
      final response = await AdminPayrollService.getPayrollRecords();

      final rawData = response['data'];

      if (!mounted) return;

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
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      setState(() {
        error = data is Map
            ? data['message']?.toString() ?? 'Unable to load payroll.'
            : 'Unable to load payroll.';

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

  String _employeeName(Map<String, dynamic> payroll) {
    final user = payroll['user'];

    if (user is Map) {
      return user['name']?.toString() ?? 'Employee';
    }

    final employee = payroll['employee'];

    if (employee is Map) {
      return employee['name']?.toString() ?? 'Employee';
    }

    return 'Employee';
  }

  String _employeeId(Map<String, dynamic> payroll) {
    final user = payroll['user'];

    if (user is Map) {
      return user['employee_id']?.toString() ?? 'N/A';
    }

    final employee = payroll['employee'];

    if (employee is Map) {
      return employee['employee_id']?.toString() ?? 'N/A';
    }

    return 'N/A';
  }

  Widget _salaryRow(String title, dynamic value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '₹${value ?? '0'}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPayrollDetails(int id) async {
    try {
      final response = await AdminPayrollService.getPayrollById(id);

      final rawData = response['data'];

      if (!mounted) return;

      if (rawData is! Map) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payroll details are unavailable.')),
        );

        return;
      }

      final payroll = Map<String, dynamic>.from(rawData);

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Payroll Details'),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _employeeName(payroll),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(_employeeId(payroll)),
                    const Divider(height: 28),
                    _salaryRow('Basic Salary', payroll['basic_salary']),
                    _salaryRow('House Allowance', payroll['house_allowance']),
                    _salaryRow(
                      'Medical Allowance',
                      payroll['medical_allowance'],
                    ),
                    _salaryRow(
                      'Transport Allowance',
                      payroll['transport_allowance'],
                    ),
                    _salaryRow('Bonus', payroll['bonus']),
                    _salaryRow('Overtime', payroll['overtime']),

                    const Divider(height: 24),

                    _salaryRow(
                      'Gross Salary',
                      payroll['gross_salary'],
                      bold: true,
                    ),

                    const Divider(height: 24),

                    _salaryRow('Tax', payroll['tax']),
                    _salaryRow('Provident Fund', payroll['provident_fund']),
                    _salaryRow('Other Deductions', payroll['other_deductions']),

                    const Divider(height: 24),

                    _salaryRow('Net Salary', payroll['net_salary'], bold: true),
                    const SizedBox(height: 16),
                    Text(
                      'Payroll Month & Year: '
                      '${payroll['payroll_month'] ?? 'N/A'} '
                      '${payroll['payroll_year'] ?? ''}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Payment Status: '
                      '${payroll['payment_status'] ?? payroll['status'] ?? 'N/A'}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Payment Date: '
                      '${payroll['payment_date'] ?? 'N/A'}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Payment Method: '
                      '${payroll['payment_method'] ?? 'N/A'}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Remarks: '
                      '${payroll['remarks'] ?? 'N/A'}',
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } on DioException catch (e) {
      if (!mounted) return;

      final data = e.response?.data;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data is Map
                ? data['message']?.toString() ??
                      'Unable to load payroll details.'
                : 'Unable to load payroll details.',
          ),
        ),
      );
    }
  }

  Widget _payrollCard(dynamic item) {
    final payroll = Map<String, dynamic>.from(item);

    final id = int.tryParse(payroll['id']?.toString() ?? '');

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: id != null
            ? () {
                _showPayrollDetails(id);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.payments_outlined)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _employeeName(payroll),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(_employeeId(payroll)),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(
                      payroll['payment_status']?.toString() ??
                          payroll['status']?.toString() ??
                          'N/A',
                    ),
                  ),
                ],
              ),
              const Divider(height: 28),
              Text(
                '${payroll['payroll_month'] ?? 'N/A'} ${payroll['payroll_year'] ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _salaryRow('Basic Salary', payroll['basic_salary']),
              _salaryRow('Bonus', payroll['bonus']),
              _salaryRow('Tax', payroll['tax']),
              _salaryRow('Provident Fund', payroll['provident_fund']),
              _salaryRow('Other Deductions', payroll['other_deductions']),
              const Divider(height: 24),
              _salaryRow('Net Salary', payroll['net_salary'], bold: true),
              const SizedBox(height: 8),
              const Text('Tap to view details', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openCreatePayroll() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const _CreatePayrollDialog(),
    );

    if (!mounted) return;

    if (created == true) {
      setState(() {
        isLoading = true;
        error = null;
      });

      await _loadPayroll();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payroll created successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll Management'),
        actions: [
          IconButton(onPressed: _loadPayroll, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreatePayroll,
        icon: const Icon(Icons.add),
        label: const Text('Create Payroll'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 60),
                    const SizedBox(height: 16),
                    Text(error!, textAlign: TextAlign.center),
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
              child: payrollRecords.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 180),
                        Icon(Icons.receipt_long_outlined, size: 70),
                        SizedBox(height: 16),
                        Center(child: Text('No payroll records found.')),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: payrollRecords.length,
                      itemBuilder: (context, index) {
                        return _payrollCard(payrollRecords[index]);
                      },
                    ),
            ),
    );
  }
}

class _CreatePayrollDialog extends StatefulWidget {
  const _CreatePayrollDialog();

  @override
  State<_CreatePayrollDialog> createState() => _CreatePayrollDialogState();
}

class _CreatePayrollDialogState extends State<_CreatePayrollDialog> {
  final _formKey = GlobalKey<FormState>();

  final basicSalaryController = TextEditingController();

  final houseAllowanceController = TextEditingController(text: '0');

  final medicalAllowanceController = TextEditingController(text: '0');

  final transportAllowanceController = TextEditingController(text: '0');

  final bonusController = TextEditingController(text: '0');

  final overtimeController = TextEditingController(text: '0');

  final taxController = TextEditingController(text: '0');

  final providentFundController = TextEditingController(text: '0');

  final otherDeductionsController = TextEditingController(text: '0');

  final paymentDateController = TextEditingController();

  final paymentMethodController = TextEditingController();

  final remarksController = TextEditingController();

  String payrollMonth = 'July';
  int payrollYear = 2026;
  String paymentStatus = 'Pending';

  DateTime? selectedPaymentDate;

  List<Map<String, dynamic>> employees = [];

  int? selectedEmployeeId;

  bool isLoadingEmployees = true;
  bool isSaving = false;

  String? employeeLoadError;

  static const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  @override
  void initState() {
    super.initState();

    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final response = await AdminPayrollService.getEmployees();

      final data = response['data'];

      final loadedEmployees = data is List
          ? data
                .whereType<Map>()
                .map((employee) => Map<String, dynamic>.from(employee))
                .where(
                  (employee) =>
                      employee['role']?.toString().toLowerCase() == 'employee',
                )
                .toList()
          : <Map<String, dynamic>>[];

      if (!mounted) return;

      setState(() {
        employees = loadedEmployees;

        isLoadingEmployees = false;
        employeeLoadError = null;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingEmployees = false;

        employeeLoadError =
            e.response?.data?['message']?.toString() ??
            'Unable to load employees.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingEmployees = false;

        employeeLoadError = 'Unable to load employees.';
      });
    }
  }

  @override
  void dispose() {
    basicSalaryController.dispose();

    houseAllowanceController.dispose();
    medicalAllowanceController.dispose();
    transportAllowanceController.dispose();

    bonusController.dispose();
    overtimeController.dispose();

    taxController.dispose();
    providentFundController.dispose();
    otherDeductionsController.dispose();

    paymentDateController.dispose();
    paymentMethodController.dispose();
    remarksController.dispose();

    super.dispose();
  }

  double _number(TextEditingController controller) {
    return double.tryParse(controller.text.trim()) ?? 0;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> _selectPaymentDate() async {
    FocusScope.of(context).unfocus();

    final initialDate = selectedPaymentDate ?? DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Payment Date',
      confirmText: 'SELECT',
      cancelText: 'CANCEL',
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      selectedPaymentDate = pickedDate;

      paymentDateController.text = _formatDate(pickedDate);
    });
  }

  String _errorMessage(dynamic data) {
    if (data is! Map) {
      return 'Unable to create payroll.';
    }

    final errors = data['errors'];

    if (errors is Map && errors.isNotEmpty) {
      final firstError = errors.values.first;

      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }

      return firstError.toString();
    }

    return data['message']?.toString() ?? 'Unable to create payroll.';
  }

  Future<void> _createPayroll() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (selectedEmployeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an employee.')),
      );

      return;
    }
    if (paymentStatus == 'Paid' && selectedPaymentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a payment date for paid payroll.'),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await AdminPayrollService.createPayroll(
        userId: selectedEmployeeId!,
        payrollMonth: payrollMonth,
        payrollYear: payrollYear,
        basicSalary: _number(basicSalaryController),
        houseAllowance: _number(houseAllowanceController),
        medicalAllowance: _number(medicalAllowanceController),
        transportAllowance: _number(transportAllowanceController),
        bonus: _number(bonusController),
        overtime: _number(overtimeController),
        tax: _number(taxController),
        providentFund: _number(providentFundController),
        otherDeductions: _number(otherDeductionsController),
        paymentStatus: paymentStatus,
        paymentDate: paymentDateController.text.trim().isEmpty
            ? null
            : paymentDateController.text.trim(),
        paymentMethod: paymentMethodController.text.trim().isEmpty
            ? null
            : paymentMethodController.text.trim(),
        remarks: remarksController.text.trim().isEmpty
            ? null
            : remarksController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage(e.response?.data))));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to create payroll: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget _moneyField(
    String label,
    TextEditingController controller, {
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !isSaving,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, prefixText: '₹ '),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return '$label is required';
        }

        if (value != null && value.trim().isNotEmpty) {
          final amount = double.tryParse(value.trim());

          if (amount == null) {
            return 'Enter a valid amount';
          }

          if (amount < 0) {
            return 'Amount cannot be negative';
          }
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Payroll'),
      content: SizedBox(
        width: 550,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoadingEmployees)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Loading employees...'),
                      ],
                    ),
                  )
                else if (employeeLoadError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          employeeLoadError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: isSaving
                              ? null
                              : () {
                                  setState(() {
                                    isLoadingEmployees = true;
                                    employeeLoadError = null;
                                  });

                                  _loadEmployees();
                                },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry Employees'),
                        ),
                      ],
                    ),
                  )
                else
                  DropdownButtonFormField<int>(
                    initialValue: selectedEmployeeId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Employee',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    hint: const Text('Select employee'),
                    items: employees
                        .map((employee) {
                          final id = int.tryParse(
                            employee['id']?.toString() ?? '',
                          );

                          if (id == null) {
                            return null;
                          }

                          final name =
                              employee['name']?.toString() ??
                              'Unknown Employee';

                          final employeeId =
                              employee['employee_id']?.toString() ??
                              'No Employee ID';

                          return DropdownMenuItem<int>(
                            value: id,
                            child: Text(
                              '$name — $employeeId',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        })
                        .whereType<DropdownMenuItem<int>>()
                        .toList(),
                    onChanged: isSaving
                        ? null
                        : (value) {
                            setState(() {
                              selectedEmployeeId = value;
                            });
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Select an employee';
                      }

                      return null;
                    },
                  ),

                DropdownButtonFormField<String>(
                  initialValue: payrollMonth,
                  decoration: const InputDecoration(labelText: 'Payroll Month'),
                  items: months
                      .map(
                        (month) =>
                            DropdownMenuItem(value: month, child: Text(month)),
                      )
                      .toList(),
                  onChanged: isSaving
                      ? null
                      : (value) {
                          if (value == null) return;

                          setState(() {
                            payrollMonth = value;
                          });
                        },
                ),

                TextFormField(
                  initialValue: payrollYear.toString(),
                  enabled: !isSaving,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Payroll Year'),
                  validator: (value) {
                    final year = int.tryParse(value?.trim() ?? '');

                    if (year == null) {
                      return 'Enter a valid payroll year';
                    }

                    if (year < 2000 || year > 2100) {
                      return 'Enter a year between 2000 and 2100';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    final year = int.tryParse(value.trim());

                    if (year != null) {
                      payrollYear = year;
                    }
                  },
                ),

                const SizedBox(height: 12),

                _moneyField(
                  'Basic Salary',
                  basicSalaryController,
                  required: true,
                ),

                _moneyField('House Allowance', houseAllowanceController),

                _moneyField('Medical Allowance', medicalAllowanceController),

                _moneyField(
                  'Transport Allowance',
                  transportAllowanceController,
                ),

                _moneyField('Bonus', bonusController),

                _moneyField('Overtime', overtimeController),

                const Divider(height: 32),

                _moneyField('Tax', taxController),

                _moneyField('Provident Fund', providentFundController),

                _moneyField('Other Deductions', otherDeductionsController),

                const Divider(height: 32),

                DropdownButtonFormField<String>(
                  initialValue: paymentStatus,
                  decoration: const InputDecoration(
                    labelText: 'Payment Status',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                    DropdownMenuItem(
                      value: 'Cancelled',
                      child: Text('Cancelled'),
                    ),
                  ],
                  onChanged: isSaving
                      ? null
                      : (value) {
                          if (value == null) return;

                          setState(() {
                            paymentStatus = value;
                          });

                          if (value == 'Paid' && selectedPaymentDate == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;

                              _selectPaymentDate();
                            });
                          }
                        },
                ),

                TextFormField(
                  controller: paymentDateController,
                  readOnly: true,
                  enabled: !isSaving,
                  decoration: InputDecoration(
                    labelText: 'Payment Date',
                    hintText: 'Select payment date',
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                    suffixIcon: selectedPaymentDate != null
                        ? IconButton(
                            tooltip: 'Clear payment date',
                            onPressed: isSaving
                                ? null
                                : () {
                                    setState(() {
                                      selectedPaymentDate = null;
                                      paymentDateController.clear();
                                    });
                                  },
                            icon: const Icon(Icons.clear),
                          )
                        : const Icon(Icons.arrow_drop_down),
                  ),
                  onTap: isSaving ? null : _selectPaymentDate,
                ),

                TextFormField(
                  controller: paymentMethodController,
                  enabled: !isSaving,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    hintText: 'Bank Transfer',
                  ),
                ),

                TextFormField(
                  controller: remarksController,
                  enabled: !isSaving,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Remarks'),
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
          onPressed: isSaving || isLoadingEmployees || employees.isEmpty
              ? null
              : _createPayroll,
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
