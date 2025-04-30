class MockService {
  // Current logged-in provider (mock)
  static String currentProviderId = "provider1";
  static String currentProviderService = "Plumbing"; // Will be loaded from profile

  // Mock providers data
  static final List<Map<String, dynamic>> _providers = [
    {
      'id': 'provider1',
      'name': 'Nimal Plumbing',
      'service': 'Plumbing',
      'rating': 4.5,
      'jobsCompleted': 42,
    },
    {
      'id': 'provider2',
      'name': 'CleanPro',
      'service': 'Cleaning',
      'rating': 4.8,
      'jobsCompleted': 128,
    },
  ];

  // Mock service requests
  static final List<Map<String, dynamic>> _requests = [
    {
      'id': '101',
      'customerName': 'Amila Chinthaka',
      'serviceType': 'Plumbing',
      'providerId': '', // Empty means not assigned
      'problem': 'Kitchen sink blockage',
      'date': DateTime.now().add(Duration(days: 1)),
      'status': 'pending',
    },
    {
      'id': '102',
      'customerName': 'Kumar Selvan',
      'serviceType': 'Cleaning',
      'providerId': '',
      'problem': 'Full house cleaning',
      'date': DateTime.now().add(Duration(days: 2)),
      'status': 'pending',
    },
    {
      'id': '103',
      'customerName': 'Ahamed Khan',
      'serviceType': 'Plumbing',
      'providerId': 'provider1', // Assigned to our test provider
      'problem': 'Bathroom leak',
      'date': DateTime.now().add(Duration(days: 3)),
      'status': 'accepted',
    },
  ];

  // Get ONLY requests matching provider's service type
  static List<Map<String, dynamic>> getRelevantRequests() {
    return _requests.where((request) {
      return request['serviceType'] == currentProviderService &&
          (request['providerId'] == "" ||
              request['providerId'] == currentProviderId);
    }).toList();
  }

  // Accept a request
  static void acceptRequest(String requestId) {
    var request = _requests.firstWhere((r) => r['id'] == requestId);
    request['providerId'] = currentProviderId;
    request['status'] = 'accepted';
  }

  // Decline a request
  static void declineRequest(String requestId) {
    var request = _requests.firstWhere((r) => r['id'] == requestId);
    request['status'] = 'declined';
  }
}