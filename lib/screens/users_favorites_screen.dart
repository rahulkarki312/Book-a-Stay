import 'package:flutter/material.dart';
import '../widgets/hotels_grid.dart';

class UsersFavoritesScreen extends StatelessWidget {
  static const RouteName = "/users_favorite_screen";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Your Favorites")),
      body: HotelsGrid(
        isFavorite: true,
      ),
    );
  }
}
