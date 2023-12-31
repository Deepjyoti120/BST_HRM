import 'package:bsthrm/app/widget/pdf/salary_slip_create.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class SalarySlip extends StatefulWidget {
  const SalarySlip({super.key});

  @override
  State<SalarySlip> createState() => _SalarySlipState();
}

class _SalarySlipState extends State<SalarySlip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PdfPreview(
        build: (format) => generateSalarySlip(format),
      ),
    );
  }
}
