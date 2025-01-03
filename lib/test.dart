import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController mapController = Get.put(HomeScreenController());
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Search and Map'),
        actions: [
          IconButton(
            onPressed: mapController.clearMarkers,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for places...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (query) async {
                if (query.isNotEmpty) {
                  await mapController.searchPlaces(query);
                } else {
                  mapController.predictions.clear();
                }
              },
            ),
          ),
          Obx(() {
            return mapController.predictions.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: mapController.predictions.length,
                    itemBuilder: (context, index) {
                      final prediction = mapController.predictions[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(prediction['description']),
                        onTap: () async {
                          await mapController
                              .handlePlaceSelection(prediction['place_id']);
                        },
                      );
                    },
                  )
                : const SizedBox.shrink();
          }),
          Expanded(
            child: Obx(() {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: mapController.currentPosition.value,
                  zoom: 14.0,
                ),
                onMapCreated: mapController.setMapController,
                markers: mapController.markers,
                onTap: mapController.addMarker,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: mapController.fetchCurrentLocation,
        label: const Text('Refresh Location'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}

class HomeScreenController extends GetxController {
  final String googleApiKey = "Apikeybyaks";
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final currentPosition = LatLng(0, 0).obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxList<dynamic> predictions = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    // Code to fetch the current location...
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

  void addMarker(LatLng position) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: 'Marker',
        snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
      ),
    );
    markers.add(marker);
  }

  void clearMarkers() {
    markers.clear();
    predictions.clear();
  }
}
