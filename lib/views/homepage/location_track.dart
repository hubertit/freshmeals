import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:freshmeals/constants/_assets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geocoding.dart';
import '../../constants/_api_utls.dart';
import '../../theme/colors.dart';

class LocationTrackScreen extends StatefulWidget {
  @override
  _LocationTrackScreenState createState() => _LocationTrackScreenState();
}

class _LocationTrackScreenState extends State<LocationTrackScreen> {
  late GoogleMapController _mapController;
  LatLng? selectedLocation;
  String? selectedAddress;
  late Country country;
  int _selectedValue = 0; // To track the selected radio button

  var phoneController = TextEditingController();

  final TextEditingController searchController = TextEditingController();
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: mapKy);
  final GoogleMapsGeocoding _geocoding = GoogleMapsGeocoding(apiKey: mapKy);
  @override
  void initState() {
    country = CountryService().findByCode("RW")!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            context.pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-1.94995, 30.05885), // Default location (Kigali)
                zoom: 12,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onTap: (position) async {
                setState(() {
                  selectedLocation = position;
                });
                await _getAddressFromCoordinates(position);
              },
              markers: selectedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selectedLocation'),
                        position: selectedLocation!,
                      ),
                    }
                  : {},
            ),
          ),
          Positioned(
            bottom: 80,
            right: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shipper Information",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: secondarTex,
                        fontSize: 16),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      thickness: 0.3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                          AssetsUtils.profile,
                        ),
                        radius: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "John Doe",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "+250788000000",
                            style: TextStyle(color: secondarTex),
                          )
                        ],
                      ),
                      const Spacer(),
                      smallBox(Colors.blue, Icons.call),
                      const SizedBox(
                        width: 10,
                      ),
                      smallBox(primarySwatch, Icons.chat_bubble)
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      thickness: 0.3,
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Estimated Time",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "42 mins",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget smallBox(Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Future<void> _getAddressFromCoordinates(LatLng position) async {
    try {
      final response = await _geocoding.searchByLocation(
        Location(lat: position.latitude, lng: position.longitude),
      );

      if (response.status == "OK" && response.results.isNotEmpty) {
        setState(() {
          selectedAddress = response.results.first.formattedAddress;
        });
      } else {
        setState(() {
          selectedAddress = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to fetch address.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching address: $e')),
      );
    }
  }
}
