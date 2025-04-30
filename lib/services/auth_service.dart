class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return true; // Always succeeds for mock
  }

  Future<void> logout() async {
    await Future.delayed(Duration(milliseconds: 500));
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    await Future.delayed(Duration(milliseconds: 300));
    return {
      'id': 'provider123',
      'name': 'Demo Provider',
      'email': 'provider@chillfix.lk',
      'type': 'provider',
    };
  }
}