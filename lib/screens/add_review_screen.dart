import 'package:book_a_stay/providers/hotel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../providers/hotels.dart';
import '../widgets/review_item.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});
  static const routeName = '/add-reviews-screen';
  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  String? hotelId;
  Hotel? hotel;
  List<Hotel>? hotels;

  @override
  void didChangeDependencies() {
    hotelId = ModalRoute.of(context)!.settings.arguments.toString();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (hotelId != 'null') {
      hotel = Provider.of<Hotels>(context, listen: false).findById(hotelId);
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Write A Review"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Leave a review and rating for',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
                child: Container(
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 101, 100, 100),
                      offset: Offset(1, 2),
                      blurRadius: 3,
                    )
                  ],
                  color: Colors.amber,
                  border: Border.all(color: Colors.amber, width: 8),
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                hotel!.title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )),
            const SizedBox(height: 30),
            _ReviewCard(hotelId: hotelId!),
            const SizedBox(height: 30),
            const Text("What others wrote"),
            const SizedBox(height: 20),
            Container(
              height: 90,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Scrollbar(
                isAlwaysShown: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((ctx, i) {
                    return ChangeNotifierProvider.value(
                      value: hotel!.reviews[i],
                      child: ReviewItem(
                        hotelId: hotelId!,
                        showOnly: true,
                      ),
                    );
                  }),
                  itemCount: hotel!.reviews.length,
                ),
              ),
            )
          ],
        ));
  }
}

class _ReviewCard extends StatefulWidget {
  _ReviewCard({
    super.key,
    required this.hotelId,
  });

  String hotelId;

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _reviewFormIsLoading = false;
  final _reviewNode = FocusNode();
  final _ratingNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _ratingController = 1;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _reviewFormIsLoading = true;
    });
    Provider.of<Hotels>(context, listen: false)
        .addReview(_reviewController.text, _ratingController, widget.hotelId)
        .then((value) {
      setState(() {
        _reviewFormIsLoading = false;
      });
      _reviewController.clear();
      _ratingController = 1;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    controller: _reviewController,
                    focusNode: _reviewNode,
                    decoration: const InputDecoration(labelText: 'Review'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_ratingNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a Review';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('How would you rate your experience?'),
                  const SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.circle,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _ratingController = rating;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _reviewFormIsLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _saveForm,
                          child: const Text("submit"),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                        )
                ],
              )),
        ]),
      ),
    );
  }
}
