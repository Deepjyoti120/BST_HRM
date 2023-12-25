import 'package:bsthrm/app/widget/custom_loading.dart';
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
      body: FutureBuilder(
        future: ApiAccess()
            .kycSettings(employeeId: appState.userDetails!.employeeId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Text("data");
          } else {
            // return Text(appState.userDetails!.employeeId!);
            return const Center(
              child: DLoading(color: Colors.blue),
            );
          }
        },
      ),
    );
  }
}
