// sheikh_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  static Future<Map<String, dynamic>> uploadSheikh({
    required File file,
    required String sheikhName,
    required int surahNumber,
  }) async {
<<<<<<< HEAD
    final uri = Uri.parse('http://192.168.1.10:8000/add_sheikh/');
=======
    final uri = Uri.parse('http://localhost:8000/add_sheikh/');
>>>>>>> e6637369065f3db77b47ec24de01749e4f409915

    var request = http.MultipartRequest('POST', uri)
      ..fields['sheikh_name'] = sheikhName
      ..fields['surah_number'] = surahNumber.toString()
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      return {'success': true, 'message': body};
<<<<<<< HEAD
    } else {
      final body = await response.stream.bytesToString();
      print('Error Body: $body');
=======
    } else if (response.statusCode == 400) {
      return {'success': false, 'message': 'الملف يجب أن يكون بصيغة wav فقط'};
    } else {
>>>>>>> e6637369065f3db77b47ec24de01749e4f409915
      return {'success': false, 'message': 'حدث خطأ أثناء رفع الملف'};
    }
  }
}
