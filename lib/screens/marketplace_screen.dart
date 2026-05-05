import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/rabbit.dart';
import '../widgets/web_safe_image.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _firestore = FirestoreService();
  late Future<Map<String, List<dynamic>>> _marketplaceData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _marketplaceData = _firestore.getMarketplaceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Animals For Sale'),
            Tab(text: 'Supplies & Items'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Map<String, List<dynamic>>>(
          future: _marketplaceData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            
            final animals = snapshot.data!['animals'] as List<Rabbit>;
            final items = snapshot.data!['items'] as List<dynamic>;

            return TabBarView(
              controller: _tabController,
              children: [
                _buildAnimalList(animals),
                _buildItemList(items),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimalList(List<Rabbit> animals) {
    if (animals.isEmpty) return const Center(child: Text('No animals for sale.'));
    return ListView.builder(
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final rabbit = animals[index];
        return Card(
          margin: const EdgeInsets.all(8),
          color: Colors.black54,
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: WebSafeImage(
                imageUrl: rabbit.pictureUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(rabbit.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: Text('${rabbit.breed} - \$${rabbit.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
            onTap: () => Navigator.pushNamed(context, '/rabbit_detail', arguments: rabbit),
          ),
        );
      },
    );
  }

  Widget _buildItemList(List<dynamic> items) {
    if (items.isEmpty) return const Center(child: Text('No items for sale.'));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.black54,
          child: ListTile(
            title: Text(item['name'] ?? 'Unknown Item', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['description'] ?? ''),
            trailing: Text('\$${item['price'] ?? 0}'),
          ),
        );
      },
    );
  }
}
