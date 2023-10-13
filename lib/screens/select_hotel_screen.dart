import 'package:flutter/material.dart';
import 'add_review_screen.dart';
import 'package:provider/provider.dart';
import '../providers/hotels.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SelectHotelScreen extends StatefulWidget {
  static const routename = "/select-hotel";
  const SelectHotelScreen({super.key});

  @override
  State<SelectHotelScreen> createState() => _SelectHotelScreenState();
}

class _SelectHotelScreenState extends State<SelectHotelScreen> {
  @override
  Widget build(BuildContext context) {
    final hotels = Provider.of<Hotels>(context, listen: false).hotels;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Hotel to review"),
      ),
      body: ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (ctx, idx) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                AddReviewScreen.routeName,
                arguments: hotels[idx].id),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              constraints: const BoxConstraints(minHeight: 160),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              hotels[idx].title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            RatingBarIndicator(
                              rating: hotels[idx].avgRating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.circle,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 10.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(height: 10),
                            if (hotels[idx].avgRating > 4.0)
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: const Text(
                                  "TOP RATED",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: 180,
                          child: Image.network(
                            fit: BoxFit.cover,
                            hotels[idx].imageUrl,
                          )),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
