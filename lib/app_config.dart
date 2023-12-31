
import 'package:intl/intl.dart';

class AppConfig{

  //app name
  static const String AppName = "Skin care traker";
  static const String ADMIN_MIAL = "admin@gmail.com";
  static const String SHOP_URL = "https://agerestore.us/collections/all";
  static const String CONTACT_URL = "https://agerestore.us/pages/contact";



  static String getCurrentDate() {
    // Use the intl package to get the timezone
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM dd').format(now);
    return formattedDate;
  }

  static String dateFormat({required DateTime date}){
    return  DateFormat('yyyy-MM-dd').format(date);
  }


}