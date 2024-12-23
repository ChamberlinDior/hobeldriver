

class RideTypeStatus{

  static const int private = 0;
  static const int shared = 1;
  static const int hourly = 2;

  static String getName(int status){
    switch(status){
      case RideTypeStatus.private: return 'Private';
      case RideTypeStatus.shared: return 'Shared';
      case RideTypeStatus.hourly: return 'Hourly';
      default: return 'Private';
    }
  }
}