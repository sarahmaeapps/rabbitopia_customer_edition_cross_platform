import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/rabbit.dart';
import '../widgets/web_safe_image.dart';

class MyRabbitsScreen extends StatelessWidget {
  const MyRabbitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rabbits'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: kIsWeb ? null : PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.black26,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () => Navigator.pushNamed(context, '/housing'), child: const Text('Housing', style: TextStyle(color: Colors.white))),
                TextButton(onPressed: () => Navigator.pushNamed(context, '/feed'), child: const Text('Feed', style: TextStyle(color: Colors.white))),
                TextButton(onPressed: () => Navigator.pushNamed(context, '/health'), child: const Text('Health', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: kIsWeb ? 80 : 110),
          child: FutureBuilder<List<Rabbit>>(
            future: firestore.getMyRabbits(user?.email ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
              }
              final rabbits = snapshot.data ?? [];
              if (rabbits.isEmpty) {
                return const Center(child: Text('No rabbits found.', style: TextStyle(color: Colors.white70)));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: rabbits.length,
                itemBuilder: (context, index) {
                  final rabbit = rabbits[index];
                  return Card(
                    color: Colors.black45,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: WebSafeImage(
                          imageUrl: rabbit.pictureUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(rabbit.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text('ID: ${rabbit.earTattoo} | ${rabbit.breed}', style: const TextStyle(color: Colors.white70)),
                      onTap: () => Navigator.pushNamed(context, '/rabbit_detail', arguments: rabbit),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
