import 'dart:developer' as developer;
import 'dart:io';

import 'constants.dart';

/// Utility class that contains helpful debug functions and information
class Debug {
  /// Prints out ALL available environmental information to the dart stdout.
  /// (will print in the web console if running on web)
  static void dumpEnviroment() {
    debugLog(
      '\n -- DEBUG ENVIROMENT DUMP --\n',
      showTime: false,
      color: _ANSI.blue,
    );
    debugLog(
      '\n -- Enviromental Variables --\n',
      showTime: false,
      color: _ANSI.blue,
    );
    for (final entry in Platform.environment.entries) {
      if (entry.key.contains('PATH')) {
        debugLog(
          ' - ${entry.key}: ${_colorizePathVar(entry.value)}',
          showTime: false,
        );
      } else {
        debugLog(
          ' - ${entry.key}: ${_colorizeVar(entry.value)}',
          showTime: false,
        );
      }
    }
    debugLog(
      '\n -- Platform constants: --\n',
      showTime: false,
      color: _ANSI.blue,
    );
    debugLog(
      ' - Platform: ${_colorizeVar(Constants.currentPlatform)}',
      showTime: false,
    );
    debugLog(
      ' - IsWeb: ${_colorizeVar(Constants.isWeb)}',
      showTime: false,
    );
    debugLog(
      ' - IsNative: ${_colorizeVar(Constants.isNative)}',
      showTime: false,
    );
    debugLog(
      ' - IsDesktop: ${_colorizeVar(Constants.isDesktop)}',
      showTime: false,
    );
    debugLog(
      ' - IsMobile: ${_colorizeVar(Constants.isMobile)}',
      showTime: false,
    );
    debugLog(
      ' - IsWindowEffectsSupported: ${_colorizeVar(Constants.isWindowEffectsSupported)}',
      showTime: false,
    );
    debugLog(
      ' - IsSystemAccentColorSupported: ${_colorizeVar(Constants.isSystemAccentColorSupported)}',
      showTime: false,
    );
    debugLog(
      ' - IsWindows: ${_colorizeVar(Constants.isWindows)}',
      showTime: false,
    );
    debugLog(
      ' - IsLinux: ${_colorizeVar(Constants.isLinux)}',
      showTime: false,
    );
    debugLog(
      ' - IsMacOS: ${_colorizeVar(Constants.isMacOS)}',
      showTime: false,
    );
    debugLog(
      ' - IsAndroid: ${_colorizeVar(Constants.isAndroid)}',
      showTime: false,
    );
    debugLog(
      ' - IsIOS: ${_colorizeVar(Constants.isIOS)}',
      showTime: false,
    );
    debugLog(
      ' - IsNativeWindows: ${_colorizeVar(Constants.isNativeWindows)}',
      showTime: false,
    );
    debugLog(
      ' - IsNativeLinux: ${_colorizeVar(Constants.isNativeLinux)}',
      showTime: false,
    );
    debugLog(
      ' - IsNativeMacOS: ${_colorizeVar(Constants.isNativeMacOS)}',
      showTime: false,
    );
    debugLog(
      ' - IsNativeAndroid: ${_colorizeVar(Constants.isNativeAndroid)}',
      showTime: false,
    );
    debugLog(
      ' - IsNativeIOS: ${_colorizeVar(Constants.isNativeIOS)}',
      showTime: false,
    );
    debugLog(
      ' - IsDebugMode: ${_colorizeVar(Constants.isDebugMode)}',
      showTime: false,
    );
    debugLog(
      ' - IsProfileMode: ${_colorizeVar(Constants.isProfileMode)}',
      showTime: false,
    );
    debugLog(
      ' - IsReleaseMode: ${_colorizeVar(Constants.isReleaseMode)}',
      showTime: false,
    );
  }

  /// returns all the enviromenal variables
  static Map<String, String> getEnviroment() {
    return Platform.environment;
  }

