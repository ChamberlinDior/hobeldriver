class UserType{
  static const int user = 1;
  static const int driver = 2;
  // static const int company = 3;


  static String getName(int status, {int? secsLeft}){
    switch(status){
      case UserType.user:return 'User';
      case UserType.driver: return 'Driver';
      // case UserType.company: return 'Company';

      default: return 'Other';
    }
  }
}
