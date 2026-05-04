import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/rabbit.dart';
import '../models/message.dart';
import '../models/sop_evaluation.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Rabbits ---
  Future<List<Rabbit>> getMyRabbits(String userEmail) async {
    // 1. Fetch sales where customerId matches userEmail
    QuerySnapshot salesSnapshot = await _db
        .collection('sales')
        .where('customerId', isEqualTo: userEmail.toLowerCase())
        .get();

    List<String> rabbitIds = salesSnapshot.docs
        .map((doc) => doc['rabbitId'] as String)
        .toList();

    if (rabbitIds.isEmpty) return [];

    // 2. Fetch rabbit details from rabbits collection
    // Firestore 'whereIn' supports up to 30 IDs. For more, need to chunk.
    List<Rabbit> myRabbits = [];
    for (var i = 0; i < rabbitIds.length; i += 10) {
      int end = (i + 10 < rabbitIds.length) ? i + 10 : rabbitIds.length;
      QuerySnapshot rabbitsSnapshot = await _db
          .collection('rabbits')
          .where(FieldPath.documentId, whereIn: rabbitIds.sublist(i, end))
          .get();
      myRabbits.addAll(rabbitsSnapshot.docs.map((doc) => Rabbit.fromFirestore(doc)));
    }

    return myRabbits;
  }

  // --- Marketplace ---
  Future<Map<String, List<dynamic>>> getMarketplaceData() async {
    // Parallel loading for high-speed performance
    final results = await Future.wait([
      _db.collection('forsale').get(),
      _db.collection('marketplace').get(),
    ]);

    List<Rabbit> animals = results[0].docs.map((doc) => Rabbit.fromFirestore(doc)).toList();
    List<dynamic> items = results[1].docs.map((doc) => doc.data()).toList();

    return {
      'animals': animals,
      'items': items,
    };
  }

  // --- Wishlist ---
  Future<void> addToWishlist(String userEmail, Rabbit rabbit) async {
    await _db
        .collection('wishlist')
        .doc(userEmail.toLowerCase())
        .collection('rabbits')
        .doc(rabbit.id)
        .set(rabbit.toMap());
  }

  Stream<List<Rabbit>> getWishlist(String userEmail) {
    return _db
        .collection('wishlist')
        .doc(userEmail.toLowerCase())
        .collection('rabbits')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Rabbit.fromFirestore(doc)).toList());
  }

  // --- Messaging ---
  Stream<List<Message>> getChatMessages(String userEmail) {
    return _db
        .collection('messages')
        .doc(userEmail.toLowerCase())
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage(String userEmail, Message message) async {
    await _db
        .collection('messages')
        .doc(userEmail.toLowerCase())
        .collection('chat')
        .add(message.toMap());
  }

  Future<bool> canSendImage(String userEmail) async {
    QuerySnapshot snapshot = await _db
        .collection('messages')
        .doc(userEmail.toLowerCase())
        .collection('chat')
        .where('imageUrl', isNotEqualTo: '')
        .orderBy('imageUrl') // Needed for the isNotEqualTo filter in some cases
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return true;

    DateTime lastImageTime = (snapshot.docs.first['timestamp'] as Timestamp).toDate();
    return DateTime.now().difference(lastImageTime).inHours >= 1;
  }

  // --- SOP Evaluations ---
  Future<List<SopEvaluation>> getSopHistory(String rabbitId) async {
    QuerySnapshot snapshot = await _db
        .collection('sop_evaluations')
        .where('rabbitId', isEqualTo: rabbitId)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => SopEvaluation.fromFirestore(doc)).toList();
  }

  // --- Customer Overrides (Local Data on Cloud) ---
  Future<void> saveCustomerOverride(String userEmail, String rabbitId, Map<String, dynamic> overrides) async {
    await _db
        .collection('local_data')
        .doc(userEmail.toLowerCase())
        .collection('rabbits')
        .doc(rabbitId)
        .set(overrides, SetOptions(merge: true));
  }

  Future<Rabbit?> getRabbitById(String rabbitId) async {
    DocumentSnapshot doc = await _db.collection('rabbits').doc(rabbitId).get();
    if (doc.exists) {
      return Rabbit.fromFirestore(doc);
    }
    return null;
  }

  // --- SOP Evaluations & Grading ---
  Future<Map<String, dynamic>> getRabbitSopStats(String rabbitId) async {
    QuerySnapshot snapshot = await _db
        .collection('sop_evaluations')
        .where('rabbitId', isEqualTo: rabbitId)
        .get();

    if (snapshot.docs.isEmpty) {
      return {'average': 0.0, 'grade': 'N/A'};
    }

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc['totalScore'] ?? 0).toDouble();
    }
    double average = total / snapshot.docs.length;

    String grade;
    if (average >= 90) {
      grade = 'A';
    } else if (average >= 80) grade = 'B';
    else if (average >= 70) grade = 'C';
    else if (average >= 60) grade = 'D';
    else grade = 'F';

    return {'average': average, 'grade': grade};
  }

  // --- User Profile ---
  Future<void> saveUserName(String email, String name) async {
    await _db.collection('customers').doc(email.toLowerCase()).set({
      'name': name,
      'email': email.toLowerCase(),
    }, SetOptions(merge: true));
  }

  Future<String?> getUserName(String email) async {
    DocumentSnapshot doc = await _db.collection('customers').doc(email.toLowerCase()).get();
    if (doc.exists) {
      return (doc.data() as Map<String, dynamic>)['name'];
    }
    return null;
  }

  // --- Indexed Queries ---
  Future<List<Map<String, dynamic>>> getWeighIns(String rabbitId) async {
    QuerySnapshot snapshot = await _db
        .collection('weigh_ins')
        .where('rabbitId', isEqualTo: rabbitId)
        .get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getMedicalHistory(String rabbitId) async {
    QuerySnapshot snapshot = await _db
        .collection('medical')
        .where('rabbitId', isEqualTo: rabbitId)
        .get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Mapping fields based on screenshot to avoid null errors
      return {
        'description': data['treatment'] ?? data['condition'] ?? 'No description',
        'date': data['date'] != null ? 
                DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(data['date'] is int ? data['date'] : int.parse(data['date'].toString()))) 
                : 'Unknown Date',
        'cost': data['cost'] ?? 0,
      };
    }).toList();
  }
}
