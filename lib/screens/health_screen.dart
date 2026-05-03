import 'package:flutter/material.dart';
import '../services/local_db_service.dart';
import '../models/medical_care.dart';
import 'package:intl/intl.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final _db = LocalDbService();
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health & Medical'),
        actions: [
          DropdownButton<String>(
            value: _filter,
            icon: const Icon(Icons.filter_list, color: Colors.white),
            dropdownColor: Colors.grey.shade900,
            style: const TextStyle(color: Colors.white),
            items: <String>['All', 'Specific'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _filter = val!;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<MedicalCare>>(
          future: _filter == 'All' ? _db.getAllMedicalCare() : _showRabbitPickerAndGetCare(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final cares = snapshot.data!;
            final totalCost = cares.fold(0.0, (sum, item) => sum + item.cost);

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  color: Colors.red.withOpacity(0.3),
                  child: Center(
                    child: Text('Total Medical Expenses: \$${totalCost.toStringAsFixed(2)}', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cares.length,
                    itemBuilder: (context, index) {
                      final c = cares[index];
                      return Card(
                        color: Colors.black45,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: ListTile(
                          title: Text(c.description, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text('Rabbit: ${c.rabbitId} | Date: ${DateFormat('yyyy-MM-dd').format(c.date)}', style: const TextStyle(color: Colors.white70)),
                          trailing: Text('\$${c.cost.toStringAsFixed(2)}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
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
        onPressed: () => _showAddMedicalDialog(context),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.medical_services, color: Colors.white),
      ),
    );
  }

  // Simplified for now, normally would show a list of owned rabbits
  Future<List<MedicalCare>> _showRabbitPickerAndGetCare() async {
     return await _db.getAllMedicalCare(); // Placeholder
  }

  void _showAddMedicalDialog(BuildContext context) {
    final rabbitIdController = TextEditingController();
    final descController = TextEditingController();
    final costController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medical Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: rabbitIdController, decoration: const InputDecoration(labelText: 'Rabbit ID')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: costController, decoration: const InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await _db.insertMedicalCare(MedicalCare(
                rabbitId: rabbitIdController.text,
                date: DateTime.now(),
                description: descController.text,
                cost: double.tryParse(costController.text) ?? 0,
                medications: '',
                vetNotes: '',
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
