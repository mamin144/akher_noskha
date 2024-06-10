import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

var db, homepage_collection;

class HomepageMongoDbModel {
  final String location;
  final String price;
  final String city;
  final String numberOfRooms;
  final String features;
  final String moreDetails;

  HomepageMongoDbModel({
    required this.location,
    required this.price,
    required this.city,
    required this.numberOfRooms,
    required this.features,
    required this.moreDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'price': price,
      'city': city,
      'numberOfRooms': numberOfRooms,
      'features': features,
      'moreDetails': moreDetails,
    };
  }
}

class UploadDataPage extends StatefulWidget {
  const UploadDataPage({super.key});

  @override
  _UploadDataPageState createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController numberOfRoomsController = TextEditingController();
  final TextEditingController featuresController = TextEditingController();
  final TextEditingController moreDetailsController = TextEditingController();

  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid price';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? _validateNumberOfRooms(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of rooms is required';
    }
    if (int.tryParse(value) == null) {
      return 'Invalid number of rooms';
    }
    return null;
  }

  String? _validateFeatures(String? value) {
    if (value == null || value.isEmpty) {
      return 'Features are required';
    }
    return null;
  }

  String? _validateMoreDetails(String? value) {
    if (value == null || value.isEmpty) {
      return 'More details are required';
    }
    return null;
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      // Call your custom function to post homepage data to MongoDB
      await postHomepageData(
        locationController.text,
        priceController.text,
        cityController.text,
        numberOfRoomsController.text,
        featuresController.text,
        moreDetailsController.text,
      );
      // Data saved successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data saved successfully'),
        ),
      );
    }
  }

  Future<void> postHomepageData(
    String location,
    String price,
    String city,
    String numberOfRooms,
    String features,
    String moreDetails,
  ) async {
    // Your code to post homepage data to MongoDB
    // Replace the following line with your actual implementation
    db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();
    inspect(db);

    homepage_collection = db.collection("home_page");
    final data = HomepageMongoDbModel(
      location: location,
      price: price,
      city: city,
      numberOfRooms: numberOfRooms,
      features: features,
      moreDetails: moreDetails,
    );
    await homepage_collection.insert(data.toJson());
    print(
        "Data updated: {location: $location, price: $price, city: $city, numberOfRooms: $numberOfRooms, features: $features, moreDetails: $moreDetails}");
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateLocation,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validatePrice,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateCity,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: numberOfRoomsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Rooms',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateNumberOfRooms,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: featuresController,
                  decoration: const InputDecoration(
                    labelText: 'Features',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: _validateFeatures,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: moreDetailsController,
                  decoration: const InputDecoration(
                    labelText: 'More Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: _validateMoreDetails,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // background color
                    elevation: 5, // adds elevation/shadow
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15), // button padding
                  ),
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UploadDataPage(),
  ));
}
