import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technoviaapptest/common/CommonText/CommonTextwidget.dart';
import 'package:technoviaapptest/common/Navigation/nav.dart';
import 'package:technoviaapptest/common/commonscaffold/CommonScaffold.dart';
import 'package:technoviaapptest/controller/HomeScreen/controller.dart';
import 'package:technoviaapptest/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController mapController = Get.put(HomeScreenController());
    TextEditingController searchController = TextEditingController();

    return CommonScaffold(
      backgroundColor: Color(0xFFFFFFFF),
      useSafeArea: true,
      body: SizedBox(
        height: MyApp.height,
        width: MyApp.width,
        child: Stack(
          children: [
            Obx(() {
              return SizedBox(
                width: MyApp.width,
                height: MyApp.height,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.satellite,
                      initialCameraPosition: CameraPosition(
                        target: mapController.currentPosition.value,
                        zoom: 14.0,
                      ),
                      onMapCreated: mapController.setMapController,
                      markers: mapController.markers,
                      onTap: (argument) {
                        mapController.addMarker(argument);
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                    Positioned(
                      top: MyApp.height * .06,
                      right: 0,
                      left: 0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MyApp.width,
                              height: MyApp.height * .08,
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search for places...',
                                  fillColor: Color(0xFFFFFFFF),
                                  filled: true,
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
                          ),
                          Obx(() {
                            return mapController.predictions.isNotEmpty &&
                                    searchController.text.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      width: MyApp.width,
                                      height: MyApp.height * .3,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFD3D3D3),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            mapController.predictions.length,
                                        itemBuilder: (context, index) {
                                          final prediction =
                                              mapController.predictions[index];
                                          return ListTile(
                                            leading:
                                                const Icon(Icons.location_on),
                                            title:
                                                Text(prediction['description']),
                                            onTap: () async {
                                              await mapController
                                                  .handlePlaceSelection(
                                                      prediction['place_id']);
                                              mapController.clearpredictions();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            Positioned(
              bottom: MyApp.height * .05,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MyApp.height * .1,
                  width: MyApp.height * .1,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Color(0xFFC7C7C7),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFFFFFFFF),
                        child: IconButton(
                          onPressed: () {
                            mapController.clearMarkers();
                            searchController.clear();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                      // CircleAvatar(
                      //   backgroundColor: Color(0xFFFFFFFF),
                      //   child: IconButton(
                      //     onPressed: () {
                      //       mapController.fetchCurrentLocation();
                      //     },
                      //     icon: Icon(Icons.refresh),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => Positioned(
                  top: MyApp.height * .01,
                  left: MyApp.width * .05,
                  child: CircleAvatar(
                      backgroundColor: Color(0xFFFFFFFF),
                      child: IconButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: "Locations",
                            backgroundColor: const Color(0xFFFFFFFF),
                            content: Container(
                              height: 100,
                              width: 200,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: mapController.markerList.length,
                                itemBuilder: (context, index) {
                                  final marker =
                                      mapController.markerList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Color(0xFFFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xFFC5C5C5),
                                              blurRadius: 2,
                                              offset: Offset(0, 1))
                                        ]),
                                    child: ListTile(
                                      leading: const Icon(Icons.location_on),
                                      title: Text(marker.infoWindow.title ??
                                          'Unknown Location'),
                                      subtitle: Text(
                                          'Lat: ${marker.position.latitude}, Lng: ${marker.position.longitude}'),
                                      onTap: () {
                                        mapController.navigateToMarker(marker);
                                        NavigationService.back();
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        icon: Badge(
                          label: CommonText(
                            text: "${mapController.markerList.length}",
                          ),
                          child: const Icon(Icons.data_object),
                        ),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
