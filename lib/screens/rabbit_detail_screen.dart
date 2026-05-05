import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rabbit.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/web_safe_image.dart';

class RabbitDetailScreen extends StatelessWidget {
  final Rabbit rabbit;

  const RabbitDetailScreen({super.key, required this.rabbit});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
    final userEmail = Provider.of<AuthService>(context).currentUser?.email ?? '';

    return FutureBuilder<Rabbit?>(
      future: firestore.getRabbitById(rabbit.id),
      builder: (context, snapshot) {
        final displayRabbit = snapshot.data ?? rabbit;

        return Scaffold(
          appBar: AppBar(
            title: Text(displayRabbit.name),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 100, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Hero(
                      tag: displayRabbit.id,
                      child: GestureDetector(
                        onTap: () => _showFullScreenImage(context, displayRabbit.pictureUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            color: Colors.black45,
                            constraints: const BoxConstraints(maxHeight: 400),
                            child: WebSafeImage(
                              imageUrl: displayRabbit.pictureUrl,
                              width: double.infinity,
                              fit: BoxFit.contain, // Shows the whole picture without cropping
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Tap image to zoom', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<Map<String, dynamic>>(
                    future: firestore.getRabbitSopStats(displayRabbit.id),
                    builder: (context, snapshot) {
                      final stats = snapshot.data ?? {'average': 0.0, 'grade': 'N/A'};
                      return _buildRegistryLayout(context, displayRabbit, stats['grade'], stats['average']);
                    },
                  ),
                  const SizedBox(height: 20),
                  if (displayRabbit.forSale) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: userEmail.isEmpty 
                            ? () => Navigator.pushNamed(context, '/auth')
                            : () => firestore.addToWishlist(userEmail, displayRabbit),
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Interested'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.8), 
                            foregroundColor: Colors.white
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: userEmail.isEmpty
                            ? () => Navigator.pushNamed(context, '/auth')
                            : () => Navigator.pushNamed(context, '/chat'),
                          icon: const Icon(Icons.chat),
                          label: const Text('Contact Us'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent.withOpacity(0.8), 
                            foregroundColor: Colors.white
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Divider(color: Colors.white24),
                  _buildInteractiveArea(context, displayRabbit, firestore),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegistryLayout(BuildContext context, Rabbit displayRabbit, String grade, double sopAvg) {
    return Column(
      children: [
        Row(
          children: [
            _buildInfoBox('Grade', grade, Colors.blue.shade300),
            _buildInfoBox('SOP Score', sopAvg.toStringAsFixed(1), Colors.green.shade300),
            _buildInfoBox('Gen', displayRabbit.generation, Colors.orange.shade300),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          color: Colors.black45,
          child: Column(
            children: [
              ListTile(
                title: const Text('Ear Tattoo', style: TextStyle(color: Colors.white70)), 
                subtitle: Text(displayRabbit.earTattoo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
              ),
              ListTile(
                title: const Text('Breed', style: TextStyle(color: Colors.white70)), 
                subtitle: Text(displayRabbit.breed, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
              ),
              ListTile(
                title: const Text('Status', style: TextStyle(color: Colors.white70)), 
                subtitle: Text(displayRabbit.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
              ),
              if (displayRabbit.notes.isNotEmpty) 
                ListTile(
                  title: const Text('Notes', style: TextStyle(color: Colors.white70)), 
                  subtitle: Text(displayRabbit.notes, style: const TextStyle(color: Colors.white))
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String label, String value, Color color) {
    String displayValue = (value == "" || value == "null") ? "0" : value;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70)),
            Text(displayValue, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveArea(BuildContext context, Rabbit displayRabbit, FirestoreService firestore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('History & Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Card(
          color: Colors.black45,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.history, color: Colors.blueAccent),
                title: const Text('SOP Evaluation History'),
                onTap: () => Navigator.pushNamed(context, '/sop_history', arguments: displayRabbit.id),
              ),
              ListTile(
                leading: const Icon(Icons.scale, color: Colors.greenAccent),
                title: const Text('Weigh-ins'),
                onTap: () => _showWeighIns(context, displayRabbit.id, firestore),
              ),
              ListTile(
                leading: const Icon(Icons.medication, color: Colors.redAccent),
                title: const Text('Medical History'),
                onTap: () => _showMedical(context, displayRabbit.id, firestore),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: WebSafeImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeighIns(BuildContext context, String rabbitId, FirestoreService firestore) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (context) => FutureBuilder<List<Map<String, dynamic>>>(
        future: firestore.getWeighIns(rabbitId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) => ListTile(
              title: Text('Weight: ${data[i]['weight']} lbs', style: const TextStyle(color: Colors.white)),
              subtitle: Text('Date: ${data[i]['date']}', style: const TextStyle(color: Colors.white70)),
            ),
          );
        },
      ),
    );
  }

  void _showMedical(BuildContext context, String rabbitId, FirestoreService firestore) {
     showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (context) => FutureBuilder<List<Map<String, dynamic>>>(
        future: firestore.getMedicalHistory(rabbitId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          final data = snapshot.data!;
          if (data.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No medical history found.', style: TextStyle(color: Colors.white70))));
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(data[i]['description'], style: const TextStyle(color: Colors.white)),
              subtitle: Text('Date: ${data[i]['date']}', style: const TextStyle(color: Colors.white70)),
              trailing: Text('\$${data[i]['cost']}', style: const TextStyle(color: Colors.redAccent)),
            ),
          );
        },
      ),
    );
  }
}
