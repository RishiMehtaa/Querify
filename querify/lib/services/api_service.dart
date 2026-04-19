import 'dart:convert';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// Response models
// ---------------------------------------------------------------------------

class AuthResponse {
  final String token;
  final String role;
  final String username;

  AuthResponse({
    required this.token,
    required this.role,
    required this.username,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json['token'] as String,
        role: json['role'] as String,
        username: json['username'] as String,
      );
}

class DBConnectResponse {
  final bool success;
  final String connectionId;

  DBConnectResponse({required this.success, required this.connectionId});

  factory DBConnectResponse.fromJson(Map<String, dynamic> json) =>
      DBConnectResponse(
        success: json['success'] as bool,
        connectionId: json['connection_id'] as String,
      );
}

class ChatResponse {
  final String type; // 'sql' | 'eda'
  final String answer;

  // EDA-only fields
  final List<String>? steps;
  final String? image;      // base64-encoded PNG
  final String? dataframe;  // JSON string

  ChatResponse({
    required this.type,
    required this.answer,
    this.steps,
    this.image,
    this.dataframe,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        type: json['type'] as String,
        answer: json['answer'] as String,
        steps: json['steps'] != null
    ? (json['steps'] as List).map((s) => s is String ? s : s.toString()).toList()
    : null,
        image: json['image'] as String?,
        dataframe: json['dataframe'] as String?,
      );
}

// ---------------------------------------------------------------------------
// API errors
// ---------------------------------------------------------------------------

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

// ---------------------------------------------------------------------------
// Service
// ---------------------------------------------------------------------------

class ApiService {
  static const String _baseUrl = 'http://localhost:8000';

  // Shared headers
  static Map<String, String> _headers({String? token}) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  // ── Helpers ──────────────────────────────────────────────────────────────

  static Map<String, dynamic> _parseBody(http.Response res) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 400) {
      final detail = body['detail'] ?? body['message'] ?? 'Unknown error';
      throw ApiException(res.statusCode, detail.toString());
    }
    return body;
  }

  // ── Auth ─────────────────────────────────────────────────────────────────

  /// POST /auth/login
  static Future<AuthResponse> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    return AuthResponse.fromJson(_parseBody(res));
  }

  /// POST /auth/signup
  static Future<AuthResponse> signup({
    required String username,
    required String email,
    required String password,
    required String role,       // 'org' | 'user'
    required String orgName,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/auth/signup'),
      headers: _headers(),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'role': role,
        'org_name': orgName,
      }),
    );
    return AuthResponse.fromJson(_parseBody(res));
  }

  // ── Database ──────────────────────────────────────────────────────────────

  /// POST /db/connect
  static Future<DBConnectResponse> connectDB({
    required String host,
    required String user,
    required String password,
    required String dbname,
    String? token,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/db/connect'),
      headers: _headers(token: token),
      body: jsonEncode({
        'host': host,
        'user': user,
        'password': password,
        'dbname': dbname,
      }),
    );
    return DBConnectResponse.fromJson(_parseBody(res));
  }

  // ── Chat ──────────────────────────────────────────────────────────────────

  /// POST /chat
  static Future<ChatResponse> sendMessage(
    String text, {
    String? connectionId,
    String? token,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/chat'),
      headers: _headers(token: token),
      body: jsonEncode({
        'text': text,
        if (connectionId != null) 'connection_id': connectionId,
      }),
    );
    return ChatResponse.fromJson(_parseBody(res));
  }
}