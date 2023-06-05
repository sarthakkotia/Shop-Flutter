// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../Provider/product.dart';
import 'package:provider/provider.dart';
import '../Provider/products_provider.dart';

class AddProduct extends StatefulWidget {
  static const routename = "/add-product";
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // this variable is used to pass the user to next textfield when the user presses next button on keyboard
  final _pricefocusnode = FocusNode();
  final _descfocusnode = FocusNode();
  final _imageurlcontroller = TextEditingController();
  // we decalre the focus node for image so that we can later show the image if the ocus changes to some other textfield so it is not necessary to always press the checkmark button for updating the preview of the image
  final _imagefocusnode = FocusNode();
  // now to submit the data we have entered in the form we have to link the form widget to a global key which would save it's state and in that case we use tht Globabl key widget
  final _form = GlobalKey<FormState>();
  Product _editedproduct =
      Product(id: "null", description: "", imageUrl: "", price: 0, title: "");

  @override
  void initState() {
    // we ahve declared a listener here this listener will listen to the image focusnode and then run this function updateimageurl
    _imagefocusnode.addListener(updateimageurl);
    super.initState();
  }

  bool init = true;
  bool isloading = false;

// here we use didchangedependencides because we can't access our arguments through initstate as didchangedependencies runs immediately after init state ie before build
  @override
  void didChangeDependencies() {
    // as build runs multiple times here so didchangedependencies would also run multiple times qwhich is inefficeint for the system hence we have globally declared a variable which would detect if build has rerun or build is running for the first time ie the init variable
    if (init) {
      //facing a problem here when i click on plus button the productid is not really being considered

      //I FOUND SOLUTION
      // basically the if is comparing the null which is a string because we converted into to string trough modal route
      // so if is comparing that null which is essentially a "null" ie a string null to the dart default null which is not equal
      //Solution don't convert to string
      // hence it's causing error now it would be sorted
      final productid = ModalRoute.of(context)?.settings.arguments;
      if (productid != null) {
        _editedproduct = Provider.of<Products>(context, listen: false)
            .searchproductbyid(productid as String);
      }
      _imageurlcontroller.text = _editedproduct.imageUrl;
    }
    init = false;
    super.didChangeDependencies();
  }

//Not ewhen you are using your own focus node it is highly recommended to dispose them off because even when the screen changes there focus nodes will be always in the memory until you dispose them yorself
  @override
  void dispose() {
    _imagefocusnode.removeListener(updateimageurl);
    _pricefocusnode.dispose();
    _descfocusnode.dispose();
    _imageurlcontroller.dispose();
    _imagefocusnode.dispose();

    super.dispose();
  }

  void updateimageurl() {
    // from the listener this function is run and then we are focused only on it's focus argument if it doesn't have focus ie either the focus is removed then update rbuild the app to show preview
    if (_imagefocusnode.hasFocus == false) {
      setState(() {});
    }
  }

