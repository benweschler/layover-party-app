abstract class Constants {
  static const String version = '1.0.0';
}

abstract class Endpoints {
  static String get authority => 'layover.party';

  static String get _root => '/api';

  static String get logIn => '$_root/login';

  static String get signUp => '$_root/register';

  static String get flights => '$_root/flights';
}
