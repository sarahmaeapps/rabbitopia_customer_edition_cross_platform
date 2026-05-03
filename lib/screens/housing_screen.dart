import 'package:flutter/material.dart';
import '../services/local_db_service.dart';
import '../models/housing.dart';

class HousingScreen extends StatefulWidget {
  const HousingScreen({super.key});

  @override
  State<HousingScreen> createState() => _HousingScreenState();
}

class _HousingScreenState extends State<HousingScreen> {
  final _db = LocalDbService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Housing')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Housing>>(
          future: _db.getAllHousing(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final housings = snapshot.data!;
            if (housings.isEmpty) return const Center(child: Text('No housing records.', style: TextStyle(color: Colors.white70)));
            return ListView.builder(
              itemCount: housings.length,
              itemBuilder: (context, index) {
                final h = housings[index];
                return Card(
                  color: Colors.black45,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text('Hutch: ${h.hutchId}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('Residents: ${h.residents}\nRepair: ${h.repairHistory}', style: const TextStyle(color: Colors.white70)),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHousingDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddHousingDialog(BuildContext context) {
    // Basic dialog to add housing info
    final hutchController = TextEditingController();
    final residentsController = TextEditingController();
    final repairsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Housing Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: hutchController, decoration: const InputDecoration(labelText: 'Hutch ID (e.g. A1)')),
            TextField(controller: residentsController, decoration: const InputDecoration(labelText: 'Residents')),
            TextField(controller: repairsController, decoration: const InputDecoration(labelText: 'Repair History')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await _db.insertHousing(Housing(
                hutchId: hutchController.text,
                residents: residentsController.text,
                predatorSigns: '',
                upgrades: '',
                repairHistory: repairsController.text,
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
