import 'package:flutter/material.dart';

import '../../widgets/admin/hotels_grid_admin.dart';
import '../../widgets/home_drawer.dart';

class AdminHotelsScreen extends StatelessWidget {
  const AdminHotelsScreen({super.key});
  static const routeName = '/hotels-screen-admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(title: const Text("Edit Hotels Info")),
        body: HotelsGridAdmin());
  }
}
