import 'package:dev_mobile/components/search_item/search_item_component.dart';
import 'package:dev_mobile/models/directions_model.dart';
import 'package:dev_mobile/models/house_model.dart';
import 'package:dev_mobile/providers/location_providers.dart';
import 'package:dev_mobile/services/services.dart';
import 'package:dev_mobile/utils/api.dart';
import 'package:dev_mobile/utils/constants.dart';
import 'package:dev_mobile/utils/directions_repository.dart';
import 'package:dev_mobile/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  var searchController = TextEditingController();
  List<Widget> listData = [];
  List<Widget> listDataDisekitar = [];
  List<HouseModel> listDisekitar = [];
  bool isLoading = false;

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await Services.instance.getHouses();

    final msg = response['message'];
    final status = response['status'];
    final data = response['data'];
    data.forEach((api) {
      listData.add(_cardItem(HouseModel.fromJson(api)));
      listDataDisekitar.add(_cardItemDisekitar(HouseModel.fromJson(api)));
      listDisekitar.add(HouseModel.fromJson(api));
    });

    setState(() {
      isLoading = false;
    });
  }

  getCoder() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print(position);

    final coordinates =
        await Coordinates(position.latitude, position.longitude);

    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    print(address.first.addressLine);
  }

  @override
  Widget build(BuildContext context) {
    setupScreenUtil(context);
    setStatusBar(brightness: Brightness.light);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: identityColor,
        elevation: 0,
        title: SearchItem(controller: searchController),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: identityColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _locationWidget(),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Rumah Disekitar anda',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 250,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: isLoading
                            ? [CircularProgressIndicator()]
                            : listDataDisekitar,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Rekomendasi Rumah',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 0.82,
                        children: List.generate(listDisekitar.length, (index) {
                          return _cardItemDisekitar(listDisekitar[index]);
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              bottom: 20,
              child: Container(
                color: Colors.transparent,
                width: deviceWidth(),
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4.0,
                          offset: Offset(0, 1),
                        ),
                      ]),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          RouterGenerator.signinScreen,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: identityColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Booking'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: identityColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.history_edu,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Riwayat'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: identityColor,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Akun'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
        alignment: AlignmentDirectional.bottomCenter,
      ),
    );
  }
}

Widget _customScrollView(bool isLoading, List listData) {
  return CustomScrollView(
    physics: BouncingScrollPhysics(),
    slivers: <Widget>[
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildListDelegate(
          isLoading ? [BodyWidget(Colors.red)] : listData,
        ),
      ),
    ],
  );
}

Widget _cardItemDisekitar(HouseModel data) {
  return Container(
    padding: EdgeInsets.all(10),
    child: InkWell(
      onTap: () => print(data.id),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3.0,
                blurRadius: 5.0,
              )
            ],
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
              child: Image.network(
                Api().baseUrlImg + data.image,
                fit: BoxFit.cover,
                width: 210,
                height: 90,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    formatRupiah(data.price),
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${data.bedroom} Beds, ${data.bathroom} Baths, ${data.area} Sqft',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: identityColor,
                        size: 14,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        data.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _cardItem(HouseModel data) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: InkWell(
      onTap: () => print(data.id),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3.0,
                blurRadius: 5.0,
              )
            ],
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
              child: Image.network(
                Api().baseUrlImg + data.image,
                fit: BoxFit.cover,
                width: 210,
                height: 120,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    formatRupiah(data.price),
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${data.bedroom} Beds, ${data.bathroom} Baths, ${data.area} Sqft',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: identityColor,
                        size: 14,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        data.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _locationWidget() {
  return Container(
    color: identityColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.location_on, color: Colors.white, size: 25),
            SizedBox(width: 5),
            Consumer<LocationProvider>(
              builder: (context, locationProv, _) {
                //* If location address stil null

                if (locationProv.address == null) {
                  locationProv.loadLocation();
                  return CircularProgressIndicator();
                }

                return Expanded(
                  child: Text(
                    locationProv.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            )
          ],
        ),
        Divider(color: Colors.white38),
      ],
    ),
  );
}

class BodyWidget extends StatelessWidget {
  final Color color;

  BodyWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: color,
      alignment: Alignment.center,
    );
  }
}
