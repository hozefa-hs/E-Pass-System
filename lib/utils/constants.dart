class ApiConstants {
  // static const String baseUrl = 'http://localhost:8080';
  // static const String baseUrl = 'http://10.0.2.2:8080';
  static const String baseUrl = 'https://thawing-savannah-05781-d4efd14a24f0.herokuapp.com';
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
  
  // Route names
  static const String welcomeRoute = '/welcome';
  static const String authRoute = '/auth';
  static const String dashboardRoute = '/dashboard';
}
