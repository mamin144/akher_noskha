import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class WishlistScreen extends StatefulWidget {
  @override
  _WhishlistScreenState createState() => _WhishlistScreenState();
}

class _WhishlistScreenState extends State<WishlistScreen> {
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = wishListData();
  }

  Future<List<Map<String, dynamic>>> getWishListDB() async {
    M.Db db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();

    M.DbCollection collection = db.collection("favorite_locations");
    List<Map<String, dynamic>> data = await collection.find().toList();
    // await db.close();

    return data;
  }

  Future<List<Map<String, dynamic>>> wishListData() async {
    List<Map<String, dynamic>> wishList = await getWishListDB();
    List<Map<String, dynamic>> allData = [];
    M.Db db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();

    M.DbCollection homecollection = db.collection("home_page");
    for (var location in wishList) {
      // print(location["location"]);

      // Define a query to filter documents by the specified location
      var query = M.where.eq('location', location["location"]);

      // Execute the query and convert the results to a list of maps
      List<Map<String, dynamic>> data =
          await homecollection.find(query).toList();

      // Add the data for the current location to the list
      allData.addAll(data);
    }
    await db.close();

    print(allData);
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Card(
                          color: index % 2 == 0
                              ? Colors.grey[200]
                              : Colors.grey[300], // Alternate background colors
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildImageWidget(), // Show static photo
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                                        ElevatedButton(
        onPressed: () {
          _deleteItem('${item['location']}');
          setState(() {
    _dataFuture = wishListData(); // Refresh data future
  });
           
        },
        child: Text('Delete'),
      ),
                                    // Add more widgets to display other data fields as needed
                                  ],
                                ),
                              ),
                              
                               
                            ],
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

  Widget _buildImageWidget() {
    return Image.asset(
      'lib/pics/7d1e9881988591.5d107cb99ccd5.jpg', // Replace with your image path
      fit: BoxFit.cover,
      height: 200,
    );
  }
}









_deleteItem(location) async {

    M.Db db = await M.Db.create("mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();

    M.DbCollection collection = db.collection("favorite_locations");

        await collection.deleteOne({"location":location});
    await db.close();
  }