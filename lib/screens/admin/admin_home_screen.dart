import 'package:book_a_stay/screens/admin/hotels_screen_admin.dart';
import 'package:book_a_stay/widgets/admin/hotels_grid_admin.dart';
import 'package:book_a_stay/widgets/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../providers/hotels.dart';
import './edit_hotels_screen.dart';
import '../../widgets/admin/home_drawer_admin.dart';
import 'orders_screen_admin.dart';

class AdminHomeScreen extends StatefulWidget {
  static const routeName = 'admin-screen';
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(title: const Text("Admin Screen")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/admin_bg.jpg'),
              fit: BoxFit.cover,
              opacity: 0.3),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(270, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: () {},
                  child: const Text(
                    'Admin Options',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  )),
              const SizedBox(height: 25),
              Container(
                constraints: BoxConstraints(
                    maxHeight: 250,
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(children: [
                    const SizedBox(height: 15),
                    ListTile(
                      onTap: () => Navigator.of(context)
                          .pushNamed(EditHotelScreen.routeName),
                      title: const Text('Add New Hotel'),
                      leading: const Card(
                        elevation: 4,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () => Navigator.of(context)
                          .pushNamed(OrdersScreenAdmin.routeName),
                      title: const Text('See Customer Orders'),
                      leading: const Card(
                        elevation: 4,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.book,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () => Navigator.of(context)
                          .pushNamed(AdminHotelsScreen.routeName),
                      title: const Text('Edit Hotel Info'),
                      leading: const Card(
                        elevation: 4,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    // drawer: HomeDrawer(),
    // appBar: AppBar(title: const Text("Admin Screen"), actions: [
    //   ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //           backgroundColor: Colors.black,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15))),
    //       onPressed: () =>
    //           Navigator.of(context).pushNamed(OrdersScreenAdmin.routeName),
    //       child: const Text(
    //         "Orders",
    //         style: TextStyle(color: Colors.white),
    //       )),
    //   IconButton(
    //       onPressed: () =>
    //           Navigator.of(context).pushNamed(EditHotelScreen.routeName),
    //       icon: const Icon(Icons.add)),
    // ]),
    //     body: HotelsGridAdmin());
  }
}
