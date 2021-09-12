import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:la_queen/providers/auth.dart';
import 'package:la_queen/providers/reservation.dart';
import 'package:la_queen/providers/reservations.dart';
import 'package:la_queen/screens/stepper_reservation_screen.dart';
import 'package:provider/provider.dart';

enum Services { gel, trajni_lak, pedikura, manikura }
enum NailSizes { mali, srednji, veliki, extra_veliki }

class StepperReservation extends StatefulWidget {
  const StepperReservation({Key key}) : super(key: key);

  @override
  _StepperReservation createState() => _StepperReservation();
}

class _StepperReservation extends State<StepperReservation> {
  int _index = 0;
  Services _character = Services.gel;
  NailSizes _nailSize = NailSizes.mali;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime initDate = DateTime.now().add(const Duration(days: 1));
  String selectedTime = "";
  int duration = 2;
  final dateFormat = new DateFormat('dd.MM.yyyy');
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

      Provider.of<Reservations>(context).fetchAndSetReservation().then((_) {
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
    Provider.of<Reservations>(context, listen: false).fetchAndSetReservation();
    final reservationData = Provider.of<Reservations>(context);

    Future<bool> _checkFinishReservations(Reservation reservation) {
      bool booked = false;

      List<Reservation> bookedDates =
          reservationData.findAllByDate(reservation.date);

      Set<String> bookedTimes =
          reservationData.findAllBookedTimeByDate(bookedDates);

      if (bookedTimes.contains(reservation.time.toString())) {
        booked = true;
      } else if (reservation.duration == 2 && reservation.time == '19') {
        booked = true;
      } else if (reservation.duration == 2 &&
          (bookedTimes.contains(reservation.time.toString()) ||
              bookedTimes.contains(reservation.time.toString()))) {
        booked = true;
      }
      print(booked);
      return Future<bool>.value(booked);
    }

    _showModalAlert(Reservation reservation) {
      return AlertDialog(
        backgroundColor: Colors.grey,
        title: Text('Sažetak odabranog termina rezervacije'),
        content: Container(
          width: double.infinity,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(children: [
                Icon(Icons.event, color: Color(0xff2d2d2d)),
                Text(" Datum: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.date)
              ]),
              Row(children: [
                Icon(Icons.schedule, color: Color(0xff2d2d2d)),
                Text(" Vrijeme: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.time + ":00 h")
              ]),
              Row(children: [
                Icon(Icons.design_services, color: Color(0xff2d2d2d)),
                Text(" Usluga: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.service)
              ]),
              Row(children: [
                Icon(Icons.straighten, color: Color(0xff2d2d2d)),
                Text(" Veličina: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.nailSize)
              ]),
              Row(children: [
                Icon(Icons.timelapse, color: Color(0xff2d2d2d)),
                Text(" Trajanje: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.duration.toString() + " h")
              ])
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 13), primary: Colors.grey[700]),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ODUSTANI'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 13), primary: Color(0xffFFC592)),
            onPressed: () async {
              bool bookedResult = await _checkFinishReservations(reservation);
              if (bookedResult == false) {
                Provider.of<Reservations>(context, listen: false)
                    .addReservation(reservation);

                Navigator.pop(context);

                AlertDialog alert = AlertDialog(
                  backgroundColor: Color(0xff2d2d2d),
                  title: Text("Uspješna rezervacija",
                      style: TextStyle(color: Colors.grey)),
                  content:
                      Icon(Icons.task_alt, color: Color(0xffFFC592), size: 120),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 13),
                          primary: Color(0xffFFC592)),
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  StepperReservationScreen(2)),
                        );
                      },
                      child: Text('U REDU'),
                    ),
                  ],
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              } else {
                Navigator.pop(context);

                AlertDialog alert = AlertDialog(
                  backgroundColor: Colors.grey,
                  title: Text("Neuspješna rezervacija"),
                  content: Text("Nažalost odabrani termin više nije slobodan."),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 13),
                          primary: Color(0xffFFC592)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('U REDU'),
                    ),
                  ],
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }
            },
            child: Text('REZERVIRAJ'),
          )
        ],
      );
    }

    _showModalCupertinoAlert(Reservation reservation) {
      return CupertinoAlertDialog(
        title: Text('Sažetak odabranog termina rezervacije'),
        content: Container(
          width: double.infinity,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(children: [
                Icon(CupertinoIcons.calendar, color: Color(0xff2d2d2d)),
                Text(" Datum: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.date)
              ]),
              Row(children: [
                Icon(CupertinoIcons.clock, color: Color(0xff2d2d2d)),
                Text(" Vrijeme: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.time + ":00 h")
              ]),
              Row(children: [
                Icon(CupertinoIcons.bag, color: Color(0xff2d2d2d)),
                Text(" Usluga: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.service)
              ]),
              Row(children: [
                Icon(CupertinoIcons.textformat_size, color: Color(0xff2d2d2d)),
                Text(" Veličina: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.nailSize)
              ]),
              Row(children: [
                Icon(CupertinoIcons.timer, color: Color(0xff2d2d2d)),
                Text(" Trajanje: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(reservation.duration.toString() + " h")
              ])
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  Text('Odustani', style: TextStyle(color: Color(0xff2d2d2d)))),
          CupertinoDialogAction(
            isDefaultAction: true,
            child:
                Text('Rezerviraj', style: TextStyle(color: Color(0xff2d2d2d))),
            onPressed: () async {
              bool bookedResult = await _checkFinishReservations(reservation);
              if (bookedResult == false) {
                Provider.of<Reservations>(context, listen: false)
                    .addReservation(reservation);
                Navigator.pop(context);

                CupertinoAlertDialog alertCuperino = CupertinoAlertDialog(
                  title: Text("Uspješna rezervacija",
                      style: TextStyle(color: Colors.black)),
                  content:
                      Icon(Icons.task_alt, color: Color(0xffFFC592), size: 120),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                StepperReservationScreen(2)));
                        },
                        child: Text('U redu',
                            style: TextStyle(color: Color(0xff2d2d2d)))),
                  ],
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alertCuperino;
                  },
                );
              } else {
                Navigator.pop(context);

                CupertinoAlertDialog alertErrorCuperino = CupertinoAlertDialog(
                  title: Text("Neuspješna rezervacija"),
                  content: Text("Nažalost odabrani termin više nije slobodan."),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('U redu',
                            style: TextStyle(color: Color(0xff2d2d2d)))),
                  ],
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alertErrorCuperino;
                  },
                );
              }
            },
          ),
        ],
      );
    }

    return Theme(
        data: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Color(0xffA4A4A4),
            ),
            subtitle1: TextStyle(
              color: Color(0xffA4A4A4),
            ),
            caption: TextStyle(
              fontSize: 14,
              color: Color(0xffA4A4A4),
            ),
          ),
          accentColor: Color(0xffFFC592),
          colorScheme: ColorScheme.light(primary: Color(0xffA4A4A4)),
          unselectedWidgetColor: Colors.grey,
          disabledColor: Colors.grey,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffA4A4A4),
              textStyle: TextStyle(color: Colors.black),
            ),
          ),
        ),
        child: _isLoading
            ? Center(
                child: Platform.isIOS
                    ? CupertinoTheme(
                        data: CupertinoTheme.of(context)
                            .copyWith(brightness: Brightness.dark),
                        child: CupertinoActivityIndicator())
                    : CircularProgressIndicator())
            : Stepper(
                currentStep: _index,
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 13),
                              primary: Color(0xffFFC592)),
                          onPressed: _index == 3 && selectedTime == ""
                              ? null
                              : onStepContinue,
                          child: _index == 3
                              ? Text('REZERVIRAJ',
                                  style: TextStyle(color: Color(0xff2d2d2d)))
                              : Text('DALJE',
                                  style: TextStyle(color: Color(0xff2d2d2d))),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 13),
                              primary: Colors.grey[700]),
                          onPressed: onStepCancel,
                          child: Text('NATRAG'),
                        ),
                      ],
                    ),
                  );
                },
                onStepCancel: () {
                  _index > 0 ? setState(() => _index -= 1) : null;
                },
                onStepContinue: () {
                  if (_index == 3 && selectedTime != "") {
                    Reservation reservation = new Reservation(
                        date: "${dateFormat.format(selectedDate)}",
                        duration: duration,
                        id: '',
                        nailSize: _nailSize == NailSizes.extra_veliki
                            ? "extra veliki"
                            : _nailSize.toString().split(".")[1],
                        service: _character == Services.trajni_lak
                            ? "trajni lak"
                            : _character.toString().split(".")[1],
                        status: '',
                        user:
                            Provider.of<Auth>(context, listen: false).userEmail,
                        time: selectedTime);

                    setState(() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Platform.isIOS
                                ? _showModalCupertinoAlert(reservation)
                                : _showModalAlert(reservation);
                          });
                    });
                  }
                  if (_index < 3) {
                    selectedTime = "";
                  }

                  _index < 3 ? setState(() => _index += 1) : null;
                },
                onStepTapped: (int index) {
                  setState(() => _index = index);
                },
                steps: <Step>[
                  Step(
                    title: const Text('USLUGA'),
                    subtitle: Text("Odaberite željenu uslugu"),
                    content: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            RadioListTile<Services>(
                              title: const Text('Gel'),
                              value: Services.gel,
                              groupValue: _character,
                              onChanged: (Services value) {
                                setState(() {
                                  _character = value;
                                  duration = 2;
                                });
                              },
                            ),
                            RadioListTile<Services>(
                              title: const Text('Trajni lak'),
                              value: Services.trajni_lak,
                              groupValue: _character,
                              onChanged: (Services value) {
                                setState(() {
                                  _character = value;
                                  duration = 2;
                                });
                              },
                            ),
                            RadioListTile<Services>(
                              title: const Text('Pedikura'),
                              value: Services.pedikura,
                              groupValue: _character,
                              onChanged: (Services value) {
                                setState(() {
                                  _character = value;
                                  duration = 1;
                                });
                              },
                            ),
                            RadioListTile<Services>(
                              title: const Text('Manikura'),
                              value: Services.manikura,
                              groupValue: _character,
                              onChanged: (Services value) {
                                setState(() {
                                  _character = value;
                                  duration = 1;
                                });
                              },
                            ),
                          ],
                        )),
                    isActive: _index >= 0,
                    state:
                        _index >= 0 ? StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: const Text('VELIČINA'),
                    subtitle: Text("Odaberite veličinu"),
                    content: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            RadioListTile<NailSizes>(
                              title: const Text('Mali nokti (S)'),
                              value: NailSizes.mali,
                              groupValue: _nailSize,
                              onChanged: (NailSizes value) {
                                setState(() {
                                  _nailSize = value;
                                });
                              },
                            ),
                            RadioListTile<NailSizes>(
                              title: const Text('Srednj nokti (M)'),
                              value: NailSizes.srednji,
                              groupValue: _nailSize,
                              onChanged: (NailSizes value) {
                                setState(() {
                                  _nailSize = value;
                                });
                              },
                            ),
                            RadioListTile<NailSizes>(
                              title: const Text('Veliki nokti (L)'),
                              value: NailSizes.veliki,
                              groupValue: _nailSize,
                              onChanged: (NailSizes value) {
                                setState(() {
                                  _nailSize = value;
                                });
                              },
                            ),
                            RadioListTile<NailSizes>(
                              title: const Text('Extra veliki nokti (XL)'),
                              value: NailSizes.extra_veliki,
                              groupValue: _nailSize,
                              onChanged: (NailSizes value) {
                                setState(() {
                                  _nailSize = value;
                                });
                              },
                            ),
                          ],
                        )),
                    isActive: _index >= 0,
                    state:
                        _index >= 1 ? StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: const Text('DATUM'),
                    subtitle: Text("Odaberite željeni datum usluge"),
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          children: [
                            Text("Odabrano: ",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFFC592))),
                            Text(
                              "${dateFormat.format(selectedDate)}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffFFC592)),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 12),
                              primary: Color(0xffFFC592)),
                          onPressed: () => Platform.isIOS
                              ? _showDatePicker(context)
                              : _selectDate(context),
                          child: Text('Odaberite datum',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    isActive: _index >= 0,
                    state:
                        _index >= 2 ? StepState.complete : StepState.disabled,
                  ),
                  Step(
                    title: const Text('VRIJEME'),
                    subtitle: Text("Odaberite željeno vrijeme usluge"),
                    content: SingleChildScrollView(
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          bool booked = false;
                          List<Reservation> bookedDates = reservationData
                              .findAllByDate(dateFormat.format(selectedDate));

                          Set<String> bookedTimes = reservationData
                              .findAllBookedTimeByDate(bookedDates);

                          if (bookedTimes.contains((index + 8).toString())) {
                            booked = true;
                          } else if (duration == 2 && (index + 8) == 19) {
                            booked = true;
                          } else if (duration == 2 &&
                              (bookedTimes.contains((index + 8).toString()) ||
                                  bookedTimes
                                      .contains((index + 9).toString()))) {
                            booked = true;
                          }

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 15),
                                primary: selectedTime == (index + 8).toString()
                                    ? Color(0xffFFC592)
                                    : Colors.grey),
                            onPressed: booked == false
                                ? () {
                                    setState(() {
                                      selectedTime = "${(index + 8)}";
                                    });
                                  }
                                : null,
                            child: Text("${(index + 8)}" + ":00h"),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                      ),
                    ),
                    isActive: _index >= 0,
                    state:
                        _index >= 3 ? StepState.complete : StepState.disabled,
                  ),
                ],
              ));
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 360,
              color: Color(0xffA4A4A4),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: CupertinoDatePicker(
                        initialDateTime: initDate,
                        minimumDate: initDate,
                        maximumDate: DateTime.now().add(Duration(days: 30)),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (val) {
                          setState(() {
                            selectedDate = val;
                          });
                        }),
                  ),
                  CupertinoButton(
                    child: Text('OK', style: TextStyle(color: Colors.black)),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: initDate,
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xffFFC592),
              onPrimary: Colors.black,
              surface: Colors.grey[600],
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Color(0xffA4A4A4),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}
