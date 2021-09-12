import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:la_queen/screens/image_scren.dart';

class HomeTabMenu extends StatefulWidget {
  @override
  HomeTabMenuState createState() => HomeTabMenuState();
}

class HomeTabMenuState extends State<HomeTabMenu>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController googleMapController) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('loc-1'),
          position: LatLng(45.783282, 15.939329),
          infoWindow: InfoWindow(title: 'Laqueen', snippet: 'Nails salon')));
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            height: 50.0,
            child: new TabBar(
              indicatorColor: Color(0xffFFC592),
              unselectedLabelColor: Colors.grey,
              labelColor: Color(0xffFFC592),
              tabs: [
                Tab(
                  text: "GALERIJA",
                ),
                Tab(
                  text: "INFO",
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xff2d2d2d),
        body: _showTabBar()
      ),
    );
  }

  _showTabBar (){
    return TabBarView(
          children: [
            Container(
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return DetailImageScreen(index: index);
                          }));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image.asset(
                            imageList[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.count(1, index.isEven ? 1.0 : 1.6);
                  }),
            ),
            Card(
              color: Color(0xff404040),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 8.0,
              margin: EdgeInsets.only(top: 8, bottom: 30, left: 10, right: 10),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.7,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: _markers,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(45.783282, 15.939329), zoom: 15),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Color(0xffFFC592)),
                      Text(
                        " Nova cesta 123",
                        style: TextStyle(color: Color(0xffFFC592)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work, color: Color(0xffFFC592)),
                      Text(
                        " 08:00h - 20:00h",
                        style: TextStyle(color: Color(0xffFFC592)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call, color: Color(0xffFFC592)),
                      Text(
                        " +38591/1234-1234",
                        style: TextStyle(color: Color(0xffFFC592)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Color(0xffFFC592)),
                      Text(
                        " laquen@gmail.com",
                        style: TextStyle(color: Color(0xffFFC592)),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        );
  }
}
