import 'dart:convert' as convert;
import 'package:http/http.dart';
import 'package:http_logger/log_level.dart';
import 'package:http_logger/logging_middleware.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:http_middleware/http_with_middleware.dart';
import 'package:troken/network/Responses.dart';

import 'Requests.dart';


class TokenApi {

  static const String _baseUrl = "https://treetracker.org/api/token";
  static const String _testBaseUrl = "https://test.treetracker.org/api/token";

  static const String API_KEY = "Bkmog4evxYxaEt6l9Odx1bWuZznMDhOX";

  static const Map<String, String> _headers = {
    "Content-Type" : "application/json",
    "TREETRACKER-API-KEY" : API_KEY,
  };

  HttpWithMiddleware _httpClient = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  Future<AuthResponse> authenticate(AuthRequest authRequest) {
    return _postObject("/auth", authRequest.toJson(), (json) => AuthResponse.fromJson(json));
  }

  Future<String> google() async {
    var r =  await _httpClient.get("https://google.com");
    return r.toString();
  }

  Future<Response> _get(String url) async {
    return await _httpClient.get("$_baseUrl$url", headers: _headers);
  }

  Future<Response> _post(String url, dynamic body) async {
    return await _httpClient.post("$_baseUrl$url", headers: _headers, body: body);
  }

  Future<T> _postObject<T>(String url, dynamic body, T Function(dynamic) converter) async {
    var response = await _post(url, convert.jsonEncode(body));
    var json = convert.jsonDecode(response.body);
    return converter(json);
  }

}