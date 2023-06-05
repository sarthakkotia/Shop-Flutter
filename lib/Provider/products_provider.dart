import 'package:flutter/material.dart';
import 'product.dart';
// importing the http package to contact the web server and than using it's class as http as now the http keyword is designated to this package
import 'package:http/http.dart' as http;
//upon adding the product model we can say that these product can now notif listeners when they are changed
import 'dart:convert';
// introducing the convert file to convert objects to JSON format
import '../Models/http_exception.dart';
// Fist of all we declare a provider data by by using a class here we have named the class as products in which there is the items of products list now this class is mix in with changenotifier to use the listener set up in different widgets

class Products with ChangeNotifier {
  List<Product> _items = [];
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

// this fucntion is the getter for items and ratehr then getting the items and directly allowing them to chgane it actually takes the copy of the items and spread it to the list
// hence we have used the spread operator

// now we need to store this auth token so that we can pass it when fetching the details hence now we need to store it locally
// for this we would be using changenotifierproxyprovider in the main file so that we can incur the dependecy of the auth provider to our prodcuts provider
// so now this products will rebuild everytime the suth value changes and that's fair as if the auth value chages surely the token value changes as well
// now but in this case the items which would be stored after fetching products would be stored in this local array _items we need to save it hence unse the prviousprovider object provided by the changeNotifierproxyprovider class
  final String? authtoken;
  final String userId;
  Products(this.userId, this.authtoken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((element) => element.isFavorite).toList();
  }

//Fetch data from firebase fucntion like add product
  Future<void> fetchdata() async {
    try {
      // final url = Uri.https(
      //     "flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app",
      //     "/products.json?auth=$authtoken");
      var url = Uri.parse(
          "https://flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authtoken");
      // now we use a get request
      // and as want to wait for that response we use await
      final response = await http.get(url);
      // print(json.decode(response.body));
      var test = json.decode(response.body) as Map<String, dynamic>;
      //print(test);
      // var l = print(l);
      List<Product> _data = [];
      // ignore: unnecessary_null_comparison
      if (test == null) {
        return;
      }
      url = Uri.parse(
          "https://flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authtoken");
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      test.forEach((key, value) {
        _data.insert(
            0,
            Product(
                id: key,
                title: value['title'],
                description: value['description'],
                price: value['price'],
                imageUrl: value['imageURL'],
                // in below we use double question mark this says that if the favoriteDat[key] is null then the value would be falseie after the double questionmark
                isFavorite:
                    favoriteData == null ? false : favoriteData[key] ?? false));
        //print(_data);
      });
      _items = _data;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

// this fucntion is the addproduct function so whent he user would add the prodyct this function would be used and when the product is added we then execute the
// Notify listeners fucntion built into flutter so that it could notify all the widgets to rebuild themselves
//Note all those widgets would be rebuild who are listeing to this class

//Note- we changed the return type to a future so thatwe can tell the widget that hey the work is done stop showing the loading screen
  Future<void> addProduct(Product product) async {
    // now we need to integrae this to a web server
    // this is a relatively new method to save the url
    // here first we wrote the reference URL of the web server and then we wrote in another string the database name we wanted to have in json format
    // we always uyse json fomat because the machine has the fastest response time in reading json code and sending back/ performing the mentioned work
    final url = Uri.parse(
        "https://flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authtoken");
    //this http request is a POST request ie we need to append/store some data in thedatabase
    //for that we need to contact the webserver and then in the body argument introduce the data we want
    //as JSON stores data as a key value pair hence we need to encode data as a map in dart whicxh also stores data in key value pair
    // the post method return a future now a future has a speacial method called the then method
    // this then method is used when we need to do something after the future has got a response
    // so while the flutter code is executing simultaneously with the postr request as soon as the post request is done the code in then method would execute
    // this kind of code is called asynchorous or asyn code

//here we are returning the http.post rather than returning in a then fucntion because in then fucntion returing means we are just returning in then block which constitutes an anonymous function hence it cannot contact the main function ie add product here
// so we returning the whole block as we don't really need the response therefore we set future returntype as void
    try {
      final response = await http
          .post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageURL': product.imageUrl,
            'price': product.price,
          },
        ),
      )
          .then((value) {
        // when we get the response is always the generated id by the server not the whole data of that product we inserted
        ////the value we get will be in json format hence we need to decode it first
        //print(json.decode(value.body)['name']);
      }).catchError((error) {
        // we are using the catcherror methoid to catch the error in this block then print that in the debug window for us
        // and then pass he error using throw so that we can use in our widget tree
        // the throw keyword would work as a pass by value
        // ie it would instantitate another variabkle and copy the contents of error here and pass that new variable
        print(error);
        throw error;
      });
      final newProduct = Product(
          //now we are using id from the sever generated id
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.insert(0, newProduct);
      //print(_items[0].title);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteproduct(String id) async {
    // Here we are implementing a common practive ie optimistic updating
    // it states that if the product can't be deleted then we are needed to readd the deleted product in our local data
    final existingprodindex = _items.indexWhere((element) => element.id == id);
    Product? existingprod = _items[existingprodindex];
    _items.removeAt(existingprodindex);
    // _items.removeWhere((element) => element.id == id);
    final url = Uri.parse(
        "https://flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authtoken");
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // if error then reisrt the prod
      // and throw the exception we built
      _items.insert(existingprodindex, existingprod);
      // we have implemetned our own Excepton class named httpException
      throw HttpException(message: "The Product could not be deleted");
    }
    existingprod = null;
    notifyListeners();
  }

  Product searchproductbyid(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
    );
  }

  Future<void> updateproduct(Product product) async {
    int idx = _items.indexWhere((element) => product.id == element.id);
    //As we are updating the product that means we are not really inserting a new product rather just updating the existing one hence we would send a patch request to firebase
    final url = Uri.parse(
        "https://flutter-959c6-default-rtdb.asia-southeast1.firebasedatabase.app/products/${product.id}.json?auth=$authtoken");
    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageURL': product.imageUrl,
            'price': product.price
          },
        ),
      );
      _items[idx] = Product(
          id: product.id,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
