import 'package:bsthrm/app/widget/pdf/salary_slip_create.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
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
      // body: PdfPreview(
      //   build: (format) => generateSalarySlip(PdfPageFormat.a4),
      // ),
      // add button to download unit8List pdf
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await Printing.sharePdf(
                  bytes: await generateSalarySlip(PdfPageFormat.a4),
                  filename: 'my-document.pdf',
                );
              },
              child: Text("data"))
        ],
      ),
    );
  }
}
