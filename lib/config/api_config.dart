class ApiConfig {
  // Backend URL - เปลี่ยนที่นี่เมื่อต้องการใช้ server อื่น
  static const String baseUrl = 'http://192.168.182.236:3000';
  
  // API Endpoints
  static const String customersEndpoint = '/customers';
  static const String loginEndpoint = '/customers/login';
  static const String checkPhoneEndpoint = '/customers/check/phone';
  static const String checkEmailEndpoint = '/customers/check/email';
  static const String customersCountEndpoint = '/customers/count';
  static const String tripsEndpoint = '/trips';
  
  // Full URLs
  static String get customersUrl => '$baseUrl$customersEndpoint';
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get customersCountUrl => '$baseUrl$customersCountEndpoint';
  static String get tripsUrl => '$baseUrl$tripsEndpoint';
  
  // Dynamic URLs with parameters
  static String checkPhoneUrl(String phone) => '$baseUrl$checkPhoneEndpoint/$phone';
  static String checkEmailUrl(String email) => '$baseUrl$checkEmailEndpoint/$email';
  static String customersPhoneUrl(String phone) => '$baseUrl/customers/phone/$phone';
  static String customersEmailUrl(String email) => '$baseUrl/customers/email/$email';
  static String customersQueryPhoneUrl(String phone) => '$baseUrl/customers?phone=$phone';
  static String customersQueryEmailUrl(String email) => '$baseUrl/customers?email=$email';
  static String tripDetailUrl(int idx) => '$baseUrl$tripsEndpoint/$idx';
  static String customerDetailUrl(int idx) => '$baseUrl$customersEndpoint/$idx';
  
  // Default headers
  static const Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8"
  };
  
  // Default image URL
  static const String defaultImageUrl = "http://202.28.34.197:8888/contents/default-avatar.png";
}