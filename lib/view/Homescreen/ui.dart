import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:technoviaapptest/common/commonscaffold/CommonScaffold.dart';
import 'package:technoviaapptest/controller/HomeScreen/controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController mapController = Get.put(HomeScreenController());
    TextEditingController controller = TextEditingController();

    return CommonScaffold(
      useSafeArea: true,
      appbars: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: mapController.clearMarkers,
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: Column(
        children: [
          GooglePlaceAutoCompleteTextField(
            textEditingController: controller,
            googleAPIKey: "AIzaSyBHWsgt8_4qvroXx0-rdyyG24OIts0MRJo",
            inputDecoration: InputDecoration(),
            debounceTime: 800,
            countries: ["in", "fr"],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              LatLng position = LatLng(
                double.parse("${prediction.lat}"),
                double.parse("${prediction.lng}"),
              );
              mapController.addMarker(position);
            },
            itemClick: (Prediction prediction) {
              controller.text = prediction.description!;
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description?.length ?? 0));
            },
            itemBuilder: (context, index, Prediction prediction) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 7),
                    Expanded(child: Text("${prediction.description ?? ""}")),
                  ],
                ),
              );
            },
            seperatedBuilder: Divider(),
            isCrossBtnShown: true,
            containerHorizontalPadding: 10,
            placeType: PlaceType.geocode,
          ),
          Expanded(
            child: Obx(() {
              return GoogleMap(
                mapType: MapType.satellite,
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
          Obx(() {
            return Expanded(
              child: ListView.builder(
                itemCount: mapController.markerList.length,
                itemBuilder: (context, index) {
                  final marker = mapController.markerList[index];
                  return ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(marker.infoWindow.title ?? 'Unknown Location'),
                    subtitle: Text(
                        'Lat: ${marker.position.latitude}, Lng: ${marker.position.longitude}'),
                    onTap: () => mapController.navigateToMarker(marker),
                  );
                },
              ),
            );
          }),
        ],
      ),
      floatloc: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: mapController.fetchCurrentLocation,
        label: const Text('Refresh Location'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}
