import 'package:flutter/material.dart';
import 'package:core/core/api/api_client.dart';
import 'package:core/core/authentication/auth_controller.dart';
import 'package:core/core/authentication/biometric_gateway.dart';
import 'package:core/core/authentication/auth_repository.dart';
import 'package:core/core/authentication/mpin_store.dart';
import 'package:core/core/authentication/token_store.dart';
import 'package:core/core/network/http_transport.dart';
import 'package:core/core/security/secure_store.dart';
import 'package:core/features/auth/login_page.dart';
import 'package:core/features/auth/mpin_setup_page.dart';
import 'package:core/features/auth/mpin_unlock_page.dart';
import 'package:core/features/shell/app_bottom_nav.dart';
import 'package:core/features/shell/app_shell.dart';

class CoreApp extends StatelessWidget {
  const CoreApp({super.key, required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: auth,
      child: MaterialApp(
        navigatorKey: auth.navigatorKey,
        title: 'Core',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: shellAccent),
          scaffoldBackgroundColor: shellCanvas,
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    switch (auth.phase) {
      case AuthPhase.initializing:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthPhase.unauthenticated:
      case AuthPhase.authenticating:
        return const LoginPage();
      case AuthPhase.mpinSetup:
        return const MpinSetupPage();
      case AuthPhase.locked:
        return const MpinUnlockPage();
      case AuthPhase.authenticated:
      case AuthPhase.loggingOut:
        return const AppShell();
    }
  }
}

Future<AuthController> createAuthController() async {
  final store = FlutterSecureStore();
  final tokens = TokenStore(store);
  final client = ApiClient(
    baseUrl: ApiClient.defaultBaseUrl,
    tokens: tokens,
    transport: PackageHttpTransport(),
  );
  ApiClient.install(client);
  final auth = AuthController(
    tokens: tokens,
    mpin: MpinStore(store),
    repository: AuthRepository(client),
    biometrics: LocalBiometricGateway(),
    client: client,
  );
  await auth.bootstrap();
  return auth;
}
