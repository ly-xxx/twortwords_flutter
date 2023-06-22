import 'package:shared_preferences/shared_preferences.dart';

class CommonPreferences {
  CommonPreferences._();

  static late SharedPreferences sharedPref;

  /// 初始化sharedPrefs，在运行app前被调用
  static Future<void> init() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  static final points = PrefsBean<int>('points');
  static final lastDaySigned = PrefsBean<int>('lastDaySigned');
  static final recommendedWord = PrefsBean<String>('recommendedWord');
}

class PrefsBean<T> with PreferencesUtil<T> {
  PrefsBean(this._key, [this._default]) {
    _default ??= _getDefaultValue();
  }

  final String _key;
  T? _default;

  T get value => _getValue(_key) ?? _default;

  // 这个判断不能加，因为不存储的话原生那边获取不到，除非原生那边也设置了默认值
  // if (value == newValue) return;
  set value(T newValue) => _setValue(newValue, _key);

  void clear() => _clearValue(_key);
}

mixin PreferencesUtil<T> {
  static SharedPreferences get pref => CommonPreferences.sharedPref;

  dynamic _getValue(String key) => pref.get(key);

  _setValue(T value, String key) async {
    switch (T) {
      case String:
        await pref.setString(key, value as String);
        break;
      case bool:
        await pref.setBool(key, value as bool);
        break;
      case int:
        await pref.setInt(key, value as int);
        break;
      case double:
        await pref.setDouble(key, value as double);
        break;
      case List:
        await pref.setStringList(key, value as List<String>);
        break;
    }
  }

  void _clearValue(String key) async => await pref.remove(key);

  dynamic _getDefaultValue() {
    switch (T) {
      case String:
        return '';
      case int:
        return 0;
      case double:
        return 0.0;
      case bool:
        return false;
      case List:
        return [];
      default:
        return null;
    }
  }
}
