import 'package:bsthrm/app/widget/pdf/salary_slip_create.dart';
import 'package:bsthrm/services/api_access.dart';
import 'package:bsthrm/viewmodel/cubit/app_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class SalarySlip extends StatefulWidget {
  const SalarySlip({super.key});

  @override
  State<SalarySlip> createState() => _SalarySlipState();
}

class _SalarySlipState extends State<SalarySlip> {
  // all bool for loading listview builder

  List<bool> _loading = [];
  @override
  Widget build(BuildContext context) {
    final userDetails = context.read<AppStateCubit>().userDetails;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salary Slip"),
      ),
      // body: Column(
      //   children: [
      //     ElevatedButton(
      //       onPressed: () async {
      //         await Printing.sharePdf(
      //           bytes: await generateSalarySlip(PdfPageFormat.a4),
      //           filename: 'my-document.pdf',
      //         );
      //       },
      //       child: Text("data"),
      //     )
      //   ],
      // ),
      // body with future builder with progress circular indicator
      body: FutureBuilder(
        future:
            ApiAccess().salaryListByMonth(employeeId: userDetails!.employeeId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            if (snap?.isEmpty ?? true) {
              return const Center(
                child: Text("No data found"),
              );
            }
            return ListView.builder(
              itemCount: snap?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final livedata = snap?[index];
                _loading.add(false);
                return Card(
                  child: ListTile(
                    title: Text(livedata?.month ?? ""),
                    subtitle: Text(livedata?.year ?? ""),
                    // title: const Text("Month"),
                    // subtitle: const Text("Year"),
                    trailing: ElevatedButton(
                      // colors green
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        setState(() {
                          _loading[index] = true;
                        });
                        final salaryDetails = await ApiAccess()
                            .fetchSalaryDetails(
                                employeeId: userDetails.employeeId!,
                                salaryDate: livedata?.salaryDate ?? "");
                        final pdf = await generateSalarySlip(PdfPageFormat.a4,
                            salaryDetails!, livedata!.salaryDate);
                        if (pdf != null) {
                          String namePdf =
                              '${livedata.month!}${livedata.year!}${userDetails.employeeId!}.pdf';
                          await Printing.sharePdf(
                            bytes: pdf,
                            // filename: livedata?.month ??
                            //     "" +
                            //         (livedata!.year ?? '') +
                            //         (userDetails.employeeId ?? '') +
                            //         '.pdf',
                            filename: namePdf,
                          );
                        }
                        setState(() {
                          _loading[index] = false;
                        });
                      },
                      child: _loading[index]
                          ? const SizedBox(
                              height: 14,
                              width: 14,
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : const Text(
                              "Download",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }
}
