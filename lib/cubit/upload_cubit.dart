// sheikh_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_uploaderapp/cubit/upload_state.dart';
import 'dart:io';

import '../service/upload_service.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(UploadInitial());

  Future<void> uploadSheikh({
    required File file,
    required String sheikhName,
    required int surahNumber,
  }) async {
    emit(UploadLoading());

    try {
      final result = await UploadService.uploadSheikh(
        file: file,
        sheikhName: sheikhName,
        surahNumber: surahNumber,
      );

      if (result['success']) {
        emit(UploadSuccess(result['message']));
      } else {
        emit(UploadFailure(result['message']));
      }
    } catch (e) {
      print('Upload error: $e');
      emit(UploadFailure('خطأ غير متوقع: $e'));
    }
  }
}
