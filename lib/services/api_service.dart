// File path: lib/services/api_service.dart
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://wellnesspath.atwebpages.com/index.php';

  static Future<http.Response> post(String endpoint, Map<String, String> body) async {
    try {
      final response = await http.post(Uri.parse('$_baseUrl$endpoint'), body: body);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  static Future<http.Response> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$endpoint'));
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
