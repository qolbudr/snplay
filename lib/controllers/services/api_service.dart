import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snplay/constant.dart';

class ApiService {
  Future<dynamic> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: {'X-API-KEY': apiKey});
      String body = response.body;
      return jsonDecode(body);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'X-API-KEY': apiKey, 'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      String body = response.body;
      return jsonDecode(body);
    } catch (e) {
      rethrow;
    }
  }
}
