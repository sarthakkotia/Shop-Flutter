class HttpException implements Exception {
  // this is our own exception class here we have used implements keywork stating that
  // we are needed to define all the methods of the exception class
  // upon diving into the class we can see that only one function is defined there it's the toString function
  // and every class we create through dart would by default have an toString function
  // as when we create a class in dart it implicitly extends the class to an Object class which have an ToString function
  final String message;

  HttpException({required this.message});

  @override
  // enev thought the toString fucntion is already implemented we need to use it in a different way
  // as rather than it showing super.toString which would display IInstance of 'HttpException'
  // we want it to display a personalized message
  //hence we override the default function
  String toString() {
    return message;
    // return super.toString();
  }
}
