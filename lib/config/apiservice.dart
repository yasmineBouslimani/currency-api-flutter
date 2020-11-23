import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class APIService {
  // Base API url
  static const String _baseUrl = "https://currency26.p.rapidapi.com/convert/";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": "currency26.p.rapidapi.com",
    "x-rapidapi-key": Config.CURRENCY_APP_KEY,
  };
  Future<dynamic> get() async {
    var uri = _baseUrl+"EUR/AOA/10";
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
}

/*
// Base API url
const String _baseUrl = "https://currency26.p.rapidapi.com/convert/";
// Base headers for Response url
const Map<String, String> _headers = {
  "content-type": "application/json",
  "x-rapidapi-host": "currency26.p.rapidapi.com",
  "x-rapidapi-key": Config.CURRENCY_APP_KEY,
};
var uri = _baseUrl+"EUR/AOA/10";
final response = await http.get(uri, headers: _headers);
if (response.statusCode == 200) {
// If server returns an OK response, parse the JSON.
return json.decode(response.body);
} else {
// If that response was not OK, throw an error.
throw Exception('Failed to load json data');
}*/
