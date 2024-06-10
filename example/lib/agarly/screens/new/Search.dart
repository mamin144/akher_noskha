import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int currentIndex = 0;
  String buildingType = "Villa";
  int selectedBedrooms = 1;
  int selectedBathrooms = 1;
  int selectedArea = 1;
  int selectedLevel = 1;

  // List of locations in Egypt
  List<String> locations = [
    'Cairo',
    'Alexandria',
    'Luxor',
    'Aswan',
    'Hurghada',
    'Sharm El Sheikh',
    // Add more locations as needed
  ];

  // Controllers for text fields
  TextEditingController priceController = TextEditingController();
  String selectedLocation = '';
  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Image.asset(
            'lib/pics/apartment2.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                __buildSearchBar(),
                SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.5), // Adjust the height to start from the center
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context)
                      .size
                      .height, // Set height to occupy remaining space
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        // Dropdown for locat'ions
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Please Choose Price',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.59,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF000000),
                                letterSpacing: 0.08,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              32, // Adjust width
                          height: 50, // Adjust height
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedLocation.isNotEmpty
                                  ? selectedLocation
                                  : null, // Initial value
                              onChanged: (String? newValue) {
                                setState(() {
                                  // Handle selected location
                                  // You can store it in a variable if needed
                                  selectedLocation = newValue!;
                                });
                              },
                              items: locations.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Text field for price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Please Choose Price',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.59,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF000000),
                                letterSpacing: 0.08,
                              ),
                            ),
                            TextField(
                              controller: priceController,
                              decoration: InputDecoration(
                                labelText: 'Price',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 7.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('levels'),
                            const SizedBox(width: 10),
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i,
                                    groupValue: selectedLevel,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLevel = value as int;
                                      });
                                    },
                                    activeColor: Colors.black,
                                  ),
                                  Text('$i'),
                                  const SizedBox(width: 10),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Area'),
                            const SizedBox(width: 10),
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i,
                                    groupValue: selectedArea,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedArea = value as int;
                                      });
                                    },
                                    activeColor: Colors.black,
                                  ),
                                  Text('$i'),
                                  const SizedBox(width: 10),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bed),
                            const SizedBox(width: 10),
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i,
                                    groupValue: selectedBedrooms,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBedrooms = value as int;
                                      });
                                    },
                                    activeColor: Colors.black,
                                  ),
                                  Text('$i'),
                                  const SizedBox(width: 10),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bathtub),
                            const SizedBox(width: 10),
                            for (int i = 1; i <= 5; i++)
                              Row(
                                children: [
                                  Radio(
                                    value: i,
                                    groupValue: selectedBathrooms,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedBathrooms = value as int;
                                      });
                                    },
                                    activeColor: Colors.black,
                                  ),
                                  Text('$i'),
                                  const SizedBox(width: 10),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Handle search action here
                            String price = priceController.text;

                            // Do something with location and price
                            print('Location: ${locations[0]}, Price: $price');
                          },
                          child: Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget __buildSearchBar() {
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
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          // Handle text input
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
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
}
