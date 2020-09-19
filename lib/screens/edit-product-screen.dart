import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/provider/products.dart';

class UserEditScreen extends StatefulWidget {
  static const routName = "/edit-screen";

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String imageUrl;
  var _editedProduct = Product(
    id: null,
    isFavorite: false,
    title: "",
    description: "",
    price: 0,
    imageUrl: '',
  );
  var isLoading = false;

  void update() {
    setState(() {
      imageUrl = _imageUrlController.text;
    });
  }

  void _saveProduct() {
    setState(() {
      isLoading = true;
    });

    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }

    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context)
          .updateProduct(_editedProduct.id, _editedProduct)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      Provider.of<Products>(context)
          .addProducts(_editedProduct)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error occurred!"),
                  content: Text("Something went wrong."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  var _isInt = true;
  var _intValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": ""
  };

  @override
  void didChangeDependencies() {
    if (_isInt) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct = Provider.of<Products>(context).findById(id);
        _intValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": ""
        };

        _imageUrlController.text = _editedProduct.imageUrl;
        update();
      }
      _isInt = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveProduct();
            },
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Title",
                        focusColor: Colors.purple,
                      ),
                      initialValue: _intValues["title"],
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      validator: (value) {
                        if (value.isEmpty)
                          return "This field is require!"; // string means error
                        else
                          return null; // null means all wright.
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Price",
                        focusColor: Colors.purple,
                      ),
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            price: int.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      initialValue: _intValues["price"],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocus,
                      validator: (value) {
                        if (value.isEmpty) return "Please enter price!";
                        if (int.tryParse(value) == null)
                          return "Please enter a valid number!";
                        if (int.parse(value) <= 0)
                          return "Enter a number greater than 0!";

                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Description",
                        focusColor: Colors.purple,
                      ),
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_urlFocus);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: value,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      initialValue: _intValues["description"],
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocus,
                      validator: (value) {
                        if (value.isEmpty) return "Please enter description!";
                        if (value.length < 10)
                          return "Please enter description containing at least 10 characters!";
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          )),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            //TextFormFiled take full width but it in a row having container
                            decoration: InputDecoration(
                              labelText: "Image Url",
                              focusColor: Colors.purple,
                            ),
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  imageUrl: value);
                            },

                            controller: _imageUrlController,
                            onFieldSubmitted: (val) => update(),
                            keyboardType: TextInputType.url,
                            focusNode: _urlFocus,
                            validator: (value) {
                              if (value.isEmpty) return "Please enter Url!";
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
