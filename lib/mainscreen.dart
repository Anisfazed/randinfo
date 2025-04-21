import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? userData;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    setState(() => errorMessage = '');
    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => userData = data['results'][0]);
      } else {
        setState(() => errorMessage = 'Failed to load user data.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCBE7B8),
      appBar: AppBar(
        backgroundColor:Colors.white70,
        title: const Text('Random User Info'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: userData != null
              ? _buildUserCard()
              : errorMessage.isNotEmpty
                  ? Text(errorMessage, style: const TextStyle(color: Colors.red))
                  : const CircularProgressIndicator(),
        ),
      ),
    );
  }
  
  Widget _buildUserCard() {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userData!['picture']?['large'] != null)
              CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(userData!['picture']['large']),
              ),
            const SizedBox(height: 20),
            Text(
              '${userData!['name']?['first'] ?? ''} ${userData!['name']?['last'] ?? ''}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _infoText(userData!['email']),
            _infoText(userData!['phone']),
            _infoText(userData!['location']?['city']),
            const Divider(height: 30),
            _infoText('Username: ${userData!['login']?['username']}'),
            _infoText('Gender: ${userData!['gender']}'),
            _infoText('DOB: ${userData!['dob']?['date']?.substring(0, 10)}'),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: fetchUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFF48E),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text("Fetch New User"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText(String? text) {
    return Text(
      text ?? '',
      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
      textAlign: TextAlign.center,
    );
  }
}
