import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefService {

  Future<void> createCache(String key,String userValue)async{
     SharedPreferences _sharedPrefences = await SharedPreferences.getInstance();
     _sharedPrefences.setString("user", userValue);
   }

   Future<String?> readCache(String key)async{
    SharedPreferences _sharedPrefences = await SharedPreferences.getInstance();
    final cache =_sharedPrefences.getString(key);
    if(cache != null){
    return cache;
    }
    else{ return null;}
   }

   Future removeCache(String key)async{
    SharedPreferences _sharedPrefences = await SharedPreferences.getInstance();
    _sharedPrefences.remove(key);

  }




}