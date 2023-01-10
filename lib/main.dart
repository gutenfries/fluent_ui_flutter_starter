import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/link.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/home.dart';
import 'screens/settings.dart';

import 'routes/forms.dart' deferred as forms;
import 'routes/inputs.dart' deferred as inputs;
import 'routes/navigation.dart' deferred as navigation;
import 'routes/surfaces.dart' deferred as surfaces;
import 'routes/theming.dart' deferred as theming;

import 'theme.dart';
import 'constants.dart';
import 'widgets/deferred_widget.dart';

import 'debug.dart';

// import 'ffi/ffi.dart' if (dart.library.html) 'ffi/ffi_web.dart';

const String appTitle = 'fluent_ui_flutter_starter Beta';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if either in Debug or Profile mode, dump the environment
  if (!Constants.isReleaseMode) Debug.dumpEnviroment();

  // Platform platform = await api.platform();
  // bool isRelease = await api.rustReleaseMode();
  // print(await api.add(a: 1, b: 2));
  // print(platform);
  // print(isRelease);

  // if supported, load the system accent color
  if (Constants.isSystemAccentColorSupported) SystemTheme.accentColor.load();

  // set the url strategy
  setPathUrlStrategy();

  // If on a desktop platform, initialize the window manager
  if (Constants.isDesktop) {
    await flutter_acrylic.Window.initialize();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      // await windowManager.setSize(const Size(755, 545));
      await windowManager.setMinimumSize(const Size(350, 600));
      // await windowManager.center();
      await windowManager.show();
      // await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  runApp(const App());

  // preload and defer the screens that are not used on startup.
  // this will improve startup time.
  DeferredWidget.preload(forms.loadLibrary);
  DeferredWidget.preload(inputs.loadLibrary);
  DeferredWidget.preload(navigation.loadLibrary);
  DeferredWidget.preload(surfaces.loadLibrary);
  DeferredWidget.preload(theming.loadLibrary);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          darkTheme: ThemeData(
            fontFamily: 'SegoeUI',
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          theme: ThemeData(
            fontFamily: 'SegoeUI',
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          initialRoute: '/',
          routes: {'/': (context) => const MyHomePage()},
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool value = false;

  int index = 0;

  final viewKey = GlobalKey();

  final searchKey = GlobalKey();
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  final List<NavigationPaneItem> originalItems = [
    PaneItem(
      icon: const Icon(TablerIcons.home),
      title: const Text('Home'),
      body: const HomePage(),
    ),
    PaneItemHeader(header: const Text('Inputs')),
    PaneItem(
      icon: const Icon(TablerIcons.rectangle),
      title: const Text('Button'),
      body: DeferredWidget(
        inputs.loadLibrary,
        () => inputs.ButtonPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.checkbox),
      title: const Text('Checkbox'),
      body: DeferredWidget(
        inputs.loadLibrary,
        () => inputs.CheckBoxPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.git_commit),
      title: const Text('Slider'),
      body: DeferredWidget(
        inputs.loadLibrary,
        () => inputs.SliderPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.toggle_left),
      title: const Text('ToggleSwitch'),
      body: DeferredWidget(
        inputs.loadLibrary,
        () => inputs.ToggleSwitchPage(),
      ),
    ),
    PaneItemHeader(header: const Text('Form')),
    PaneItem(
      icon: const Icon(TablerIcons.input_search),
      title: const Text('TextBox'),
      body: DeferredWidget(
        forms.loadLibrary,
        () => forms.TextBoxPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.list_details),
      title: const Text('AutoSuggestBox'),
      body: DeferredWidget(
        forms.loadLibrary,
        () => forms.AutoSuggestBoxPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.list_check),
      title: const Text('ComboBox'),
      body: DeferredWidget(
        forms.loadLibrary,
        () => forms.ComboBoxPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.clock),
      title: const Text('TimePicker'),
      body: DeferredWidget(
        forms.loadLibrary,
        () => forms.TimePickerPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.calendar),
      title: const Text('DatePicker'),
      body: DeferredWidget(
        forms.loadLibrary,
        () => forms.DatePickerPage(),
      ),
    ),
    PaneItemHeader(header: const Text('Navigation')),
    PaneItem(
      icon: const Icon(TablerIcons.navigation),
      title: const Text('NavigationView'),
      body: DeferredWidget(
        navigation.loadLibrary,
        () => navigation.NavigationViewPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.table),
      title: const Text('TabView'),
      body: DeferredWidget(
        navigation.loadLibrary,
        () => navigation.TabViewPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.tree),
      title: const Text('TreeView'),
      body: DeferredWidget(
        navigation.loadLibrary,
        () => navigation.TreeViewPage(),
      ),
    ),
    PaneItemHeader(header: const Text('Surfaces')),
    PaneItem(
      icon: const Icon(TablerIcons.color_swatch),
      title: const Text('Acrylic'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.AcrylicPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.apple),
      title: const Text('CommandBar'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.CommandBarsPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.alert_triangle),
      title: const Text('ContentDialog'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.ContentDialogPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.layout_bottombar_expand),
      title: const Text('Expander'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.ExpanderPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.info_square),
      title: const Text('InfoBar'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.InfoBarsPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.loader),
      title: const Text('Progress Indicators'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.ProgressIndicatorsPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.square),
      title: const Text('Tiles'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.TilesPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.tooltip),
      title: const Text('Tooltip'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.TooltipPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.layout_navbar_expand),
      title: const Text('Flyout'),
      body: DeferredWidget(
        surfaces.loadLibrary,
        () => surfaces.FlyoutPage(),
      ),
    ),
    PaneItemHeader(header: const Text('Theming')),
    PaneItem(
      icon: const Icon(TablerIcons.color_picker),
      title: const Text('Colors'),
      body: DeferredWidget(
        theming.loadLibrary,
        () => theming.ColorsPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.text_caption),
      title: const Text('Typography'),
      body: DeferredWidget(
        theming.loadLibrary,
        () => theming.TypographyPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.brand_github),
      title: const Text('Icons'),
      body: DeferredWidget(
        theming.loadLibrary,
        () => theming.IconsPage(),
      ),
    ),
    PaneItem(
      icon: const Icon(TablerIcons.focus),
      title: const Text('Reveal Focus'),
      body: DeferredWidget(
        theming.loadLibrary,
        () => theming.RevealFocusPage(),
      ),
    ),
  ];
  final List<NavigationPaneItem> footerItems = [
    PaneItemSeparator(),
    PaneItem(
      icon: const Icon(TablerIcons.settings),
      title: const Text('Settings'),
      body: Settings(),
    ),
    _LinkPaneItemAction(
      icon: const Icon(TablerIcons.git_commit),
      title: const Text('Source code'),
      link: 'https://github.com/gutenfries/fluent_ui_flutter_starter',
      body: const SizedBox.shrink(),
    ),
  ];

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: () {
          // On web, left align the app header
          if (Constants.isWeb) {
            return const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            );
          }
          // Center the app header on mobile
          if (Constants.isMobile) {
            return const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Align(
                child: Text(appTitle),
              ),
            );
          }
          // On desktop, left align the app header on the draggable area
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // If Platform is Mobile, do not display dark mode toggle switch in the app bar
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              // don't display dark mode toggle switch on mobile
              child: Constants.isMobile
                  ? null
                  : Align(
                      child: ToggleSwitch(
                        checked: FluentTheme.of(context).brightness.isDark,
                        content: Icon(
                          FluentTheme.of(context).brightness.isDark
                              ? TablerIcons.sun
                              : TablerIcons.moon,
                        ),
                        onChanged: (v) {
                          if (v) {
                            appTheme.mode = ThemeMode.dark;
                          } else {
                            appTheme.mode = ThemeMode.light;
                          }
                        },
                      ),
                    ),
            ),
            // Only display desktop controls on desktop native platforms.
            if (Constants.isDesktop) const WindowButtons(),
          ],
        ),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) {
          setState(() => index = i);
        },
        header: SizedBox(
          height: kOneLineTileHeight,
          child: ShaderMask(
            shaderCallback: (rect) {
              final color = appTheme.color.resolveFromReverseBrightness(
                theme.brightness,
                level: theme.brightness == Brightness.light ? 0 : 2,
              );
              return LinearGradient(
                colors: [
                  color,
                  color,
                ],
              ).createShader(rect);
            },
            child: const FlutterLogo(
              style: FlutterLogoStyle.horizontal,
              size: 80.0,
              textColor: Colors.white,
              duration: Duration.zero,
            ),
          ),
        ),
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
            default:
              return const StickyNavigationIndicator();
          }
        }(),
        items: originalItems,
        autoSuggestBox: AutoSuggestBox(
          key: searchKey,
          focusNode: searchFocusNode,
          controller: searchController,
          items: originalItems.whereType<PaneItem>().map((item) {
            assert(item.title is Text);
            final text = (item.title as Text).data!;

            return AutoSuggestBoxItem(
              label: text,
              value: text,
              onSelected: () async {
                final itemIndex = NavigationPane(
                  items: originalItems,
                ).effectiveIndexOf(item);

                setState(() => index = itemIndex);
                await Future.delayed(const Duration(milliseconds: 17));
                searchController.clear();
              },
            );
          }).toList(),
          placeholder: 'Search',
        ),
        autoSuggestBoxReplacement: const Icon(TablerIcons.search),
        footerItems: footerItems,
      ),
      onOpenSearch: () {
        searchFocusNode.requestFocus();
      },
    );
  }

  // @override
  // void onWindowClose() async {
  //   bool isPreventClose = await windowManager.isPreventClose();
  //   if (isPreventClose) {
  //     showDialog(
  //       context: context,
  //       builder: (_) {
  //         return ContentDialog(
  //           title: const Text('Confirm close'),
  //           content: const Text('Are you sure you want to close this window?'),
  //           actions: [
  //             FilledButton(
  //               child: const Text('Yes'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 windowManager.destroy();
  //               },
  //             ),
  //             Button(
  //               child: const Text('No'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  void onWindowClose() {
    Navigator.pop(context);
    windowManager.destroy();
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _LinkPaneItemAction extends PaneItem {
  _LinkPaneItemAction({
    required super.icon,
    required this.link,
    required super.body,
    super.title,
  });

  final String link;

  @override
  Widget build(
    BuildContext context,
    bool selected,
    VoidCallback? onPressed, {
    PaneDisplayMode? displayMode,
    bool showTextOnTop = true,
    bool? autofocus,
    int? itemIndex,
  }) {
    return Link(
      uri: Uri.parse(link),
      builder: (context, followLink) => super.build(
        context,
        selected,
        followLink,
        displayMode: displayMode,
        showTextOnTop: showTextOnTop,
        itemIndex: itemIndex,
        autofocus: autofocus,
      ),
    );
  }
}
