import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/upload_cubit.dart';
import '../cubit/upload_state.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController readerController = TextEditingController();
  final TextEditingController surahController = TextEditingController();
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadCubit(),
      child: BlocConsumer<UploadCubit, UploadState>(
        listener: (context, state) {
          if (state is UploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('✅ ${state.message}')),
            );
          } else if (state is UploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<UploadCubit>();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF0F1D3A),
              centerTitle: true,
              elevation: 4,
              shadowColor: Colors.black26,
              title: Text(
                'رفع ملف صوتي',
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: readerController,
                      decoration: InputDecoration(
                        labelText: 'اسم القارئ',
                        labelStyle: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F1D3A),
                        ),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.person),
                        suffixIconColor: const Color(0xFF0F1D3A),
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Zأ-ي ]')),
                      ],
                    ),
                    SizedBox(height: 16),

                    // حقل رقم السورة
                    TextFormField(
                      controller: surahController,
                      decoration: InputDecoration(
                        labelText: 'رقم السورة',
                        labelStyle: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F1D3A),
                        ),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.format_list_numbered),
                        suffixIconColor: const Color(0xFF0F1D3A),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                    ),
                    SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['wav', 'mp3'],
                        );
                        if (result != null) {
                          String filePath = result.files.single.path!;
                          String ext = filePath.split('.').last.toLowerCase();

                          if (ext == 'wav' || ext == 'mp3') {
                            setState(() => selectedFile = File(filePath));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('⚠️ فقط ملفات WAV أو MP3 مسموح بها!')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27375E),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 3,
                      ),
                      child: Text(
                        'اختر الملف الصوتي',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    if (selectedFile != null) ...[
                      Text('تم اختيار الملف', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(selectedFile!.path.split('/').last),
                      SizedBox(height: 20),
                    ],

                    ElevatedButton(
                      onPressed: state is UploadLoading
                          ? null
                          : () {
                        if (readerController.text.isEmpty ||
                            surahController.text.isEmpty ||
                            selectedFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('رجاءً اكمل كل الحقول واختر ملف')),
                          );
                          return;
                        }
                        cubit.uploadSheikh(
                          file: selectedFile!,
                          sheikhName: readerController.text,
                          surahNumber: int.parse(surahController.text),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27375E),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 3,
                      ),
                      child: state is UploadLoading
                          ? CircularProgressIndicator(color: Color(0xFF27375E))
                          : Text(
                        'تخزين الملف الصوتي',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
