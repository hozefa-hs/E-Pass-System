import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/user.dart';
import '../models/pass.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, String>> getHeaders({String? token}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final headers = await getHeaders(token: token);
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    return await client.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(
    String endpoint, {
    String? token,
  }) async {
    final headers = await getHeaders(token: token);
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    return await client.get(
      url,
      headers: headers,
    );
  }

  Future<User> register(String email, String password, Role role) async {
    try {
      final response = await post(
        ApiConstants.register,
        {
          'email': email,
          'password': password,
          'role': role.toApiString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return User.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Registration failed',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred', 0);
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await post(
        ApiConstants.login,
        {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return User.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Login failed',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred', 0);
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await get(
        ApiConstants.validate,
        token: token,
      );

      if (response.statusCode == 200) {
        return response.body == 'true';
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Pass-related API methods
  Future<Pass> applyForPass(String token, PassRequest request) async {
    try {
      final response = await post(
        '/api/passes',
        request.toJson(),
        token: token,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Pass.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to apply for pass',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred', 0);
    }
  }

  Future<Pass?> getMyPass(String token) async {
    try {
      final response = await get(
        '/api/passes/my-pass',
        token: token,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Pass.fromJson(responseData);
      } else if (response.statusCode == 404) {
        return null; // No pass exists
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get pass',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred', 0);
    }
  }

  Future<Pass> approvePass(String adminToken, String passId) async {
    try {
      final response = await post(
        '/api/passes/$passId/approve',
        {},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Pass.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to approve pass',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred', 0);
    }
  }

  Future<Pass> rejectPass(String adminToken, String passId) async {
    try {
      final response = await post(
        '/api/passes/$passId/reject',
        {},
        token: adminToken,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Pass.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to reject pass',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred', 0);
    }
  }

  Future<List<Pass>> getPendingPasses(String adminToken) async {
    try {
      final response = await get(
        '/api/passes/pending',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Pass.fromJson(json)).toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get pending passes',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred', 0);
    }
  }

  Future<List<Pass>> getAllPasses(String adminToken) async {
    try {
      final response = await get(
        '/api/passes',
        token: adminToken,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Pass.fromJson(json)).toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['message'] ?? 'Failed to get all passes',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error occurred', 0);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
