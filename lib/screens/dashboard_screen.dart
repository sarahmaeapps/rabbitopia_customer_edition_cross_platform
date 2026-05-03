import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String _greeting;

  final List<String> _rabbitGreetings = [
    'Hoppy to see you again,',
    'Every-bunny missed you,',
    'Ear\'s to a great day,',
    'Jump right back in,',
    'Lettuce get started,',
    'Some-bunny is back!',
    'Welcome back to the burrow,',
    'Hoppy trails ahead,',
    'Ready for some bun-tastic fun,',
    'Carrot-ing is sharing,',
  ];

  @override
  void initState() {
    super.initState();
    _greeting = _rabbitGreetings[Random().nextInt(_rabbitGreetings.length)];
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rabbitopia Customer Edition'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Provider.of<AuthService>(context, listen: false).signOut(),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 100, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.shade300, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      _greeting,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FutureBuilder<String?>(
                      future: firestore.getUserName(user?.email ?? ''),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? user?.email ?? 'Valued Customer',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Large Navigation Buttons
              _buildNavButton(
                context,
                'My Rabbits',
                Icons.pets,
                Colors.orange,
                '/my_rabbits',
              ),
              const SizedBox(height: 10),
              _buildNavButton(
                context,
                'Messaging',
                Icons.chat,
                Colors.blue,
                '/chat',
              ),
              const SizedBox(height: 20),

              // Split Marketplace/Wishlist Row
              Row(
                children: [
                  Expanded(
                    child: _buildSmallNavButton(
                      context,
                      'Marketplace',
                      Icons.store,
                      Colors.green,
                      '/marketplace',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSmallNavButton(
                      context,
                      'Wish List',
                      Icons.favorite,
                      Colors.red,
                      '/wishlist',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, IconData icon, Color color, String route) {
    return SizedBox(
      height: 80,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon, size: 30),
        label: Text(title, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildSmallNavButton(BuildContext context, String title, IconData icon, Color color, String route) {
    return SizedBox(
      height: 120,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
