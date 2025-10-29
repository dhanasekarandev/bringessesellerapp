import 'dart:developer';
import 'package:bringessesellerapp/presentation/widget/custome_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../config/constant/sharedpreference_helper.dart';

class FullMapScreen extends StatefulWidget {
  const FullMapScreen({super.key});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  LatLng? _selectedPosition;

  String _mainPlaceName = "Tap on the map to select a location";
  String _fullAddress = "";
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    sharedPreferenceHelper = SharedPreferenceHelper();
    _getUserCurrentLocation();
  }

  /// 📍 Get current user location
  Future<void> _getUserCurrentLocation() async {
    final permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _selectedPosition = _currentPosition;
      });
      await _updateAddressFromLatLng(_selectedPosition!);
      _addMarker(_selectedPosition!);
    } else {
      Fluttertoast.showToast(msg: "Location permission denied");
    }
  }

  /// 🧭 Add marker at selected location
  void _addMarker(LatLng position) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId("selected_location"),
          position: position,
          infoWindow: InfoWindow(title: _mainPlaceName),
        ),
      };
    });
  }

  /// 🔄 Convert coordinates to full formatted address
  Future<void> _updateAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        // 🧭 Full readable address
        final fullAddress = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
          place.postalCode,
          place.country
        ].where((e) => e != null && e!.trim().isNotEmpty).join(", ");

        setState(() {
          _mainPlaceName = place.name ?? "Selected Location";
          _fullAddress = fullAddress;
        });

        log("Full Address: $_fullAddress");
      } else {
        setState(() {
          _mainPlaceName = "Address not found";
          _fullAddress = "";
        });
      }
    } catch (e) {
      setState(() {
        _mainPlaceName = "Error getting address";
        _fullAddress = e.toString();
      });
    }
  }

  /// 🔍 Search location by name
  Future<void> _onSearch(String? location) async {
    if (location == null || location.trim().isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final first = locations.first;
        final latLng = LatLng(first.latitude, first.longitude);
        setState(() {
          _selectedPosition = latLng;
        });
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
        await _updateAddressFromLatLng(latLng);
        _addMarker(latLng);
      } else {
        Fluttertoast.showToast(msg: "Location not found");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  void _saveStoreLocation(LatLng latLng, String address) async {
    await sharedPreferenceHelper.saveSearchLat(latLng.latitude.toString());
    await sharedPreferenceHelper.saveSearchLng(latLng.longitude.toString());
    context.pop({
      'lat': latLng.latitude.toString(),
      'lng': latLng.longitude.toString(),
      'address': address,
    });
    Fluttertoast.showToast(
        msg: "Saved: ${latLng.longitude},${latLng.latitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ""),
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _currentPosition!, zoom: 15),
                  onMapCreated: (controller) => _mapController = controller,
                  myLocationEnabled: true,
                  markers: _markers,
                  onTap: (pos) async {
                    _selectedPosition = pos;
                    await _updateAddressFromLatLng(pos);
                    _addMarker(pos);
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(pos),
                    );
                  },
                ),

          // 🧭 Address Display Card (bottom)
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _mainPlaceName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _fullAddress,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black54, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_selectedPosition != null) {
                          _saveStoreLocation(
                              _selectedPosition!,
                              _fullAddress.isNotEmpty
                                  ? _fullAddress
                                  : _mainPlaceName);
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Save this Location"),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔍 Search Bar (top)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search location",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  ),
                ),
                onSubmitted: _onSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
