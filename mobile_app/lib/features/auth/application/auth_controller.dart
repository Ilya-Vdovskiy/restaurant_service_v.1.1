import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_flutter_app/core/network/api_client.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserSession?>>((ref) {
      return AuthController(ref.read(apiClientProvider));
    });

class AuthController extends StateNotifier<AsyncValue<UserSession?>> {
  AuthController(this._apiClient) : super(const AsyncData(null));

  final ApiClient _apiClient;

  Future<void> login(String login, String password) async {
    state = const AsyncLoading();
    try {
      final data = await _apiClient.post('/auth/login', {
        'login': login,
        'password': password,
      });
      final session = UserSession.fromJson(data);
      _apiClient.setToken(session.token);
      state = AsyncData(session);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  void logout() {
    _apiClient.setToken(null);
    state = const AsyncData(null);
  }
}

class UserSession {
  const UserSession({required this.token, required this.user});

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      token: json['token']?.toString() ?? '',
      user: Map<String, dynamic>.from(json['user'] as Map? ?? const {}),
    );
  }

  final String token;
  final Map<String, dynamic> user;
}
