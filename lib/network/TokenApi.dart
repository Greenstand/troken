import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
//import 'package:http_logger/log_level.dart';
//import 'package:http_logger/logging_middleware.dart';
//import 'package:http_middleware/http_middleware.dart';
//import 'package:http_middleware/http_with_middleware.dart';
import 'package:troken/network/Responses.dart';

import 'Requests.dart';


class TokenApi {

  static const String _baseUrl = "https://treetracker.org/api/token";
  static const String _testBaseUrl = "https://test.treetracker.org/api/token";

//  static const String API_KEY = "Bkmog4evxYxaEt6l9Odx1bWuZznMDhOX";
  static const String API_KEY = "JSoEtD0jMvREa1HzmwvVL4h1EFqKIrZE";

  String _userToken;

  static Map<String, String> _headers = {
    "Content-Type" : "application/json",
    "TREETRACKER-API-KEY" : API_KEY,
  };


  void setUserToken(String token) {
    _userToken = token;
  }

//  HttpWithMiddleware _httpClient = HttpWithMiddleware.build(middlewares: [
//    HttpLogger(logLevel: LogLevel.BODY),
//  ]);

  Future<AuthResponse> authenticate(AuthRequest authRequest) {
    return _postObject("/auth", authRequest.toJson(), (json) => AuthResponse.fromJson(json));
  }

  Future<AccountsResponse> accounts() {
    return _getObject("/account", (json) => AccountsResponse.fromJson(json));
  }

  Future<TreeListResponse> trees(String wallet) {
    return _getObject("/tree?limit=50&wallet=$wallet", (json) => TreeListResponse.fromJson(json));
  }

  Future<TreeHistoryResponse> history(String treeToken) {
    return _getObject("/history?token=$treeToken", (json) => TreeHistoryResponse.fromJson(json));
  }

  Future<TransferResponse> transfer(TransferRequest transferRequest) {
    return _postObject("/transfer", transferRequest, (json) => TransferResponse.fromJson(json));
  }

  Future<Response> _get(String url) async {
    if (_userToken != null) {
      _headers.putIfAbsent("Authorization", () => "Bearer $_userToken");
    }
    return await http.get(Uri.encodeFull("$_baseUrl$url"), headers: _headers);
  }

  Future<T> _getObject<T>(String url, T Function(dynamic) converter) async {
    var response = await _get(url);
    var json = convert.jsonDecode(response.body);
    return converter(json);
  }

  Future<Response> _post(String url, dynamic body) async {
    if (_userToken != null) {
      _headers.putIfAbsent("Authorization", () => "Bearer $_userToken");
    }
    return await http.post(Uri.encodeFull("$_baseUrl$url"), headers: _headers, body: body);
  }

  Future<T> _postObject<T>(String url, dynamic body, T Function(dynamic) converter) async {
    var response = await _post(url, convert.jsonEncode(body));
    var json = convert.jsonDecode(response.body);
    return converter(json);
  }

}