  /// Cleanly formats PATH enviromental variable entries
  /// - `String path` - the path to format
  static String _colorizePathVar(String path) {
    // check if the string contains a semi colon. return if it does not
    if (!path.contains(';')) return _colorizeVar(path);
    // add a newline and another indentation after every semi-colon
    path = path.replaceAll(';', ';\n    ');
    // return the colorized string
    return _colorizeVar('\n    $path');
  }

  /// Color a string
  ///
  /// - `String string` - the string to colorize
  /// - `ColorString color` - the color to use
  static String _colorize(String string, String color) {
    // return the colorized string
    return '${_ANSI.esc}$color$string${_ANSI.esc}${_ANSI.eol}';
  }

  /// Prints a message to the console
  /// - `String message` - the message to print
  /// - `String? color` - color to use for the message
  /// - `bool? newLine` - if true, a new line will be added after the message
  /// - `bool? showTime` - if true, the current time will be added to the message
  /// - `bool? showStackTrace` - if true, the current stack trace will be added to the message
  static void debugLog(
    String message, {
    String? color,
    bool? newLine,
    bool? showTime,
    bool? showStackTrace,
  }) {
    if (color != null) {
      // colorize the message
      message = _colorize(message, color);
      // drop `color` form the heap
      color = null;
    }

    // show time by default
    if (showTime != null && !showTime) {
      // drop `showTime` form the heap
      showTime = null;
    } else {
      // add the current time to the message
      message = '${DateTime.now()} - $message';
    }

    if (showStackTrace != null && showStackTrace) {
      // add the current stack trace to the message
      message = '$message\n${StackTrace.current}';
      // drop `showStackTrace` form the heap
      showStackTrace = null;
    }

    // add a newline by default
    if (newLine != null && !newLine) {
      newLine = null;
    } else {
      // add a new line to the message
      message = '$message\n';
    }

    // print the message
    if (!Constants.isWeb) {
      // prefer stdout on native
      stdout.write(message);
      // write the message to the dart developer console (extranious on web)
      developer.log(message, name: 'Debug');
    } else {
      // web doesn't have stdout
      print(message);
    }
  }

  /// Colors a boolean? value for printing.
  ///
  /// `false` values are colored red, `true` values are colored green, and `null` values are colored orange.
  /// - `bool? value` - the value to colorize
  static String _colorizeVar(Object? value) {
    // colorize the value
    // value is null
    if (value == null) {
      return _colorize('null', _ANSI.yellow);
      // value is true
    } else if (value == true) {
      return _colorize('true', _ANSI.green);
      // value is false
    } else if (value == false) {
      return _colorize('false', _ANSI.red);
      // value is a string
    } else if (value is String) {
      return _colorize(value.toString(), _ANSI.lightGreen);
      // value is a number
    } else if (value is num) {
      return _colorize(value.toString(), _ANSI.orange);
      // unknown type
    } else {
      return _colorize(value.toString(), _ANSI.purple);
    }
  }
}

class _ANSI {
  /// ANSI Escape
  /// ignore: unused_field
  static const String esc = '\x1B[';

  /// ANSI EOL
  /// ignore: unused_field
  static const String eol = '0m';

  /// ANSI Red
  // ignore: unused_field
  static const String red = '31m';

  /// ANSI Light Green
  // ignore: unused_field
  static const String lightGreen = '32m';

  /// ANSI Green
  /// ignore: unused_field
  static const String green = '92m';

  /// ANSI Yellow
  // ignore: unused_field
  static const String yellow = '33m';

  /// ASNI Orange
  /// ignore: unused_field
  static const String orange = '33m';

  /// ANSI Blue
  // ignore: unused_field
  static const String blue = '34m';

  /// ANSI Purple
  // ignore: unused_field
  static const String purple = '35m';

  /// ANSI Cyan
  // ignore: unused_field
  static const String cyan = '36m';

  /// ANSI White
  // ignore: unused_field
  static const String white = '37m';

  /// ANSI Black
  // ignore: unused_field
  static const String black = '30m';
}
