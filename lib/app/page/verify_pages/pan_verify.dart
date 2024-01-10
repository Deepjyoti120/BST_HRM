import 'package:bsthrm/app/widget/custom_loading.dart';
import 'package:bsthrm/services/api_access.dart';
import 'package:bsthrm/viewmodel/cubit/app_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanVerification extends StatefulWidget {
  const PanVerification({super.key});

  @override
  State<PanVerification> createState() => _PanVerificationState();
}

class _PanVerificationState extends State<PanVerification> {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  bool isLoading = false;
  bool isVerified = true;
  bool isScreenLoading = true;

  @override
  void initState() {
    super.initState();
    setPanNumber();
  }

  setPanNumber() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appState = context.read<AppStateCubit>();
      _panController.text = appState.userDetails!.employeePan!;
      await ApiAccess()
          .kycSettings(employeeId: appState.userDetails!.employeeId!)
          .then((value) {
        if (value!.panVerification == '1') {
          setState(() {
            isVerified = true;
          });
        } else {
          setState(() {
            isVerified = false;
          });
        }
      });
      setState(() {
        isScreenLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pan Verification"),
      ),
      body: isScreenLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _panController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Enter Pan Number",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pan number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isVerified ? Colors.green : Colors.black,
                        ),
                        onPressed: () async {
                          if (isVerified) {
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            ApiAccess()
                                .verifyPan(
                              panNo: _panController.text,
                              employeeId: appState.userDetails!.employeeId!,
                            )
                                .then((value) {
                              if (value) {
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _panController.text = "";
                                  isLoading = false;
                                });
                              }
                            });
                          }
                        },
                        child: isLoading
                            ? const DLoading()
                            : Text(
                                isVerified ? "Verified" : "Verify",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: isVerified
                                        ? Colors.white
                                        : Colors.white),
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
