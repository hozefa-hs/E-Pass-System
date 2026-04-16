class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';
  // static const String baseUrl = 'http://10.0.2.2:8080';
  static const String authPath = '/api/auth';

  
  // Auth endpoints
  static const String register = '$authPath/register';
  static const String login = '$authPath/login';
  static const String validate = '$authPath/validate';
}

class AppConstants {
  static const String appName = 'E-Pass System';
  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
}
