import 'package:flutter/material.dart';
import '../widgets/hotels_grid.dart';

class UsersFavoritesScreen extends StatelessWidget {
  static const RouteName = "/users_favorite_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Favorites")),
      body: HotelsGrid(
        isFavorite: true,
      ),
    );
  }
}
