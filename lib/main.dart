import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/permission_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/my_rabbits_screen.dart';
import 'screens/housing_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/health_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/rabbit_detail_screen.dart';
import 'screens/sop_history_screen.dart';
import 'screens/sop_detail_screen.dart';
import 'screens/chat_screen.dart';
import 'models/rabbit.dart';
import 'models/sop_evaluation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure Firebase is initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  
  // Request permissions on start
  await PermissionService().requestAllPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rabbitopia Customer Edition',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const AuthWrapper(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/dashboard':
            return MaterialPageRoute(builder: (_) => const DashboardScreen());
          case '/my_rabbits':
            return MaterialPageRoute(builder: (_) => const MyRabbitsScreen());
          case '/housing':
            return MaterialPageRoute(builder: (_) => const HousingScreen());
          case '/feed':
            return MaterialPageRoute(builder: (_) => const FeedScreen());
          case '/health':
            return MaterialPageRoute(builder: (_) => const HealthScreen());
          case '/marketplace':
            return MaterialPageRoute(builder: (_) => const MarketplaceScreen());
          case '/wishlist':
            return MaterialPageRoute(builder: (_) => const WishlistScreen());
          case '/rabbit_detail':
            final rabbit = settings.arguments as Rabbit;
            return MaterialPageRoute(builder: (_) => RabbitDetailScreen(rabbit: rabbit));
          case '/sop_history':
            final rabbitId = settings.arguments as String;
            return MaterialPageRoute(builder: (_) => SopHistoryScreen(rabbitId: rabbitId));
          case '/sop_detail':
            final eval = settings.arguments as SopEvaluation;
            return MaterialPageRoute(builder: (_) => SopDetailScreen(evaluation: eval));
          case '/chat':
            return MaterialPageRoute(builder: (_) => const ChatScreen());
          default:
            return null;
        }
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          }
          return const DashboardScreen();
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
