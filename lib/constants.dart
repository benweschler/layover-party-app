import 'package:rnd/rnd.dart';

abstract class Constants {
  static const String version = '1.0.0';

  static final int _epithetIndex = rnd.nextInt(_appEpithetList.length);
  static const _appEpithetList = [
    'Made with 🦈 and 🎉 in LA',
    'Made with 36 Cheerios in LA',
    'Made with ✨and 💩 in LA',
    'Made with crusty roof pizza in LA',
    'Made with terrible wifi in LA',
  ];

  static get appEpithet => _appEpithetList[_epithetIndex];
}

abstract class Endpoints {
  static String get authority => 'layover.party';

  static String get _root => '/api';

  static String get logIn => '$_root/login';

  static String get signUp => '$_root/register';

  static String get flights => '$_root/flights';
}
