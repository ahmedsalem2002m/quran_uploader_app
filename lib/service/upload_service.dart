import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  static Future<Map<String, dynamic>> uploadSheikh({
    required File file,
    required String sheikhName,
    required int surahNumber,
  }) async {
    final uri = Uri.parse('http://192.168.1.10:8000/add_sheikh/');

    var request = http.MultipartRequest('POST', uri)
      ..fields['sheikh_name'] = sheikhName
      ..fields['surah_number'] = surahNumber.toString()
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return {'success': true, 'message': body};
    } else if (response.statusCode == 400) {
      return {'success': false, 'message': 'الملف يجب أن يكون بصيغة wav فقط'};
    } else {
      print('Error Body: $body');
      return {'success': false, 'message': 'حدث خطأ أثناء رفع الملف'};
    }
  }
}

