import 'package:bsthrm/app/widget/custom_loading.dart';
import 'package:bsthrm/services/api_access.dart';
import 'package:bsthrm/viewmodel/cubit/app_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BankVerifyVerification extends StatefulWidget {
  const BankVerifyVerification({super.key});

  @override
  State<BankVerifyVerification> createState() => _BankVerifyVerificationState();
}

class _BankVerifyVerificationState extends State<BankVerifyVerification> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumber = TextEditingController();
  final _ifscCode = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _accountNumber,
                decoration: const InputDecoration(
                  labelText: "Enter Account Number",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ifscCode,
                decoration: const InputDecoration(
                  labelText: "Enter IFSC Code",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IFSC code';
                  }
                  return null;
                },
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
                      ApiAccess()
                          .verifyBank(
                        employeeId: appState.userDetails!.employeeId!,
                        accNo: _accountNumber.text,
                        ifsc: _ifscCode.text,
                      )
                          .then((value) {
                        if (value) {
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            isLoading = false;
                            _accountNumber.text = "";
                            _ifscCode.text = "";
                          });
                        }
                      });
                    }
                  },
                  child: isLoading
                      ? const DLoading()
                      : const Text(
                          "Verify",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
