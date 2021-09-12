import 'package:flutter/material.dart';
import 'package:la_queen/helpers/custom_route.dart';
import 'package:la_queen/providers/auth.dart';
import 'package:la_queen/providers/request_reservations.dart';
import 'package:la_queen/providers/reservations.dart';
import 'package:la_queen/providers/reviews.dart';
import 'package:la_queen/providers/user_reservations.dart';
import 'package:la_queen/screens/auth_screen.dart';
import 'package:la_queen/screens/home_screen.dart';
import 'package:la_queen/screens/reservation_requests_screen.dart';
import 'package:la_queen/screens/reviews_screen.dart';
import 'package:la_queen/screens/stepper_reservation_screen.dart';
import 'package:la_queen/screens/user_calendar_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Reservations>(
            create: (ctx) => Reservations('', [], '', ''),
            update: (c, auth, prev) =>
                Reservations(auth.token, prev == null ? [] : prev.reservations, auth.user, auth.userEmail),
          ),
          ChangeNotifierProxyProvider<Auth, RequestReservations>(
            create: (ctx) => RequestReservations('', [], '', ''),
            update: (c, auth, prev) =>
                RequestReservations(auth.token, prev == null ? [] : prev.requestReservations, auth.user, auth.userEmail),
          ),
          ChangeNotifierProxyProvider<Auth, UserReservations>(
            create: (ctx) => UserReservations('', [], '', ''),
            update: (c, auth, prev) =>
                UserReservations(auth.token, prev == null ? [] : prev.userReservations, auth.user, auth.userEmail),
          ),
          ChangeNotifierProxyProvider<Auth, Reviews>(
            create: (ctx) => Reviews('', [], '', ''),
            update: (c, auth, prev) =>
                Reviews(auth.token, prev == null ? [] : prev.reviews, auth.user, auth.userEmail),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'La Queen',
              theme: ThemeData(
                  primarySwatch: Colors.grey,
                  accentColor: Color(0xffA4A4A4),
                  errorColor: Colors.redAccent,
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder()
                  })),
              home: auth.isAuth ? HomeScreen(0) : AuthScreen(),
              routes: {
                HomeScreen.routeName: (ctx) => HomeScreen(0),
                StepperReservationScreen.routeName: (ctx) =>
                    StepperReservationScreen(2),
                UserCalendarScreen.routeName: (ctx) => UserCalendarScreen(3),
                ReservationRequestaScreen.routeName: (ctx) =>
                    ReservationRequestaScreen(2),
                ReviewsScreen.routeName: (ctx) => ReviewsScreen(1),
              }),
        ));
  }
}
