import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/sop_evaluation.dart';
import 'package:intl/intl.dart';

class SopHistoryScreen extends StatelessWidget {
  final String rabbitId;

  const SopHistoryScreen({super.key, required this.rabbitId});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SOP Evaluation History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: FutureBuilder<List<SopEvaluation>>(
          future: firestore.getSopHistory(rabbitId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white70)));
            }
            
            final evaluations = snapshot.data ?? [];
            if (evaluations.isEmpty) {
              return const Center(
                child: Text(
                  'No evaluations found.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 100, bottom: 20),
              itemCount: evaluations.length,
              itemBuilder: (context, index) {
                final eval = evaluations[index];
                return Card(
                  color: Colors.black.withOpacity(0.6),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      'Score: ${eval.score.toInt()} / 100',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMMM d, yyyy').format(eval.date),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rec: ${eval.recommendation}',
                          style: TextStyle(
                            color: eval.recommendation.contains('KEEP') ? Colors.greenAccent : Colors.orangeAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white38),
                    onTap: () => Navigator.pushNamed(context, '/sop_detail', arguments: eval),
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
