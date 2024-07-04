import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityManager{
  static Future<bool> isConnected([List<ConnectivityResult>? results]) async{    
    List<ConnectivityResult> connectionResults;
    if(results != null){
      connectionResults = results;
    }else{
connectionResults = await Connectivity().checkConnectivity();
    }    
    return connectionResults.contains(ConnectivityResult.wifi) || connectionResults.contains(ConnectivityResult.mobile) || connectionResults.contains(ConnectivityResult.ethernet);          
  }

  static Stream<List<ConnectivityResult>> isConnectivityChanged(){
    return Connectivity().onConnectivityChanged;
  }  
}