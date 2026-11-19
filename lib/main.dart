import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'View/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init notice: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Rental App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF163A35),
          primary: const Color(0xFF163A35),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9F7),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  String _selectedGender = 'ប្រុស';
  bool _isLoading = false;

  // Collection Reference (ដូចជា Table ឈ្មោះ "students")
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

  // Function បញ្ចូលទិន្នន័យទៅកាន់ Firestore
  Future<void> _addStudent() async {
    final name = _nameController.text.trim();
    final major = _majorController.text.trim();

    if (name.isEmpty || major.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('សូមបញ្ចូលឈ្មោះ និងជំនាញ!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase នឹងបង្កើត Collection 'students' ដោយស្វ័យប្រវត្តពេល Add លើកដំបូង
      await _studentsCollection.add({
        'name': name,
        'gender': _selectedGender,
        'major': major,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _majorController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ បានបញ្ចូលទិន្នន័យដោយជោគជ័យ!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ មានបញ្ហា: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function លុបទិន្នន័យ
  Future<void> _deleteStudent(String id) async {
    await _studentsCollection.doc(id).delete();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('គ្រប់គ្រងនិស្សិត (Firebase Firestore)'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card សម្រាប់បញ្ចូលទិន្នន័យ (Input Form)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'ឈ្មោះនិស្សិត (Name)',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('ភេទ: ', style: TextStyle(fontSize: 16)),
                        Radio<String>(
                          value: 'ប្រុស',
                          groupValue: _selectedGender,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val!),
                        ),
                        const Text('ប្រុស'),
                        Radio<String>(
                          value: 'ស្រី',
                          groupValue: _selectedGender,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val!),
                        ),
                        const Text('ស្រី'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _majorController,
                      decoration: const InputDecoration(
                        labelText: 'ជំនាញសិក្សា (Major)',
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _addStudent,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.add_circle),
                        label: Text(
                          _isLoading ? 'កំពុងបញ្ចូល...' : 'បញ្ចូលទិន្នន័យ (Insert)',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '📋 បញ្ជីទិន្នន័យពី Firebase (Real-time)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            // បង្ហាញបញ្ជីទិន្នន័យផ្ទាល់ពី Firestore (Real-time Stream)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _studentsCollection
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('មិនទាន់មានទិន្នន័យនៅឡើយទេ'),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final name = data['name'] ?? '';
                      final gender = data['gender'] ?? '';
                      final major = data['major'] ?? '';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: gender == 'ប្រុស'
                                ? Colors.blue.shade100
                                : Colors.pink.shade100,
                            child: Icon(
                              gender == 'ប្រុស' ? Icons.male : Icons.female,
                              color: gender == 'ប្រុស'
                                  ? Colors.blue
                                  : Colors.pink,
                            ),
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('ភេទ: $gender | ជំនាញ: $major'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteStudent(doc.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
