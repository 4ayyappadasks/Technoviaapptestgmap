import 'dart:async';
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomeScreenController extends GetxController {
  final String googleApiKey = "Apikeybyaks";
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final currentPosition = LatLng(0, 0).obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxList<Marker> markerList = <Marker>[].obs;
  final RxList<dynamic> predictions = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permission is required.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
            'Permission Denied', 'Enable location permissions from settings.');
        return;
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update position
      currentPosition.value = LatLng(position.latitude, position.longitude);

      // Animate camera to current location
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition.value, zoom: 14.0),
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Unable to fetch location: $e');
    }
  }

  void setMapController(GoogleMapController controller) {
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }
  }

  Future<void> searchPlaces(String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      predictions.value = data['predictions'];
    } else {
      Get.snackbar('Error', 'Failed to fetch place predictions');
    }
  }

  Future<void> handlePlaceSelection(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      LatLng position = LatLng(location['lat'], location['lng']);
      addMarker(position);

      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 16.0),
        ),
      );
    } else {
      Get.snackbar('Error', 'Failed to fetch place details');
    }
  }

  /// Adds a marker at the tapped location and refreshes the map
  void addMarker(LatLng position) async {
    try {
      // Fetch place name using reverse geocoding
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      String locationName = placemarks.isNotEmpty
          ? placemarks.first.name ?? 'Unknown Location'
          : 'Unknown Location';

      // Create a marker with the fetched location name
      final marker = Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(
          title: locationName,
          snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
        ),
      );

      markers.add(marker); // Add to map markers
      markerList.add(marker); // Add to list view markers
      refreshMap();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch location name: $e');
    }
  }

  void navigateToMarker(Marker marker) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: marker.position, zoom: 16.0),
      ),
    );
  }

  /// Clears all markers and refreshes the map
  void clearMarkers() {
    markers.clear();
    predictions.clear();
    markerList.clear();
    refreshMap();
  }

  void clearpredictions() {
    predictions.clear();
  }

  /// Refreshes the map
  void refreshMap() {
    currentPosition.refresh(); // Trigger refresh for map reloading
  }
}
