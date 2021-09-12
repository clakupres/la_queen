import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_queen/providers/chart_reservation.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:la_queen/providers/reservations.dart';
import 'package:la_queen/widgets/app_drawer.dart';
import 'package:la_queen/widgets/bottom_app_bar.dart';
import 'package:provider/provider.dart';

class ChartReserationsScreen extends StatefulWidget {
  const ChartReserationsScreen({Key key}) : super(key: key);

  @override
  _ChartReserationsScreenState createState() => _ChartReserationsScreenState();
}

class _ChartReserationsScreenState extends State<ChartReserationsScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Reservations>(context, listen: false)
          .fetchAndSetReservation()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var reservationData = Provider.of<Reservations>(context, listen: false).getChartData();
    List<charts.Series<ChartReservation, String>> _seriesPieData = [];

    _seriesPieData.add(
      charts.Series(
        domainFn: (ChartReservation chartReservatin, _) =>
            chartReservatin.chartDetails,
        measureFn: (ChartReservation chartReservatin, _) =>
            chartReservatin.chartValue,
        colorFn: (ChartReservation chartReservatin, __) =>
            charts.ColorUtil.fromDartColor(chartReservatin.color),
        id: "Status zahtjeva",
        data: reservationData,
        labelAccessorFn: (ChartReservation row, _) => "${row.chartValue}",
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Statistika po statusima",
            style: TextStyle(color: Color(0xff2d2d2d)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFFC592),
          elevation: 20,
        ),
        backgroundColor: Color(0xff2d2d2d),
        body: _isLoading
            ? Center(
                child: Platform.isIOS
                    ? CupertinoTheme(
                        data: CupertinoTheme.of(context)
                            .copyWith(brightness: Brightness.dark),
                        child: CupertinoActivityIndicator())
                    : CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.PieChart(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [
                              new charts.DatumLegend(
                                horizontalFirst: true,
                                desiredMaxRows: 1,
                                outsideJustification:
                                    charts.OutsideJustification.middleDrawArea,
                                cellPadding: new EdgeInsets.only(
                                    right: 4.0, bottom: 4.0, top: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts
                                        .MaterialPalette.gray.shadeDefault,
                                    fontSize: 20),
                              ),
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 90,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      insideLabelStyleSpec:
                                          charts.TextStyleSpec(
                                              fontSize: 20,
                                              color:
                                                  charts.MaterialPalette.black),
                                      labelPosition:
                                          charts.ArcLabelPosition.inside)
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xff2d2d2d),
          ),
          child: AppDrawer(),
        ),
        bottomNavigationBar: BottomNavigationAppBar(0));
  }
}
