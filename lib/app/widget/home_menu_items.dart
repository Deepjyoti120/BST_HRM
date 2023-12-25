import 'package:bsthrm/app/page/verify_pages/aadhar_verify.dart';
import 'package:bsthrm/app/page/verify_pages/bank_verify.dart';
import 'package:bsthrm/app/page/verify_pages/kyc_settings.dart';
import 'package:bsthrm/app/page/verify_pages/pan_verify.dart';
import 'package:bsthrm/app/page/verify_pages/upload_documents.dart';
import 'package:flutter/material.dart';

class HomeMenuItems extends StatefulWidget {
  const HomeMenuItems({super.key});

  @override
  State<HomeMenuItems> createState() => _HomeMenuItemsState();
}

class _HomeMenuItemsState extends State<HomeMenuItems> {
  bool arrowUp = false;

  @override
  void dispose() {
    super.dispose();
    arrowUp = false;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        onPressed: () {
          arrowUp = true;
          setState(() {});
          showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(100, 100, 0, 0),
              items: [
                const PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings_rounded,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Pan Verification",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    )),
                const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                        ),
                        SizedBox(width: 4),
                        Text("Bank Verification")
                      ],
                    )),
                const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.verified_rounded),
                        SizedBox(width: 4),
                        Text("KYC Verification")
                      ],
                    )),
              ]).then((value) {
            if (mounted) {
              arrowUp = false;
              setState(() {});
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KycSettings(),
              ),
            );
            if (value != null) {
              if (mounted) {
                if (value == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PanVerification(),
                    ),
                  );
                } else if (value == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BankVerifyVerification(),
                    ),
                  );
                } else if (value == 2) {}
              }
            }
          });
        },
        icon: const Icon(
          Icons.expand_more_rounded,
          size: 18,
        ));
  }
}
