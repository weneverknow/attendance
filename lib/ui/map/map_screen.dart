import 'package:attendance/constants.dart';
import 'package:attendance/models/company.dart';
import 'package:attendance/controller/company_controller.dart';
import 'package:attendance/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _gmapController;
  CameraPosition? _cameraPosition;

  Marker? pinCompany;

  String? address;

  final _companyController = Get.find<CompanyController>();

  @override
  void initState() {
    setCameraPosition();
    super.initState();
  }

  setCameraPosition() async {
    var location = await LocationService.getLocation();
    if (location != null) {
      _cameraPosition = CameraPosition(
          target: LatLng(location.latitude!, location.longitude!), zoom: 14);
      setState(() {});
    }
  }

  void makeMark(LatLng pos) async {
    pinCompany = Marker(
        markerId: MarkerId('my-company'),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: 'My Company'));
    List<Placemark> place =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    address = (place[0].street ?? '') +
        " " +
        (place[0].administrativeArea ?? '') +
        " " +
        (place[0].subAdministrativeArea ?? '') +
        " " +
        (place[0].locality ?? '') +
        " " +
        (place[0].subLocality ?? '');
    Company.address = address;
    Company.location = LatLng(pos.latitude, pos.longitude);
    _companyController.address.value = address ?? '';
    _companyController.latitude.value = pos.latitude;
    _companyController.longitude.value = pos.longitude;
    _gmapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(pos.latitude, pos.longitude), tilt: 50, zoom: 25)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _cameraPosition == null
            ? const SizedBox.shrink()
            : GoogleMap(
                initialCameraPosition: _cameraPosition!,
                onMapCreated: (controller) => _gmapController = controller,
                onLongPress: makeMark,
                zoomControlsEnabled: false,
                markers: {if (pinCompany != null) pinCompany!},
              ),
        // _cameraPosition == null
        //     ? const SizedBox.shrink()
        //     : SafeArea(
        //         child: GestureDetector(
        //           onTap: searchLocation,
        //           child: Container(
        //             height: 60,
        //             width: 350,
        //             margin: const EdgeInsets.symmetric(
        //                 horizontal: defaultPadding * 2,
        //                 vertical: defaultPadding),
        //             padding: const EdgeInsets.all(defaultPadding / 2),
        //             decoration: BoxDecoration(
        //                 border: Border.all(
        //                     color: Color.fromARGB(255, 66, 66, 66), width: 0.6),
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(10)),
        //             child: Center(
        //                 child: Text(address ?? 'tap to search location')),
        //           ),
        //         ),
        //       ),
        _cameraPosition == null
            ? const SizedBox.shrink()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 60,
                      width: 350,
                      margin: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                          vertical: defaultPadding),
                      padding: const EdgeInsets.all(defaultPadding / 2),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 66, 66, 66),
                              width: 0.6),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                              address ?? 'long press on map to set location')),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff494848)),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("USE THIS LOCATION")),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                  ],
                ),
              )
      ],
    ));
  }

  searchLocation() async {
    const kGoogleApiKey = "AIzaSyAKTdblujcF-OGf3sVCkNop5usmLjW_WkA";
    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    //var res = await places.autocomplete("bangil");
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        //types: <String>["establishment"],
        types: [],
        mode: Mode.overlay, // Mode.fullscreen
        language: "id",
        strictbounds: false,
        components: [Component(Component.country, "id")]);
    print("REFERENCE ${p?.reference!}");

    PlacesDetailsResponse pd = await places
        .getDetailsByPlaceId(p!.reference!, language: "id")
        .catchError((err) {
      debugPrint("detail error ${err.toString()}");
    });
    print("ID: ${p.id}");
    print(
        "RESULT: ${pd.result.name} ${p.description} ${pd.result.geometry!.location.lat} ${pd.result.geometry!.location.lng} ");

    setState(() {
      address = p.description;
      //lat = pd.result.geometry!.location.lat;
      //lng = pd.result.geometry!.location.lng;
    });
  }
}
