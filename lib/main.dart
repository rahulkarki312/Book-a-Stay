import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';
import 'providers/auth.dart';
import './screens/loading_screen.dart';
import './screens/home_screen.dart';
import './screens/admin/admin_home_screen.dart';
import 'screens/admin/edit_hotels_screen.dart';
import './providers/hotels.dart';
import './providers/userfilter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Hotels>(
              create: (_) => Hotels("", "", []),
              update: (ctx, auth, previousHotels) => Hotels(
                  auth.token.toString(),
                  auth.userId.toString(),
                  previousHotels == null ? [] : previousHotels.hotels)),
          ChangeNotifierProvider(create: (_) => UserFilter()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            //           theme: ThemeData().copyWith(
            //         colorScheme: ThemeData().colorScheme.copyWith(secondary: Colors.black, primary: Colors.white),

            // ),

            title: " ",
            home: auth.isAuth & !auth.isAdmin
                ? HomeScreen()
                : auth.isAuth & auth.isAdmin
                    ? AdminHomeScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? LoadingScreen()
                                : AuthScreen(),
                        // here, if the tryAutoLogin is successful, the auth notifies listeners and
                        //this whole consumer is rebuilt with auth.isAuth set to true and hence, HotelsOverviewScreen is shown
                        // otherwise  in any case, the AuthScreen is shown
                      ),
            routes: {
              EditHotelScreen.routeName: (context) => EditHotelScreen(),
            },
          ),
        ));
  }
}