  Future<void> saveform() async {
    final isvalid = _form.currentState!.validate();
    if (isvalid == false) {
      return;
    }

    _form.currentState?.save();
    setState(() {
      isloading = true;
    });

    if (_editedproduct.id == "null") {
      await Provider.of<Products>(context, listen: false)
          .addProduct(_editedproduct)
          .catchError((error) {
        //after throwing error we can now use it here in our widget tree
        // we are returnign the showDialog so that the later then function would only work when the navigaotor.pop would return ie user first press the okay button
        //if we had not pressed okay then flutter woudld not wait for the user's response it will execute this code and then execute the then code
        return showDialog<Null>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("An Error Occured"),
              content: Text("Please Try Again"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay"))
              ],
            );
          },
        );
      }).then((_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${_editedproduct.title} is added to the roster!"),
          behavior: SnackBarBehavior.floating,
        ));
      });
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateproduct(_editedproduct);
    }
    setState(() {
      isloading = false;
    });
    Navigator.of(context).pop();
    // print(_editedproduct.id);
    // here we have put listen to false because we are not looking for changes in our products rather we just have to dispatch a funciton to the product
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Product"),
          actions: [IconButton(onPressed: saveform, icon: Icon(Icons.save))],
        ),
        body: isloading == true
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // we can also use validation ie validate as we write evry keystroke using the validator in the form
                    key: _form,
                    // as a child we could also use Listview but in listview when the the content is out of screen it basically rebuilds the listtile hence it's recommended to use the singlechild scroolview with it's child as column to keep entered content saved
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            // to get the input we don't have to define ourselves the controller the form widget will helpus in  that way
                            decoration: InputDecoration(labelText: "Title"),
                            // the text input action configers the way our keyboard enter button will be shown right now it's cconfigured to be a next button ie go to the next field
                            textInputAction: TextInputAction.next,
                            //Now if we want that when we press that next button on the phone keyboard it should go to the next field we use the focus node argument
                            onFieldSubmitted: (_) {
                              // to change our text field selection we use the focus node and to change that weuse focusscope method with the of argument ie it needs a connection with the page to work
                              FocusScope.of(context)
                                  .requestFocus(_pricefocusnode);
                            },
                            onSaved: (newValue) {
                              _editedproduct = Product(
                                  id: _editedproduct.id,
                                  title: newValue.toString(),
                                  description: _editedproduct.description,
                                  price: _editedproduct.price,
                                  imageUrl: _editedproduct.imageUrl,
                                  isFavorite: _editedproduct.isFavorite);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The title shall not be empty";
                              }
                              return null;
                            },
                            initialValue: _editedproduct.title,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Price"),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _pricefocusnode,
                            onFieldSubmitted: (_) {
                              // to change our text field selection we use the focus node and to change that weuse focusscope method with the of argument ie it needs a connection with the page to work
                              FocusScope.of(context)
                                  .requestFocus(_descfocusnode);
                            },
                            onSaved: (newValue) {
                              _editedproduct = Product(
                                  id: _editedproduct.id,
                                  title: _editedproduct.title,
                                  description: _editedproduct.description,
                                  price: double.parse(newValue.toString()),
                                  imageUrl: _editedproduct.imageUrl,
                                  isFavorite: _editedproduct.isFavorite);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "price shall not be empty";
                              }
                              if (double.tryParse(value.toString()) == null) {
                                return "Enter a valid price";
                              }
                              if (double.parse(value) <= 0) {
                                return "Enter a price greater than 0";
                              }
                              return null;
                            },
                            initialValue: _editedproduct.price.toString(),
                          ),
                          TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Desciption"),
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              focusNode: _descfocusnode,
                              onSaved: (newValue) {
                                _editedproduct = Product(
                                    id: _editedproduct.id,
                                    title: _editedproduct.title,
                                    description: newValue.toString(),
                                    price: _editedproduct.price,
                                    imageUrl: _editedproduct.imageUrl,
                                    isFavorite: _editedproduct.isFavorite);
                              },
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return null;
                                }
                                if (value.length < 10) {
                                  return "The description should be atleast 10 characters long or empty";
                                }
                                return null;
                              },
                              initialValue: _editedproduct.description),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 8, right: 8),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: _imageurlcontroller.text.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Center(
                                          child: Text(
                                            "Enter image Url",
                                          ),
                                        ),
                                      )
                                    : FittedBox(
                                        child: Image.network(
                                        _imageurlcontroller.text,
                                      )),
                              ),
                              // so the text form field takes the available space just as like a row so when you put both of them together like this ie rown has a child as textformfield flutter does not knowwhat width is to be given to the textformfield
                              Expanded(
                                  child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Image URL"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                // now if we want to instantly preview the image we entered we have to declare a controller and then pass that controller text to the contaier which would then preview that image we entered
                                controller: _imageurlcontroller,
                                // we declare the onediting complete so that as soon as we click the enter button or the checkmark button on the keyboard then rebuild the widget using setstate as now imageurl will be updated and container will now show the image
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                focusNode: _imagefocusnode,
                                onFieldSubmitted: (_) {
                                  saveform();
                                },
                                onSaved: (newValue) {
                                  _editedproduct = Product(
                                      id: _editedproduct.id,
                                      title: _editedproduct.title,
                                      description: _editedproduct.description,
                                      price: _editedproduct.price,
                                      imageUrl: newValue.toString(),
                                      isFavorite: _editedproduct.isFavorite);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Image URL shall not be empty";
                                  }
                                  if (((value.startsWith("http:/") == false) &&
                                          (value.startsWith("https:/") ==
                                              false)) ||
                                      ((value.endsWith(".jpg") == false) &&
                                          (value.endsWith(".jpeg") == false) &&
                                          (value.endsWith(".png") == false))) {
                                    return "Enter a valid Image URL";
                                  }
                                  return null;
                                },
                              ))
                            ],
                          )
                        ],
                      ),
                    )),
              ));
  }
}
