import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/address_model.dart';
import 'package:freshmeals/riverpod/providers/auth_providers.dart';
import 'package:freshmeals/riverpod/providers/home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/_api_utls.dart';
import '../../theme/colors.dart';

class AddressPickerScreen extends ConsumerStatefulWidget {
  final Address? address;
  const AddressPickerScreen({super.key, this.address});

  @override
  ConsumerState<AddressPickerScreen> createState() =>
      _AddressPickerScreenState();
}

class _AddressPickerScreenState extends ConsumerState<AddressPickerScreen> {
  late GoogleMapController _mapController;
  LatLng? selectedLocation;
  String? selectedAddress;
  late Country country;
  int _selectedValue = 0; // To track the selected radio button
  String selectedCode = '';
  var phoneController = TextEditingController();

  final TextEditingController searchController = TextEditingController();
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: mapKy);
  final GoogleMapsGeocoding _geocoding = GoogleMapsGeocoding(apiKey: mapKy);
  @override
  void initState() {
    country = CountryService().findByCode("RW")!;
    if (widget.address != null) {
      setState(() {
        selectedAddress = widget.address!.mapAddress;
      });
    }
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var addressState = ref.watch(addressesProvider);
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        leading: InkWell(
          child: Container(
            margin: EdgeInsets.all(5),
            child: CircleAvatar(
              backgroundColor: scaffold,
              child: const Icon(
                Icons.arrow_back_ios,
                // color: Colors.white,
              ),
            ),
          ),
          onTap: () {
            context.pop();
          },
        ),
        // backgroundColor: Colors.transparent,
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
      // extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 50,
                color: Colors.white,
                child: Center(
                  child: Text(
                    widget.address == null
                        ? "Add Delivery Address"
                        : "Update Address",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target:
                        LatLng(-1.94995, 30.05885), // Default location (Kigali)
                    zoom: 12,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: (position) async {
                    // _getAddressDetails(position);
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
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     TextButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           selectedAddress = '';
                      //         });
                      //       },
                      //       child: Text(
                      //         "Clear",
                      //         style: TextStyle(color: secondarTex),
                      //       ),
                      //     ),
                      //     Text(
                      //       widget.address == null
                      //           ? "Add Delivery Address"
                      //           : "Update Address",
                      //       style: const TextStyle(
                      //           fontWeight: FontWeight.bold, fontSize: 16),
                      //     ),
                      //     TextButton(
                      //       onPressed: () {
                      //         if (_formKey.currentState!.validate()) {
                      //           if (widget.address == null) {
                      //             var json = {
                      //               "token": ref.watch(userProvider)!.user!.token,
                      //               "street_number": "KG 41 Rd",
                      //               "house_number": "20",
                      //               "map_address": selectedAddress
                      //             };
                      //             ref
                      //                 .read(addressesProvider.notifier)
                      //                 .addAddress(context, json, ref);
                      //           } else if (widget.address != null) {
                      //             var jsonUpdate = {
                      //               "token": ref.watch(userProvider)!.user!.token,
                      //               "address_id": widget.address!.addressId,
                      //               "street_number": "KG 41 Rd",
                      //               "house_number": "20",
                      //               "map_address": selectedAddress
                      //             };
                      //             ref
                      //                 .read(addressesProvider.notifier)
                      //                 .updateAddress(context, jsonUpdate, ref);
                      //           }
                      //         }
                      //       },
                      //       child: Text(
                      //         widget.address == null ? "Save" : "Update",
                      //         style: const TextStyle(color: primarySwatch),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Green
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey)),
                          ),
                          onPressed: _getCurrentLocation,
                          child: const Text(
                            "Select your current location",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          thickness: 0.3,
                        ),
                      ),
                      TextFormField(
                        readOnly: true,
                        controller:
                            TextEditingController(text: selectedAddress),
                        validator: (s) => s?.trim().isNotEmpty == true
                            ? null
                            : 'Select Address On map',
                        decoration: InputDecoration(
                          hintText: "Select Address on map",
                          suffixIcon: Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: primarySwatch,
                              ),
                              child: const Icon(Icons.location_pin,
                                  color: Colors.white)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarySwatch, // Green
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.address == null) {
                                var json = {
                                  "token": ref.watch(userProvider)!.user!.token,
                                  "street_number": "KG 41 Rd",
                                  "house_number": "20",
                                  "map_address": selectedAddress
                                };
                                ref
                                    .read(addressesProvider.notifier)
                                    .addAddress(context, json, ref);
                              } else if (widget.address != null) {
                                var jsonUpdate = {
                                  "token": ref.watch(userProvider)!.user!.token,
                                  "address_id": widget.address!.addressId,
                                  "street_number": "KG 41 Rd",
                                  "house_number": "20",
                                  "map_address": selectedAddress
                                };
                                ref
                                    .read(addressesProvider.notifier)
                                    .updateAddress(context, jsonUpdate, ref);
                              }
                            }
                          },
                          child: addressState!.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  widget.address == null
                                      ? "Save address"
                                      : "Update Addres",
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                      ),

                      // Row(
                      //   children: [
                      //     // const SizedBox(
                      //     //   width: 20,
                      //     // ),
                      //     // Flexible(
                      //     //   child: DropdownButtonFormField<String>(
                      //     //     items: ['Time Slot 1', 'Time Slot 2', 'Time Slot 3']
                      //     //         .map((slot) => DropdownMenuItem(
                      //     //               value: slot,
                      //     //               child: Text(slot),
                      //     //             ))
                      //     //         .toList(),
                      //     //     onChanged: (value) {},
                      //     //     decoration: InputDecoration(
                      //     //       hintText: 'Name of Address',
                      //     //       border: OutlineInputBorder(
                      //     //         borderRadius: BorderRadius.circular(8),
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      // TextFormField(
                      //   readOnly: true,
                      //   controller: TextEditingController(text: selectedCode),
                      //   decoration: InputDecoration(
                      //     hintText: "Street code",
                      //     filled: true,
                      //     fillColor: Colors.white,
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(30),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // PhoneField(
                      //   country: country,
                      //   controller: phoneController,
                      //   callback: (Country country) {
                      //     setState(() {
                      //       this.country = country;
                      //     });
                      //   },
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Radio<int>(
                      //       value: 1,
                      //       groupValue: _selectedValue,
                      //       onChanged: (int? value) {
                      //         setState(() {
                      //           _selectedValue = value!;
                      //         });
                      //       },
                      //     ),
                      //     const Text(
                      //       'Default Delivery Address',
                      //       style: TextStyle(fontSize: 16.0),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
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
          selectedCode =
              response.results.first.addressComponents.first.shortName;
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

  // Future<void> _getAddressDetails(LatLng position) async {
  //   try {
  //     final response = await _geocoding.searchByLocation(
  //       Location(lat: position.latitude, lng: position.longitude),
  //     );
  //
  //     if (response.status == "OK" && response.results.isNotEmpty) {
  //       final addressComponents = response.results.first.addressComponents;
  //
  //       // Extract street number and street name
  //       String? streetNumber;
  //       String? streetName;
  //       print(addressComponents[0].shortName);
  //       for (var component in addressComponents) {
  //         if (component.types.contains('street_number')) {
  //           streetNumber = component.longName;
  //         }
  //         if (component.types.contains('route')) {
  //           streetName = component.longName;
  //         }
  //       }
  //
  //       // Generate Google Maps link
  //       final googleMapsLink =
  //           'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
  //
  //       setState(() {
  //         selectedAddress = '${streetNumber ?? ''} ${streetName ?? ''}'
  //             .trim(); // Street address
  //       });
  //       // print(googleMapsLink);
  //       // showDialog(
  //       //   context: context,
  //       //   builder: (_) => AlertDialog(
  //       //     title: const Text('Location Details'),
  //       //     content: Column(
  //       //       mainAxisSize: MainAxisSize.min,
  //       //       crossAxisAlignment: CrossAxisAlignment.start,
  //       //       children: [
  //       //         Text('Street Number: ${streetNumber ?? "Not available"}'),
  //       //         Text('Street Name: ${streetName ?? "Not available"}'),
  //       //         Text('Google Maps Link:'),
  //       //         GestureDetector(
  //       //           onTap: () => _launchURL(googleMapsLink),
  //       //           child: Text(
  //       //             googleMapsLink,
  //       //             style: const TextStyle(
  //       //               color: Colors.blue,
  //       //               decoration: TextDecoration.underline,
  //       //             ),
  //       //           ),
  //       //         ),
  //       //       ],
  //       //     ),
  //       //     actions: [
  //       //       TextButton(
  //       //         onPressed: () => Navigator.pop(context),
  //       //         child: const Text('Close'),
  //       //       ),
  //       //     ],
  //       //   ),
  //       // );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Unable to fetch address.')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching address: $e')),
  //     );
  //   }
  // }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')),
      );
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      selectedLocation = LatLng(position.latitude, position.longitude);
    });

    // Move the map to the new position
    _mapController.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );

    await _getAddressFromCoordinates(selectedLocation!);
  }
}
