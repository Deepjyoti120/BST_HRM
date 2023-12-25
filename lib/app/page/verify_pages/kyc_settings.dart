import 'package:bsthrm/app/widget/custom_loading.dart';
import 'package:bsthrm/model/key_settings_model.dart';
import 'package:bsthrm/services/api_access.dart';
import 'package:bsthrm/viewmodel/cubit/app_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KycSettings extends StatefulWidget {
  const KycSettings({super.key});

  @override
  State<KycSettings> createState() => _KycSettingsState();
}

class _KycSettingsState extends State<KycSettings> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("KYC Settings"),
      ),
      body: FutureBuilder<KycSettingModel?>(
        future: ApiAccess()
            .kycSettings(employeeId: appState.userDetails!.employeeId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final livedata = snapshot.data;
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // if (livedata!.panVerification == '1')
                Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Pan Verification"),
                        if (livedata!.panVerification == '1')
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Verified",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        else
                          const Row(
                            children: [
                              Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Not Verified",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Pan No: ${livedata!.employeePanVerificationPanNo}"),
                        Text(
                            "Pan Name: ${livedata.employeePanVerificationPanName}"),
                        Image.network(
                          livedata.employeePanCardFile!,
                          //handle error image
                          errorBuilder: (context, error, stackTrace) {
                            return const Row(
                              children: [
                                Icon(Icons.error),
                                SizedBox(width: 4),
                                Text("Image Not Found"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Bank Verification"),
                        if (livedata.bankVerification == '1')
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Verified",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        else
                          const Row(
                            children: [
                              Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Not Verified",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Acc No: ${livedata.employeeBankVerificationAccNo}"),
                        Text("Ifsc: ${livedata.employeeBankVerificationIfsc}"),
                        Text(
                            "Acc Holder Name: ${livedata.employeeBankVerificationAccHolderName}"),
                        Image.network(
                          livedata.employeeBankPassbookFile!,
                          errorBuilder: (context, error, stackTrace) {
                            return const Row(
                              children: [
                                Icon(Icons.error),
                                SizedBox(width: 4),
                                Text("Image Not Found"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Aadhar Verification"),
                        if (livedata.aadharVerification == '1')
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Verified",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        else
                          const Row(
                            children: [
                              Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Not Verified",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Aadhar No: ${livedata.employeeAadharNo}"),
                        Text("Full Name: ${livedata.employeeAadharFullName}"),
                        Text("Dob: ${livedata.employeeAadharDob}"),
                        Text("Country: ${livedata.employeeAadharCountry}"),
                        Text("State: ${livedata.employeeAadharState}"),
                        Text("Po: ${livedata.employeeAadharPo}"),
                        Text("Loc: ${livedata.employeeAadharLoc}"),
                        Text("Street: ${livedata.employeeAadharStreet}"),
                        Text("House: ${livedata.employeeAadharHouse}"),
                        Text("Landmark: ${livedata.employeeAadharLandmark}"),
                        Text("Zip: ${livedata.employeeAadharZip}"),
                        Image.network(
                          livedata.employeeAadharFile!,
                          errorBuilder: (context, error, stackTrace) {
                            return const Row(
                              children: [
                                Icon(Icons.error),
                                SizedBox(width: 4),
                                Text("Image Not Found"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: DLoading(color: Colors.blue),
            );
          }
        },
      ),
    );
  }
}
