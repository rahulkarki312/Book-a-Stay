import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hotel.dart';
import '../../providers/hotels.dart';
import '../../providers/auth.dart';

// class EditHotelScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Hotels Screen"),
//       ),
//       body: Center(
//           child: TextButton(
//         child: Text("Log out"),
//         onPressed: () {
//           Provider.of<Auth>(context, listen: false).logout();
//         },
//       )),
//     );
//   }
// }

class EditHotelScreen extends StatefulWidget {
  static const routeName = '/edit-hotel';
  @override
  State<EditHotelScreen> createState() => _EditHotelScreenState();
}

class _EditHotelScreenState extends State<EditHotelScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _discountFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;

  // if this screen is redirected from the "ADD" IconButton
  var _editedHotel = Hotel(
      id: '',
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
      isFavorite: false,
      discount: 0,
      address: '',
      breakfastIncl: false);

  Map<String, dynamic> _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'discount': '',
    'address': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) {
        return;
      }
      setState(() {});
    }
  }

// if this screen is redirected from the "Edit" IconButton of a UsersHotelItem
  @override
  // void didChangeDependencies() {
  //   // first set the isInit var to true (When the widget is first built), then fetch the
  //   // selected HotelItem from the "Hotels" provider. Then set the _isInit to false
  //   // since the HotelItem has already been fetched the first time this widget got built
  //   if (_isInit) {
  //     final Hotelid = ModalRoute.of(context)!.settings.arguments;
  //     if (Hotelid != null) {
  //       _editedHotel = Provider.of<Hotels>(context, listen: false)
  //           .findById(Hotelid as String);
  //       _initValues = {
  //         'title': _editedHotel.title,
  //         'description': _editedHotel.description,
  //         'price': _editedHotel.price.toString(),
  //         'imageUrl': '',
  //         'isMan': _editedHotel.isMan,
  //         'discount': _editedHotel.discount.toString(),
  //         'category': _editedHotel.category
  //       };
  //       _imageUrlController.text = _editedHotel.imageUrl;
  //     }
  //   }

  //   _selectedGender = _initValues['isMan'] == true ? Gender.Men : Gender.Women;

  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  Future<void> _saveForm() async {
    // dummy image url link
    // https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedHotel.id == '') {
      // adds Hotel item
      try {
        // _editedHotel.isMan = genderObject.sele
        await Provider.of<Hotels>(context, listen: false)
            .addHotel(_editedHotel);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error occured !"),
                  content: Text("Something went wrong!"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Okay"))
                  ],
                ));
      }
    } else {
      // edits Hotel item
      await Provider.of<Hotels>(context, listen: false)
          .updateHotel(_editedHotel.id, _editedHotel);
    }
    setState(() {
      _isLoading:
      false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Edit Hotel",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        onSaved: (value) {
                          _editedHotel = Hotel(
                              title: value!,
                              id: _editedHotel.id,
                              price: _editedHotel.price,
                              description: _editedHotel.description,
                              imageUrl: _editedHotel.imageUrl,
                              isFavorite: _editedHotel.isFavorite,
                              discount: _editedHotel.discount,
                              address: _editedHotel.address,
                              breakfastIncl: _editedHotel.breakfastIncl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the value';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        onSaved: (value) {
                          _editedHotel = Hotel(
                              title: _editedHotel.title,
                              id: _editedHotel.id,
                              price: double.parse(value!),
                              description: _editedHotel.description,
                              imageUrl: _editedHotel.imageUrl,
                              isFavorite: _editedHotel.isFavorite,
                              discount: _editedHotel.discount,
                              address: _editedHotel.address,
                              breakfastIncl: _editedHotel.breakfastIncl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a price";
                          }
                          if (double.tryParse(value) == '') {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Price must be greater than zero";
                          }
                        },
                        focusNode: _priceFocusNode,
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        onSaved: (value) {
                          _editedHotel = Hotel(
                              title: _editedHotel.title,
                              id: _editedHotel.id,
                              price: _editedHotel.price,
                              description: value!,
                              imageUrl: _editedHotel.imageUrl,
                              isFavorite: _editedHotel.isFavorite,
                              discount: _editedHotel.discount,
                              address: _editedHotel.address,
                              breakfastIncl: _editedHotel.breakfastIncl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a description";
                          }
                          if (value.length < 10) {
                            return "The description is too short (<10)";
                          }
                          // returning null means no error in validation and the opposite when string is returned
                          return null;
                        },
                        focusNode: _descriptionFocusNode,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_discountFocusNode);
                        },
                      ),
                      //discount
                      TextFormField(
                        initialValue: _initValues['discount'],
                        onSaved: (value) {
                          _editedHotel = Hotel(
                              title: _editedHotel.title,
                              id: _editedHotel.id,
                              price: _editedHotel.price,
                              description: _editedHotel.description,
                              imageUrl: _editedHotel.imageUrl,
                              isFavorite: _editedHotel.isFavorite,
                              discount: double.parse(value!),
                              address: _editedHotel.address,
                              breakfastIncl: _editedHotel.breakfastIncl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter the discount, if there is none, enter 0";
                          }
                          // returning null means no error in validation and the opposite when string is returned
                          return null;
                        },
                        focusNode: _discountFocusNode,
                        decoration: InputDecoration(labelText: 'Discount %'),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_categoryFocusNode);
                        },
                        textInputAction: TextInputAction.next,
                      ),

                      //image url

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Text("Enter an Image URL")
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                              child: TextFormField(
                            onSaved: (value) {
                              _editedHotel = Hotel(
                                  title: _editedHotel.title,
                                  id: _editedHotel.id,
                                  price: _editedHotel.price,
                                  description: _editedHotel.description,
                                  imageUrl: value!,
                                  isFavorite: _editedHotel.isFavorite,
                                  discount: _editedHotel.discount,
                                  address: _editedHotel.address,
                                  breakfastIncl: _editedHotel.breakfastIncl);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a URL";
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return "Please enter a valid URL";
                              }

                              return null;
                            },
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _saveForm,
                            // onEditingComplete: () {
                            //   setState(() {});
                            // },
                          )),
                        ],
                      ),
                    ],
                  ))),
    );
  }
}
