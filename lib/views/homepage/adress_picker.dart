import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geocoding.dart';
import '../../constants/_api_utls.dart';
import '../../theme/colors.dart';
import '../auth/widgets/phone_field.dart';

class AddressPickerScreen extends StatefulWidget {
  @override
  _AddressPickerScreenState createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
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
        title: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search for a location (e.g., Kigali)",
              suffixIcon: InkWell(
                onTap: () => _searchLocation(searchController.text),
                child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primarySwatch,
                    ),
                    child: const Icon(Icons.search, color: Colors.white)),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) => _searchLocation(value)),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            height: 500,
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
          Expanded(
              child: Container(
            padding: EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Clear",
                      style: TextStyle(color: secondarTex),
                    ),
                    Text(
                      "Add New Address",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Save",
                      style: TextStyle(color: primarySwatch),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    thickness: 0.3,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      child: DropdownButtonFormField<String>(
                        items: ['Time Slot 1', 'Time Slot 2', 'Time Slot 3']
                            .map((slot) => DropdownMenuItem(
                                  value: slot,
                                  child: const Icon(
                                    Icons.home,
                                    color: Colors.black54,
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          // hintText: 'Time Slot',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: DropdownButtonFormField<String>(
                        items: ['Time Slot 1', 'Time Slot 2', 'Time Slot 3']
                            .map((slot) => DropdownMenuItem(
                                  value: slot,
                                  child: Text(slot),
                                ))
                            .toList(),
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Name of Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Your Address",
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: primarySwatch,
                          ),
                          child: const Icon(Icons.location_pin,
                              color: Colors.white)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                PhoneField(
                  country: country,
                  controller: phoneController,
                  callback: (Country country) {
                    setState(() {
                      this.country = country;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: _selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      },
                    ),
                    const Text(
                      'Default Delivery Address',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    final response = await _places.searchByText(query);

    if (response.status == "OK" && response.results.isNotEmpty) {
      final place = response.results.first;

      final lat = place.geometry!.location.lat;
      final lng = place.geometry!.location.lng;

      // Move the map to the searched location
      _mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(lat, lng)),
      );

      setState(() {
        selectedLocation = LatLng(lat, lng);
        selectedAddress = place.formattedAddress; // Update the selected address
      });
    } else {
      // Show an error if no results are found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No results found for "$query".')),
      );
    }
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
