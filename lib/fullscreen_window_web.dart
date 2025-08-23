// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
import 'package:web/web.dart' as web show window;
import 'dart:js_interop';

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'fullscreen_window_platform_interface.dart';

@JS()
external Window get window;

@JS()
@staticInterop
class Window {}

extension WindowExtension on Window {
  @JS('navigator')
  external WebNavigator get navigator;
}

@JS()
@staticInterop
class WebNavigator {}

extension WebNavigatorExtension on WebNavigator {
  @JS('keyboard')
  external Keyboard get keyboard;
}

@JS()
@staticInterop
class Keyboard {}

extension KeyboardExtension on Keyboard {
  @JS('lock')
  external JSPromise lock([JSArray keyCodes]);
  @JS('unlock')
  external JSVoid unlock();
}

/// A web implementation of the FullscreenWindowPlatform of the FullscreenWindow plugin.
class FullScreenWindowWeb extends FullScreenWindowPlatform {
  /// Constructs a FullscreenWindowWeb
  FullScreenWindowWeb();

  static void registerWith(Registrar registrar) {
    FullScreenWindowPlatform.instance = FullScreenWindowWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<void> setFullScreen(bool isFullScreen) async {
    if (isFullScreen) {
      web.window.document.documentElement?.requestFullscreen();
      window.navigator.keyboard.lock();
    } else {
      web.window.document.exitFullscreen();
      window.navigator.keyboard.unlock();
    }
  }

  @override
  Future<Size> getScreenSize(BuildContext? context) async {
    var width = web.window.screen.width;
    var height = web.window.screen.height;
    return Size(width.toDouble(), height.toDouble());
  }
}
