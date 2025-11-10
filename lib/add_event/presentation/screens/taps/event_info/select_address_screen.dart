import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../../../../core/app_util.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../controller/add_event_cubit.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  late final GoogleMapController googleMapController;

  late LatLng _currentLocation;
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = AddEventCubit.get(context);
    return Scaffold(
      body: Column(
        children: [
          // customAppBar(title: "selectAddress".tr(),backgroundColor: AppUI.mainColor,textColor: AppUI.whiteColor),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(24.774265, 46.738586), zoom: 8),
                  onMapCreated: (map) {
                    googleMapController = map;
                    getCurrentPosition();
                  },
                  // polylines: polyline==null?{}:{
                  //   Polyline(
                  //     polylineId: PolylineId('overview_polyline${widget.orderId}'),
                  //     color: Colors.red,
                  //     width: 2,
                  //     points: polyline
                  //         .map((e) => LatLng(e.latitude, e.longitude))
                  //         .toList(),
                  //   ),
                  // },
                  myLocationButtonEnabled: false,

                  myLocationEnabled: true,
                  onCameraMove: (CameraPosition position) {
                    _currentLocation = position.target;
                  },
                ),
                InkWell(
                    onTap: () async {
                      cubit.address.text =
                          await AppUtil.getAddress(_currentLocation);
                      if (mounted) {
                        AppUtil.dialog2(context, cubit.address.text, []);
                      }
                    },
                    child: SvgPicture.asset(
                      "${AppUI.iconPath}destination.svg",
                      height: 50,
                    )),
                Positioned(
                  bottom: 13,
                  left: AppUtil.rtlDirection(context) ? 10 : 0,
                  child: Row(
                    children: [
                      CustomCard(
                        radius: 26,
                        color: AppUI.whiteColor,
                        child: const Icon(
                          Icons.location_searching,
                          color: AppUI.buttonColor,
                        ),
                        onTap: () {
                          getCurrentPosition();
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: AppUtil.responsiveWidth(context) * 0.76,
                          child: CustomButton(
                            text: 'select'.tr(),
                            onPressed: () async {
                              // cubit.address.text = await AppUtil.getAddress(_currentLocation);
                              cubit.location = _currentLocation;
                              // if(!mounted)return;
                              Navigator.pop(cubit.scaffoldKey.currentContext!);
                              AppUtil.successToast(
                                  context, 'locationPicked'.tr());
                            },
                          )),
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: placesAutoCompleteTextField(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getCurrentPosition() async {
    Position position = await AppUtil.determinePosition();
    _currentLocation = LatLng(position.latitude, position.longitude);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: 9)));
    setState(() {});
  }

  placesAutoCompleteTextField() {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: searchController,
      googleAPIKey: "AIzaSyB_kmd43O9dxVxT0uF6R2HHup9TwMg3INs",
      inputDecoration: InputDecoration(
        hintText: 'Enter  the address'.tr(),
        hintStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        fillColor: Colors.white,
      ),
      debounceTime: 400,
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        _currentLocation = LatLng(
            double.parse(prediction.lat!), double.parse(prediction.lng!));

        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentLocation, zoom: 18)));
        setState(() {});
      },

      itemClick: (Prediction prediction) {
        searchController.text = prediction.description ?? "";
        searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0));
      },
      seperatedBuilder: const Divider(),
      containerHorizontalPadding: 10,

      // OPTIONAL// If you want to customize list view item builder
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Text(prediction.description ?? ""),
        );
      },

      isCrossBtnShown: false,

      // default 600 ms ,
    );
  }
}




// CustomInput(
//                       controller: searchController,
//                       onChange: (v) async {
//                         List<Location> locations = await locationFromAddress(
//                           v,
//                         );
//                         googleMapController.animateCamera(
//                             CameraUpdate.newCameraPosition(CameraPosition(
//                                 target: LatLng(locations[0].latitude,
//                                     locations[0].longitude),
//                                 zoom: 18)));
//                       },
//                       onSubmit: (v) async {
//                         List<Location> addresses = await locationFromAddress(
//                           v,
//                         );
//                         // var addresses = await Geocoder.local.findAddressesFromQuery(v);
//                         var first = addresses.first;
//                         // print("${first.featureName} : ${first.coordinates}");
//                         googleMapController.animateCamera(
//                             CameraUpdate.newCameraPosition(CameraPosition(
//                                 target: LatLng(first.latitude, first.longitude),
//                                 zoom: 18)));
//                       },
//                       textInputType: TextInputType.text,
//                       prefixIcon: const Icon(
//                         Icons.search,
//                         color: AppUI.iconColor,
//                         size: 30,
//                       ),
//                       hint: "searchLocation".tr(),
//                     )