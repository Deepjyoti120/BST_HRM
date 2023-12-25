import 'package:bsthrm/app/widget/custom_loading.dart';
import 'package:bsthrm/services/api_access.dart';
import 'package:bsthrm/viewmodel/cubit/app_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AadharVerification extends StatefulWidget {
  const AadharVerification({super.key});

  @override
  State<AadharVerification> createState() => _AadharVerificationState();
}

class _AadharVerificationState extends State<AadharVerification> {
  final _formKey = GlobalKey<FormState>();
  final _aadharNo = TextEditingController();
  bool isLoading = false;
  String aadharRequestId = "";
  String aadharOtp = "";
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aadhar Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _aadharNo,
                enabled: aadharRequestId.isEmpty,
                decoration: const InputDecoration(
                  labelText: "Enter Aadhar Number",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter aadhar number';
                  }
                  return null;
                },
              ),
              if (aadharRequestId.isNotEmpty)
                TextFormField(
                  controller: _aadharNo,
                  decoration: const InputDecoration(
                    labelText: "Enter OTP",
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter otp';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      if (aadharRequestId.isEmpty) {
                        ApiAccess()
                            .getAadharOtp(
                          aadharNo: _aadharNo.text,
                          employeeId: appState.userDetails!.employeeId!,
                        )
                            .then((value) {
                          if (value != null) {
                            aadharRequestId = value;
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        });
                      } else {
                        ApiAccess()
                            .verifyAadhar(
                          aadharNo: _aadharNo.text,
                          employeeId: appState.userDetails!.employeeId!,
                          otp: aadharOtp,
                          requestId: aadharRequestId,
                        )
                            .then((value) {
                          if (value) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        });
                      }
                    }
                  },
                  child: isLoading
                      ? const DLoading()
                      : Text(
                          aadharRequestId.isEmpty ? "Get OTP" : "Verify",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
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
