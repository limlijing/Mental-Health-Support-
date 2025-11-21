// ai_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'AIzaSyA_G1_zD8iannnfnkR4IlBgUXUji1Pjnd0';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com';

  String _currentModel = '';

  Future<String> _getSupportedModel() async {
    try {
      final url = Uri.parse('$_baseUrl/v1beta/models?key=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var model in data['models']) {
          final name = model['name'];
          final supportedMethods = List<String>.from(model['supportedGenerationMethods'] ?? []);

          if (supportedMethods.contains('generateContent')) {
            print('Found supported model: $name');

            if (name.contains('gemini-pro')) {
              _currentModel = name;
              return name;
            }
          }
        }

        for (var model in data['models']) {
          final name = model['name'];
          final supportedMethods = List<String>.from(model['supportedGenerationMethods'] ?? []);
          if (supportedMethods.contains('generateContent')) {
            _currentModel = name;
            return name;
          }
        }

        throw Exception('no support model');
      } else {
        throw Exception('no support model: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('wrong model: $e');
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      if (_currentModel.isEmpty) {
        _currentModel = await _getSupportedModel();
      }

      String shortModelName = _currentModel.contains('/')
          ? _currentModel.split('/').last
          : _currentModel;

      final url = Uri.parse('$_baseUrl/v1beta/models/$shortModelName:generateContent?key=$_apiKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('API failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('AI wrong service: $e');
    }
  }

  String getCurrentModel() {
    return _currentModel;
  }
}