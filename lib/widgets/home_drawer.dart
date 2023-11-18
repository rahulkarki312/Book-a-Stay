import 'package:book_a_stay/screens/admin/admin_home_screen.dart';
import 'package:book_a_stay/screens/admin/admin_login_screen.dart';
import 'package:book_a_stay/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hotels.dart';
import '../screens/orders_screen.dart';
import '../screens/users_favorites_screen.dart';
import '../providers/auth.dart';
import '../screens/add_review_screen.dart';
import '../screens/select_hotel_screen.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 20),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.black),
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: const Center(
              child: Text(
                'Book a stay',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Card(
            elevation: 4,
            shape: CircleBorder(),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.home,
                color: Colors.black,
              ),
            ),
          ),
          title: TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(HomeScreen.routename),
              child: const Text(
                "Home",
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
        ),
        const Divider(),
        ListTile(
          leading: const Card(
            elevation: 4,
            shape: CircleBorder(),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.book,
                color: Colors.black,
              ),
            ),
          ),
          title: TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(OrdersScreen.routeName),
              child: const Text(
                "Orders",
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
        ),
        const Divider(),
        ListTile(
          leading: const Card(
            shape: CircleBorder(),
            elevation: 4,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.favorite,
                color: Colors.black,
              ),
            ),
          ),
          title: TextButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(UsersFavoritesScreen.RouteName),
              child: const Text(
                "Your Favorites",
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
        ),
        const Divider(),
        ListTile(
          leading: const Card(
            shape: CircleBorder(),
            elevation: 4,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.list,
                color: Colors.black,
              ),
            ),
          ),
          title: TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(SelectHotelScreen.routename),
              child: const Text(
                "Write Review",
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
        ),
        const Divider(),
        ListTile(
          leading: const Card(
            elevation: 4,
            shape: CircleBorder(),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.admin_panel_settings,
                color: Colors.black,
              ),
            ),
          ),
          title: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AdminLoginScreen.routeName);
              },
              child: const Text(
                "Admin Section",
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
        ),
        const Divider(),
        ListTile(
          leading: const Card(
            elevation: 4,
            shape: CircleBorder(),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          title: TextButton(
              onPressed: () {
                Provider.of<Auth>(context, listen: false).logout();
              },
              child: const Text(
                "Log Out",
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
        ),
        const Divider(),
      ]),
    );
  }
}
