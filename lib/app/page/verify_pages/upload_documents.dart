import 'dart:convert';
import 'dart:typed_data';

import 'package:bsthrm/app/widget/custom_loading.dart';
import 'package:bsthrm/services/api_access.dart';
import 'package:bsthrm/viewmodel/cubit/app_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // base 64 string
  String aadharCard = "";
  String bankPassbook = "";
  String panCard = "";

  final ImagePicker _picker = ImagePicker();

  Future<String?> _takePictureAndConvertToBase64() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage != null) {
        final img.Image resizedImage =
            img.copyResize(originalImage, width: originalImage.width ~/ 2);
        final img.PngEncoder encoder = img.PngEncoder(level: 1);
        final List<int> resizedBytes = encoder.encodeImage(resizedImage);
        final Uint8List resizedUint8List = Uint8List.fromList(resizedBytes);
        // setState(() {
        //   _imageBytes = resizedUint8List;
        // });
        return base64Encode(resizedUint8List);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Documents Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // add Photo picker container
              GestureDetector(
                onTap: () async {
                  final base64 = await _takePictureAndConvertToBase64();
                  if (base64 != null) {
                    setState(() {
                      aadharCard = base64;
                    });
                  }
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Aadhar Card"),
                      const SizedBox(height: 10),
                      aadharCard.isEmpty
                          ? const Icon(Icons.add_a_photo)
                          : Image.memory(
                              base64Decode(aadharCard),
                              height: 100,
                              width: 100,
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final base64 = await _takePictureAndConvertToBase64();
                  if (base64 != null) {
                    setState(() {
                      bankPassbook = base64;
                    });
                  }
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Bank Passbook"),
                      const SizedBox(height: 10),
                      bankPassbook.isEmpty
                          ? const Icon(Icons.add_a_photo)
                          : Image.memory(
                              base64Decode(bankPassbook),
                              height: 100,
                              width: 100,
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final base64 = await _takePictureAndConvertToBase64();
                  if (base64 != null) {
                    setState(() {
                      panCard = base64;
                    });
                  }
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Pan Card"),
                      const SizedBox(height: 10),
                      panCard.isEmpty
                          ? const Icon(Icons.add_a_photo)
                          : Image.memory(
                              base64Decode(panCard),
                              height: 100,
                              width: 100,
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
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
                          .uploadDocuments(
                        aadharCard: aadharCard,
                        bankPassbook: bankPassbook,
                        panCard: panCard,
                        employeeId: appState.userDetails!.employeeId!,
                      )
                          .then((value) {
                        if (value) {
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            isLoading = false;
                            aadharCard = "";
                            bankPassbook = "";
                            panCard = "";
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
