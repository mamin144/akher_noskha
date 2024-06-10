import 'package:flutter/material.dart';
import 'package:flutter_application_1/agarly/screens/new/HomeDrawer.dart';
import 'package:flutter_application_1/agarly/screens/new/Search.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

import 'rate and review/reviews_screen.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Map<String, dynamic>>> _dataFuture;
  late List<bool> _isFavorite;

  @override
  void initState() {
    super.initState();
    _dataFuture = getDataFromMongoDB();
    _isFavorite = [];
  }

  Future<List<Map<String, dynamic>>> getDataFromMongoDB() async {
    M.Db db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();

    M.DbCollection collection = db.collection("home_page");
    List<Map<String, dynamic>> data = await collection.find().toList();
    await db.close();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20), // Adjust spacing as needed
          Expanded(
            child: FutureBuilder(
              future: _dataFuture,
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Location: ${item['location']}'),
                                content: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _buildImageWidget(
                                        index), // Show static photo
                                    const SizedBox(
                                        height: 8), // Adjust spacing as needed
                                    SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Price: ${item['price']}'),
                                          Text('City: ${item['city']}'),
                                          Text(
                                              'Number of Rooms: ${item['numberOfRooms']}'),
                                          Text('Features: ${item['features']}'),
                                          Text(
                                              'More Details: ${item['moreDetails']}'),
                                          // Add more widgets to display other data fields as needed
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ReviewsScreens(),
                                        ),
                                      );
                                    },
                                    child: const Text('Rate and Review'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle Rate and Review action
                                      // You can navigate to another screen or perform any other action here
                                    },
                                    child: const Text('Book Now'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Card(
                            color: index % 2 == 0
                                ? Colors.grey[200]
                                : Colors
                                    .grey[300], // Alternate background colors
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildImageWidget(index), // Show static photo

                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Location: ${item['location']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Price: ${item['price']}'),
                                      Text('City: ${item['city']}'),
                                      Text(
                                          'Number of Rooms: ${item['numberOfRooms']}'),
                                      Text('Features: ${item['features']}'),
                                      Text(
                                          'More Details: ${item['moreDetails']}'),
                                      // Add more widgets to display other data fields as needed
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: _isFavorite.isNotEmpty &&
                                              _isFavorite[index]
                                          ? const Icon(Icons.favorite,
                                              color: Colors.red)
                                          : const Icon(Icons.favorite_border),
                                      onPressed: () {
                                        setState(() {
                                          if (_isFavorite.isEmpty) {
                                            _isFavorite = List.generate(
                                                data.length, (_) => false);
                                            print(
                                                'Location: ${item['location']}');
                                            print("in wishlist");
                                          }
                                          _isFavorite[index] =
                                              !_isFavorite[index];
                                          if (_isFavorite[index] == true) {
                                            pushWishListDB(
                                                '${item['location']}');
                                            print(_isFavorite[index]);
                                            print(' ${item['location']}');
                                            print("out of wishlist");
                                          } else {
                                            deleteWishListDB(
                                                '${item['location']}');
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Material(
            borderRadius: BorderRadius.circular(32.0),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(32.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Search()),
                );
                // Handle search action
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 8.0,
                      spreadRadius: 8.0,
                      offset: const Offset(0.0, 4.0),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Where to?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Anywhere • Any week • Add guest',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(int index) {
    // List of static photo URLs
    List<String> photoUrls = [
      "lib/pics/7d1e9881988591.5d107cb99ccd5.jpg",
      "lib/pics/9e024dbdec35e61d972b30db29fe791f.jpg",
      "lib/pics/a2aa15102092091.5f2e72cd61246.jpg",
      "lib/pics/cbc5d1c28dad4852daf611a3278d60f5.jpg",
    ];

    // Ensure index is within bounds
    if (index >= 0 && index < photoUrls.length) {
      return Image.asset(
        photoUrls[index], // Get photo URL at the specified index
        fit: BoxFit.cover,
        height: 200,
      );
    } else {
      return Container(); // Return empty container if index is out of bounds
    }
  }
}

pushWishListDB(String location) async {
  M.Db db = await M.Db.create(
      "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
  await db.open();

  M.DbCollection collection = db.collection("favorite_locations");
  final data = WhishlistDbModel(
    location: location,
  );

  await collection.insert(data.toJson());

  // List<Map<String, dynamic>> data = await collection.find().toList();
  await db.close();
}

class WhishlistDbModel {
  final String location;

  WhishlistDbModel({
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {'location': location};
  }
}

deleteWishListDB(location) async {
  M.Db db = await M.Db.create(
      "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
  await db.open();

  M.DbCollection collection = db.collection("favorite_locations");

  await collection.deleteOne({"location": location});
  await db.close();
}
