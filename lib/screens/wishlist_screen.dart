import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/rabbit.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<List<Rabbit>>(
          stream: firestore.getWishlist(user?.email ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final rabbits = snapshot.data ?? [];
            if (rabbits.isEmpty) return const Center(child: Text('Your wishlist is empty.', style: TextStyle(color: Colors.white70)));

            return ListView.builder(
              itemCount: rabbits.length,
              itemBuilder: (context, index) {
                final rabbit = rabbits[index];
                return Card(
                  color: Colors.black45,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(rabbit.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(rabbit.breed, style: const TextStyle(color: Colors.white70)),
                    trailing: const Icon(Icons.favorite, color: Colors.redAccent),
                    onTap: () => Navigator.pushNamed(context, '/rabbit_detail', arguments: rabbit),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
