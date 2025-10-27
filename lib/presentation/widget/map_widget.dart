import 'dart:developer';

import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class FullMapScreen extends StatefulWidget {
  const FullMapScreen({super.key});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  late SharedPreferenceHelper sharedPreferenceHelper;
  @override
  void initState() {
    sharedPreferenceHelper = SharedPreferenceHelper();
    sharedPreferenceHelper.init();
    super.initState();
    _checkPermissionAndLocate();
  }

  Future<void> _checkPermissionAndLocate() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enable location services.")),
      );
      setState(() => _isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location permission permanently denied. Please enable it in settings.",
          ),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied.")),
      );
      setState(() => _isLoading = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );
      _isLoading = false;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_currentPosition!),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: const InfoWindow(title: "Selected Location"),
      ));
    });
  }

  LatLng? _searchedPosition;
  void _onSearch(String? location) async {
    if (location == null || location.trim().isEmpty) return;

    try {
      // Get coordinates for entered location
      List<Location> locations = await locationFromAddress(location);

      if (locations.isNotEmpty) {
        final firstLocation = locations.first;
        final searchedLatLng =
            LatLng(firstLocation.latitude, firstLocation.longitude);
        log("Searched Location: $searchedLatLng");

        setState(() {
          _searchedPosition = searchedLatLng;

          // Add marker to map
          _markers.add(
            Marker(
              markerId: MarkerId(location),
              position: searchedLatLng,
              infoWindow: InfoWindow(title: location),
            ),
          );
        });

        // Move map camera to searched location
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(searchedLatLng, 14),
        );

        // Show confirmation dialog
        _showSaveLocationDialog(location, searchedLatLng);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _showSaveLocationDialog(String locationName, LatLng latLng) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Save Store Location"),
        content: Text(
            "Do you want to save \"$locationName\" as your store location?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveStoreLocation(latLng, locationName);
            },
            child: const Text("Yes, Save"),
          ),
        ],
      ),
    );
  }

  void _saveStoreLocation(LatLng latLng, String locationName) {
    log("Store location saved: $locationName (${latLng.latitude}, ${latLng.longitude})");

    Fluttertoast.showToast(msg: "Store location saved successfully!");
  }

  @override
  Widget build(BuildContext context) {
    print('sdfsj${_currentPosition}');
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : (_currentPosition == null)
                ? const Center(child: Text("Unable to get location"))
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition!,
                          zoom: 14,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        onTap: _onTap,
                      ),
                      Positioned(
                        top: 20.h,
                        left: 60.w,
                        right: 10.w,
                        child: Row(
                          children: [
                            Container(
                              height: 50.h,
                              width: 260.w,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      textInputAction: TextInputAction.search,
                                      onSubmitted: (_) =>
                                          _onSearch(_searchController.text),
                                      decoration: InputDecoration(
                                        hintText: "Search location...",
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.search,
                                              color: Colors.grey),
                                          onPressed: () =>
                                              _onSearch(_searchController.text),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 25.h,
                        left: 10.w,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Container(
                            height: 40.h,
                            width: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: AppTheme.textColor,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        floatingActionButton: (_currentPosition != null)
            ? FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () async {
                  if (_currentPosition == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Current location not available")),
                    );
                    return;
                  }

                  // Ask confirmation before saving
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Save Current Location"),
                      content: const Text(
                        "Do you want to use your current location as the store location?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Yes, Save"),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return; // user cancelled

                  // Animate map to current location
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(_currentPosition!),
                  );

                  // Save location
                  final currentLat = _currentPosition!.latitude;
                  final currentLng = _currentPosition!.longitude;

                  await sharedPreferenceHelper
                      .saveCurrentLat(currentLat.toString());
                  await sharedPreferenceHelper
                      .saveCurrentLng(currentLng.toString());

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Store location saved successfully")),
                  );
                },
              )
            : null,
      ),
    );
  }
}
