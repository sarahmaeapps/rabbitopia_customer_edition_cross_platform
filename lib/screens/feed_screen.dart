import 'package:flutter/material.dart';
import '../services/local_db_service.dart';
import '../models/feed_entry.dart';
import 'package:intl/intl.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _db = LocalDbService();

  double _calculateTotal(List<FeedEntry> entries) {
    return entries.fold(0, (sum, item) => sum + item.price);
  }

  double _calculate30DayAvg(List<FeedEntry> entries) {
    if (entries.isEmpty) return 0;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final recentEntries = entries.where((e) => e.date.isAfter(thirtyDaysAgo)).toList();
    if (recentEntries.isEmpty) return 0;
    return _calculateTotal(recentEntries) / 30;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed Purchases')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<FeedEntry>>(
          future: _db.getAllFeedEntries(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final entries = snapshot.data!;
            final total = _calculateTotal(entries);
            final avg = _calculate30DayAvg(entries);

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green.withOpacity(0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Total Cost', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('30-Day Avg', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                          Text('\$${avg.toStringAsFixed(2)}/day', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      return Card(
                        color: Colors.black45,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: ListTile(
                          title: Text('${e.brand} - ${e.weightLbs}lbs', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(DateFormat('yyyy-MM-dd').format(e.date), style: const TextStyle(color: Colors.white70)),
                          trailing: Text('\$${e.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFeedDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFeedDialog(BuildContext context) {
    final brandController = TextEditingController();
    final priceController = TextEditingController();
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Feed Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand')),
            TextField(controller: weightController, decoration: const InputDecoration(labelText: 'Weight (lbs)'), keyboardType: TextInputType.number),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await _db.insertFeedEntry(FeedEntry(
                brand: brandController.text,
                supplier: '',
                weightLbs: double.tryParse(weightController.text) ?? 0,
                price: double.tryParse(priceController.text) ?? 0,
                date: DateTime.now(),
                protein: 0,
                fiber: 0,
                fat: 0,
              ));
              if (mounted) {
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
