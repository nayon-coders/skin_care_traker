
import 'package:intl/intl.dart';

class AppConfig{

  //app name
  static const String AppName = "Skin care traker";
  static const String ADMIN_MIAL = "admin@gmail.com";



  static String getCurrentDate() {
    // Use the intl package to get the timezone
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd').format(now);
    return formattedDate;
  }


}