import 'package:bsthrm/app/common/loginpage.dart';
import 'package:bsthrm/app/page/profile/id_card.dart';
import 'package:bsthrm/app/page/salary/salary_slip.dart';
import 'package:bsthrm/app/page/verify_pages/aadhar_verify.dart';
import 'package:bsthrm/app/page/verify_pages/bank_verify.dart';
import 'package:bsthrm/app/page/verify_pages/kyc_settings.dart';
import 'package:bsthrm/app/page/verify_pages/pan_verify.dart';
import 'package:bsthrm/app/page/verify_pages/upload_documents.dart';
import 'package:bsthrm/global/fontstyle.dart';
import 'package:bsthrm/viewmodel/cubit/app_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateCubit>().state;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          appState.userDetails?.employeePhoto! ?? '',
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    Text(
                      appState.userDetails?.employeeName ?? '',
                      style: hsSemiBold.copyWith(
                          fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      "(${appState.userDetails?.employeeDesignation})" ?? '',
                      style: hsSemiBold.copyWith(
                          fontSize: 18, color: Colors.black),
                    ),
                    Text(
                      appState.userDetails?.empid ?? '',
                      style: hsSemiBold.copyWith(
                          fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            children: <Widget>[
              ListTile(
                title: const Text('Pan Verification'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PanVerification(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Bank Verification'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BankVerifyVerification(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Aadhar Verification'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AadharVerification(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Documents Upload'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UploadDocuments(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('KYC Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KycSettings(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Salary Slip'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalarySlip(),
                    ),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              //  show alert dialod for confirm
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            var navigator = Navigator.of(context);
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            debugPrint('All SharedPreferences values removed');
                            navigator.push(MaterialPageRoute(
                              builder: (context) {
                                return const LoginPage();
                              },
                            ));
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
