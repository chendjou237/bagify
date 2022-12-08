//custom exception class
class CustomException implements Exception {
  final String? message;
  CustomException({this.message = "An error occured"});

  @override
  String toString() {
       if (message == 'weak-password') {
        return('The password provided is too weak.');
      } else if (message == 'email-already-in-use') {
        return('The account already exists for that email.');
      }
    return 'Bagify encounter something strange: $message';
    }
  
}