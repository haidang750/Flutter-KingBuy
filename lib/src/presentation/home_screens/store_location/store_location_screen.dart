import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/home_screens/home_screens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/store_model.dart';

class StoreLocationScreen extends StatefulWidget {
  @override
  StoreLocationScreenState createState() => StoreLocationScreenState();
}

class StoreLocationScreenState extends State<StoreLocationScreen> with ResponsiveWidget {
  StoreLocationViewModel storeLocationViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: StoreLocationViewModel(),
        onViewModelReady: (viewModel) => storeLocationViewModel = viewModel..init(),
        builder: (context, viewModel, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ),
            child: Container(
              child: buildUi(context: context),
            )));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: storeLocationViewModel.storeAddressStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Store> listStore = snapshot.data;

          return Container(
              color: AppColors.white,
              child: Stack(children: [
                Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(double.parse(listStore[0].latitude), double.parse(listStore[0].longitude)),
                        zoom: 12,
                      ),
                      markers: Set<Marker>.of(storeLocationViewModel.markers.values),
                      onMapCreated: (GoogleMapController controller) {
                        storeLocationViewModel.googleMapController.complete(controller);
                      },
                    ),
                    GestureDetector(
                        child: Container(
                          height: 78,
                          color: Colors.white.withOpacity(0.6),
                          padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.arrow_back),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                    child: Container(
                        height: 162,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listStore.length,
                          itemBuilder: (context, index) => Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: 162,
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        "${AppEndpoint.BASE_URL}${listStore[index].imageSource}",
                                        height: 100,
                                        width: MediaQuery.of(context).size.width * 0.55,
                                        fit: BoxFit.cover,
                                      ),
                                      Expanded(
                                          child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              alignment: Alignment.centerLeft,
                                              child: Material(
                                                  child:
                                                      Text(listStore[index].address, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  storeLocationViewModel.onTapOneStore(listStore[index]);
                                },
                              ),
                              SizedBox(width: 15)
                            ],
                          ),
                        )))
              ]));
        } else {
          return Container(
            color: AppColors.white,
            alignment: Alignment.center,
            child: MyLoading(),
          );
        }
      },
    );
  }

  @override
  Widget buildDesktop(BuildContext context) {
    // TODO: implement buildDesktop
    return buildScreen();
  }

  @override
  Widget buildMobile(BuildContext context) {
    // TODO: implement buildMobile
    return buildScreen();
  }

  @override
  Widget buildTablet(BuildContext context) {
    // TODO: implement buildTablet
    return buildScreen();
  }
}
