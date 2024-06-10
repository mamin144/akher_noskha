import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/agarly/screens/new/profilee.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfilePageState(), // Use the stateful widget directly
    );
  }
}

class ProfilePageState extends StatefulWidget {
  @override
  _ProfilePageStateState createState() => _ProfilePageStateState();
}

class _ProfilePageStateState extends State<ProfilePageState> {
  late String email = 'Loading...';
  late String name = 'Loading...';
  late String profilePicture = '';
  late String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentSnapshot documentSnapshot =
            await firestore.collection('users').doc(user.uid).get();
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            email = data['email'] ?? 'No Email';
            name = data['First name'] ?? 'No Name';
            profilePicture = data['profilePicture'] ?? '';
            phoneNumber = data['phone number'] ?? 'No Phone Number';
          });
        } else {
          print('Document does not exist');
        }
      } else {
        print('User not logged in');
      }
    } catch (e, stackTrace) {
      print('Error in fetchData: $e');
      print(stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ProfessionalProfileWidget(
        profilePicture: profilePicture,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      ),
    );
  }
}

class ProfessionalProfileWidget extends StatelessWidget {
  final String profilePicture;
  final String name;
  final String email;
  final String phoneNumber;

  const ProfessionalProfileWidget({
    Key? key,
    required this.profilePicture,
    required this.name,
    required this.email,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  // backgroundImage: profilePicture.isNotEmpty
                  //     ? NetworkImage(profilePicture)
                  //     : AssetImage('assets/placeholder_image.png'), // Placeholder image
                ),
                SizedBox(height: 20),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 10),
                    Text(email),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 10),
                    Text(phoneNumber),
                  ],
                ),
                Column(
                  children: [
                    SettingsFragment(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
