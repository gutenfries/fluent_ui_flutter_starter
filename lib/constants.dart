import 'package:flutter/foundation.dart' as flutter_foundation;
import 'package:flutter_acrylic/flutter_acrylic.dart';

/// Class that contains environmental constants
///
/// All members are both `const` & `static` and can be accessed directly from
/// anywhere in the program at any time with full memory safety.
class Constants {
  /// Static constant that returns the current platform as
  /// `flutter:foundatipn.TargetPlatform`.
  ///
  /// Platforms:
  /// - (Native) Windows
  /// - (Native) Unix/Linux/BSD
  /// - (Native) MacOS
  static flutter_foundation.TargetPlatform get currentPlatform =>
      flutter_foundation.defaultTargetPlatform;

  /// Static constant that returns `true` if the current application
  /// environment is on the web.
  ///
  /// This implementation takes advantage of the fact that JavaScript
  /// does not support integers. In this environment, Dart's `double`s and
  /// `int`s are backed by the same kind of object. Thus a `double` `0.0` is identical
  /// to an `integer` `0`. This is _not_ true for Dart code running in AOT or on the VM.
  ///
  /// Platforms:
  /// - Web
  ///
  /// ## See Also:
  /// - [isNative]
  static const bool isWeb = flutter_foundation.kIsWeb;

  /// Static constant that returns `true` if the current application
  /// environment is native.
  ///
  /// Platforms:
  /// - (Native) Windows
  /// - (Native) Unix/Linux/BSD
  /// - (Native) MacOS
  /// - (Native) iOS
  /// - (Native) Android
  ///
  /// ## See Also:
  /// - [isWeb]
  static const bool isNative = !flutter_foundation.kIsWeb;

  /// Static constant that returns `true` if the current application
  /// environment is native desktop.
  ///
  /// Platforms:
  /// - (Native) Windows
  /// - (Native) Unix/Linux/BSD
  /// - (Native) MacOS
  static bool get isDesktop {
    if (flutter_foundation.kIsWeb) return false;
    return [
      flutter_foundation.TargetPlatform.windows,
      flutter_foundation.TargetPlatform.linux,
      flutter_foundation.TargetPlatform.macOS,
    ].contains(flutter_foundation.defaultTargetPlatform);
  }

  /// Static constant that returns `true` if the current application
  /// environment is native mobile.
  ///
  /// Platforms:
  /// - (Native) iOS
  /// - (Native) Android
  static bool get isMobile {
    if (flutter_foundation.kIsWeb) return false;
    return [
      flutter_foundation.TargetPlatform.android,
      flutter_foundation.TargetPlatform.iOS,
    ].contains(flutter_foundation.defaultTargetPlatform);
  }

  /// Static constant that returns `true` if the current application
  /// environment supports a window transparency effects.
  ///
  /// Suppported platforms: (All desktop platforms)
  /// - (Native) Windows
  /// - (Native) Unix/Linux/BSD
  /// - (Native) MacOS
  static bool get isWindowEffectsSupported {
    return !flutter_foundation.kIsWeb &&
        [
          flutter_foundation.TargetPlatform.windows,
          flutter_foundation.TargetPlatform.linux,
          flutter_foundation.TargetPlatform.macOS,
        ].contains(flutter_foundation.defaultTargetPlatform);
  }

  /// Static constant that returns `true` if the current application
  /// environment supports a system accent color.
  ///
  /// Suppported platforms:
  /// - (Native) Windows
  /// - (Native) Android
  /// - Web
  static bool get isSystemAccentColorSupported {
    return flutter_foundation.kIsWeb ||
        [
          flutter_foundation.TargetPlatform.windows,
          flutter_foundation.TargetPlatform.android,
        ].contains(flutter_foundation.defaultTargetPlatform);
  }

  /// Static constant that returns `true` if the current application
  /// environment is running on Windows.
  ///
  /// Windows: https://www.windows.com/
  ///
  /// ## See Also:
  /// - [isNativeWindows]
  static bool get isWindows =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.windows;

  /// Static constant that returns `true` if the current application
  /// environment is running on Linux.
  ///
  /// Linux: https://www.linux.org/
  ///
  /// ## See Also:
  /// - [isNativeLinux]
  static bool get isLinux =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.linux;

  /// Static constant that returns `true` if the current application
  /// environment is running on MacOS.
  ///
  /// MacOS: https://www.apple.com/macos/
  ///
  /// ## See Also:
  /// - [isNativeMacOS]
  static bool get isMacOS =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.macOS;

  /// Static constant that returns `true` if the current application
  /// environment is running on Android.
  ///
  /// Android: https://www.android.com/
  ///
  /// ## See Also:
  /// - [isNativeAndroid]
  static bool get isAndroid =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.android;

