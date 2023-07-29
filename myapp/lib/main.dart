import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Value Shower',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          accentColor: Colors.amber,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController countryController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingNumberController =
      TextEditingController();
  final TextEditingController suiteController = TextEditingController();

  String selectedCountry = 'Canada';
  final List<String> countries = ['Canada'];

  void navigateToPropertyValuePage() {
    String country = countryController.text;
    String province = provinceController.text;
    String city = cityController.text;
    String street = streetController.text;
    String buildingNumber = buildingNumberController.text;
    String suite = suiteController.text;
    String fullAddress =
        '$suite, $buildingNumber $street, $city, $province, $selectedCountry';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyValuePage(fullAddress),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Enter your address:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCountry,
              onChanged: (newValue) {
                setState(() {
                  selectedCountry = newValue!;
                });
              },
              items: countries.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 12),
            TextFormField(
              controller: provinceController,
              decoration: const InputDecoration(
                labelText: 'Province/State',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: streetController,
              decoration: const InputDecoration(
                labelText: 'Street',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: buildingNumberController,
              decoration: const InputDecoration(
                labelText: 'Building Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: suiteController,
              decoration: const InputDecoration(
                labelText: 'Suite',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: navigateToPropertyValuePage,
              child: const Text('See Property Value'),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyValuePage extends StatelessWidget {
  final String address;
  final MapController mapController = MapController();
  double currentZoom = 10.0;

  PropertyValuePage(this.address);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Value'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onScaleUpdate: (ScaleUpdateDetails details) {},
            ),
            child: FlutterMap(
              options: MapOptions(
                center:
                    const LatLng(0, 0), // Set initial map location to (0, 0)
                zoom: 10.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle City button press
                  },
                  child: const Text('City'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Neighbourhood button press
                  },
                  child: const Text('Neighbourhood'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Building button press
                  },
                  child: const Text('Building'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
