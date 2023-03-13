import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Config {
  static const host = '127.0.0.1:8001';

  static const regisetApi = 'api/register';
  static const fillExpertInfoApi = 'api/expertData';
  static const Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, String>> getHeader() async {
    var accessToken =
        await const FlutterSecureStorage().read(key: 'access_token');
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }
}