  /// Static constant that returns `true` if the current application
  /// environment is running on iOS.
  ///
  /// iOS: https://www.apple.com/ios/
  ///
  /// ## See Also:
  /// - [isNativeIOS]
  static bool get isIOS =>
      flutter_foundation.defaultTargetPlatform ==
      flutter_foundation.TargetPlatform.iOS;

  /// Static constant that returns `true` if the current application
  /// environment is running on native Windows.
  ///
  /// Windows: https://www.windows.com
  ///
  /// ## See Also:
  /// - [isNative]
  /// - [isWindows]
  static bool get isNativeWindows =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on Windows
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.windows;

  /// Static constant that returns `true` if the current application
  /// environment is running on native Linux.
  ///
  /// Linux: https://www.linux.org
  ///
  /// ## See Also:
  /// - [isNative]
  /// - [isLinux]
  static bool get isNativeLinux =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on Linux
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.linux;

  /// Static constant that returns `true` if the current application
  /// environment is running on native MacOS.
  ///
  /// macOS: https://www.apple.com/macos
  ///
  /// ## See Also:
  /// - [isNative]
  /// - [isMacOS]
  static bool get isNativeMacOS =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on MacOS
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.macOS;

  /// Static constant that returns `true` if the current application
  /// environment is running on native Android.
  ///
  /// Android: https://www.android.com/
  ///
  /// ## See Also:
  /// - [isNative]
  /// - [isAndroid]
  static bool get isNativeAndroid =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on Android
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.android;

  /// Static constant that returns `true` if the current application
  /// environment is running on native iOS.
  ///
  /// iOS: https://www.apple.com/ios/
  ///
  /// ## See Also:
  /// - [isNative]
  /// - [isIOS]
  static bool get isNativeIOS =>
      // if isn't on the web
      !flutter_foundation.kIsWeb &&
      // and is on IOS
      flutter_foundation.defaultTargetPlatform ==
          flutter_foundation.TargetPlatform.iOS;

  /// Static constant that returns `true` if the current application
  /// environment was compiled in debug mode.
  ///
  /// More specifically, this is a constant that is true if the application
  /// **WAS NOT** compiled with
  ///
  /// `-Ddart.vm.product=true` _and_ `-Ddart.vm.profile=true`.
  ///
  /// ## See Also:
  /// - [isProfileMode]
  /// - [isReleaseMode]
  static const bool isDebugMode = flutter_foundation.kDebugMode;

  /// Static constant that returns `true` if the current application
  /// environment was compiled in profile mode.
  ///
  /// More specifically, this is a constant that is true if the application
  /// **WAS** compiled in Dart with
  ///
  /// `-Ddart.vm.profile=true`.
  ///
  /// ## See Also:
  /// - [isDebugMode]
  /// - [isReleaseMode]
  static const bool isProfileMode = flutter_foundation.kProfileMode;

  /// Static constant that returns `true` if the current application
  /// environment was compiled in release mode.
  ///
  /// More specifically, this is a constant that is true if the application
  /// **WAS** compiled in Dart with
  ///
  /// `-Ddart.vm.product=true`.
  ///
  /// ## See Also:
  /// - [isDebugMode]
  /// - [isProfileMode]
  static const bool isReleaseMode = flutter_foundation.kReleaseMode;

  static const linuxWindowEffects = [
    WindowEffect.disabled,
    WindowEffect.transparent,
  ];

  static const windowsWindowEffects = [
    WindowEffect.disabled,
    WindowEffect.solid,
    WindowEffect.transparent,
    WindowEffect.aero,
    WindowEffect.acrylic,
    WindowEffect.mica,
    WindowEffect.tabbed,
  ];

  static const macosWindowEffects = [
    WindowEffect.disabled,
    WindowEffect.titlebar,
    WindowEffect.selection,
    WindowEffect.menu,
    WindowEffect.popover,
    WindowEffect.sidebar,
    WindowEffect.headerView,
    WindowEffect.sheet,
    WindowEffect.windowBackground,
    WindowEffect.hudWindow,
    WindowEffect.fullScreenUI,
    WindowEffect.toolTip,
    WindowEffect.contentBackground,
    WindowEffect.underWindowBackground,
    WindowEffect.underPageBackground,
  ];

  static List<WindowEffect> get supportedWindowEffects {
    if (Constants.isWeb) return [];

    if (Constants.isNativeWindows) {
      return windowsWindowEffects;
    } else if (Constants.isNativeLinux) {
      return linuxWindowEffects;
    } else if (Constants.isNativeMacOS) {
      return macosWindowEffects;
    }

    return [];
  }
}
