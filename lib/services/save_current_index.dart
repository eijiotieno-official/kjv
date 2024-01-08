import 'package:shared_preferences/shared_preferences.dart';

// Class responsible for saving the current index to SharedPreferences

class SaveCurrentIndex {
  // Static method to execute the saving process
  static Future<void> execute({required int index}) async {
    // Obtain an instance of SharedPreferences
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    // Save the curent index to SharedPreference
    sharedPreferences.setInt('index', index);
  }
}
