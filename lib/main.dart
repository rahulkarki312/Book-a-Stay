import 'package:book_a_stay/screens/admin/admin_login_screen.dart';
import 'package:book_a_stay/screens/admin/hotels_screen_admin.dart';
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
import './screens/booking_page.dart';
import './providers/orders.dart';
import 'screens/orders_screen.dart';
import 'screens/admin/orders_screen_admin.dart';
import './providers/userReview.dart';
import 'screens/users_favorites_screen.dart';
import 'screens/add_review_screen.dart';
import 'screens/select_hotel_screen.dart';

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
              create: (_) => Hotels("", "", "", []),
              update: (ctx, auth, previousHotels) => Hotels(
                  auth.token.toString(),
                  auth.userId.toString(),
                  auth.username.toString(),
                  previousHotels == null ? [] : previousHotels.hotels)),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders("", "", [], false),
            update: (ctx, auth, previousOrders) => Orders(
                auth.token.toString(),
                auth.userId.toString(),
                previousOrders == null ? [] : previousOrders.orders,
                auth.isAdmin),
          ),
          ChangeNotifierProvider(create: (_) => UserFilter()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.white,
                fontFamily: "Montserrat",
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(secondary: Colors.black, primary: Colors.amber)),
            title: " ",
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? LoadingScreen()
                            : AuthScreen(),
                    // here, if the tryAutoLogin is successful, the auth notifies listeners and
                    //this whole consumer is rebuilt with auth.isAuth set to true and hence, HomeScreen is shown
                    // otherwise  in any case, the AuthScreen is shown
                  ),
            routes: {
              HomeScreen.routename: (context) => const HomeScreen(),
              EditHotelScreen.routeName: (context) => EditHotelScreen(),
              BookingPage.routename: (context) => BookingPage(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              OrdersScreenAdmin.routeName: (context) => OrdersScreenAdmin(),
              UsersFavoritesScreen.RouteName: (context) =>
                  UsersFavoritesScreen(),
              AddReviewScreen.routeName: (context) => const AddReviewScreen(),
              SelectHotelScreen.routename: (context) =>
                  const SelectHotelScreen(),
              AdminHomeScreen.routeName: (context) => AdminHomeScreen(),
              AdminLoginScreen.routeName: (context) => const AdminLoginScreen(),
              AdminHotelsScreen.routeName: (context) =>
                  const AdminHotelsScreen()
            },
          ),
        ));
  }
}
