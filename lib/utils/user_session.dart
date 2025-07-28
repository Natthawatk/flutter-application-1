class UserSession {
  static int? _currentUserId;
  static String? _currentUserName;
  static String? _currentUserPhone;
  static String? _currentUserEmail;
  static String? _currentUserImage;

  // Getters
  static int? get currentUserId => _currentUserId;
  static String? get currentUserName => _currentUserName;
  static String? get currentUserPhone => _currentUserPhone;
  static String? get currentUserEmail => _currentUserEmail;
  static String? get currentUserImage => _currentUserImage;

  // Set user session after login
  static void setUserSession({
    required int userId,
    required String userName,
    required String userPhone,
    required String userEmail,
    required String userImage,
  }) {
    _currentUserId = userId;
    _currentUserName = userName;
    _currentUserPhone = userPhone;
    _currentUserEmail = userEmail;
    _currentUserImage = userImage;
  }

  // Clear user session on logout
  static void clearUserSession() {
    _currentUserId = null;
    _currentUserName = null;
    _currentUserPhone = null;
    _currentUserEmail = null;
    _currentUserImage = null;
  }

  // Check if user is logged in
  static bool get isLoggedIn => _currentUserId != null;
}