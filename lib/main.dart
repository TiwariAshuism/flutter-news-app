import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/article.dart';
import 'package:flutter_application_1/gen/fonts.gen.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/profile.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // old way and new way with install flutter_gen --> 1
  // static const defaultFontFamily = 'Avenir';
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff0D253C);
    const secondaryTextColor = Color(0xff2D4379);
    const primaryColor = Color(0xff376AED);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStatePropertyAll(
              TextStyle(
                  // old way and new way with install flutter_gen --> 2
                  // fontFamily: defaultFontFamily,
                  fontFamily: FontFamily.avenir,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        colorScheme: const ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: primaryTextColor,
            background: Color(0xffFBFCFF),
            onBackground: primaryTextColor),
        appBarTheme: const AppBarTheme(
          titleSpacing: 32,
          backgroundColor: Colors.white,
          foregroundColor: primaryTextColor,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: primaryColor,
        ),
        textTheme: const TextTheme(
          //subtitle2
          titleSmall: TextStyle(
              fontFamily: FontFamily.avenir,
              color: primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400),
          //subtitle1
          titleMedium: TextStyle(
              fontFamily: FontFamily.avenir,
              color: secondaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w200),
          //headline6
          titleLarge: TextStyle(
              fontFamily: FontFamily.avenir,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryTextColor),
          //headline5
          headlineSmall: TextStyle(
              fontFamily: FontFamily.avenir,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primaryTextColor),
          //headline4
          headlineMedium: TextStyle(
              fontFamily: FontFamily.avenir,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: primaryTextColor),
          //bodyText2
          bodyMedium: TextStyle(
              fontFamily: FontFamily.avenir,
              color: secondaryTextColor,
              fontSize: 12),
          //bodyText2
          bodyLarge: TextStyle(
              fontFamily: FontFamily.avenir,
              color: primaryTextColor,
              fontSize: 14),
          //caption
          bodySmall: TextStyle(
            fontFamily: FontFamily.avenir,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            color: Color(0xff7B8BB2),
          ),
        ),
      ),
      // home: Stack( children: [ const Positioned.fill(
      // child: HomeScreen()),
      // Positioned(bottom: 0, right: 0, left: 0,
      // child: _BottomNavigation())]),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

const int homeIndex = 0;
const int articleIndex = 1;
const int searchIndex = 2;
const int menuIndex = 3;
const double bottomNavigationHeight = 65;

class _MainScreenState extends State<MainScreen> {
  int selectedScreenIndex = homeIndex;

  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _articleKey = GlobalKey();
  final GlobalKey<NavigatorState> _searchKey = GlobalKey();
  final GlobalKey<NavigatorState> _menuKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    articleIndex: _articleKey,
    searchIndex: _searchKey,
    menuIndex: _menuKey,
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 26,
              child: IndexedStack(
                index: selectedScreenIndex,
                children: [
                  _navigator(_homeKey, homeIndex, const HomeScreen()),
                  _navigator(_articleKey, articleIndex, const ArticleScreen()),
                  _navigator(
                      _searchKey,
                      searchIndex,
                      const SimpleScreen(
                        tabName: 'Search',
                      )),
                  _navigator(_menuKey, menuIndex, const ProfileScreen()),
                  // Navigator(key: _menuKey, onGenerateRoute: (settings) => MaterialPageRoute(
                  //         builder: (context) => Offstage(offstage: selectedScreenIndex != menuIndex, child: const ProfileScreen()))),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _BottomNavigation(
                onTap: (int index) {
                  setState(() {
                    _history.remove(selectedScreenIndex);
                    _history.add(selectedScreenIndex);
                    selectedScreenIndex = index;
                  });
                },
                selectedIndex: selectedScreenIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    // reduce memory usage
    return key.currentContext == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                // dont paint on unselected screen
                builder: (context) => Offstage(
                    offstage: selectedScreenIndex != index, child: child)));
  }
}

class SimpleScreen extends StatelessWidget {
  const SimpleScreen({super.key, required this.tabName, this.screenNumber = 1});
  final String tabName;
  final int screenNumber;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'tab:$tabName, Screen #$screenNumber',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SimpleScreen(
                          tabName: tabName,
                          screenNumber: screenNumber + 1,
                        )));
              },
              child: const Text('Click Me'))
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final Function(int index) onTap;
  final int selectedIndex;

  const _BottomNavigation({required this.onTap, required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: const Color(0xff988487).withOpacity(0.3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  BottomNavigationItem(
                    iconFileName: 'Home.png',
                    activeIconFileName: 'HomeActive.png',
                    title: 'Home',
                    onTap: () {
                      onTap(homeIndex);
                    },
                    isActive: selectedIndex == homeIndex,
                  ),
                  BottomNavigationItem(
                    iconFileName: 'Articles.png',
                    activeIconFileName: 'ArticlesActive.png',
                    title: 'Article',
                    onTap: () {
                      onTap(articleIndex);
                    },
                    isActive: selectedIndex == articleIndex,
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  // Expanded(child: Container()),
                  BottomNavigationItem(
                    iconFileName: 'Search.png',
                    activeIconFileName: 'SearchActive.png',
                    title: 'Search',
                    onTap: () {
                      onTap(searchIndex);
                    },
                    isActive: selectedIndex == searchIndex,
                  ),
                  BottomNavigationItem(
                    iconFileName: 'Menu.png',
                    activeIconFileName: 'MenuActive.png',
                    title: 'Menu',
                    onTap: () {
                      onTap(menuIndex);
                    },
                    isActive: selectedIndex == menuIndex,
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 65,
              height: 85,
              alignment: Alignment.topCenter,
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.5),
                  color: const Color(0xff376AED),
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Image.asset('assets/img/icons/plus.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  final String iconFileName;
  final String activeIconFileName;
  final String title;
  final Function() onTap;
  final bool isActive;

  const BottomNavigationItem(
      {super.key,
      required this.iconFileName,
      required this.activeIconFileName,
      required this.title,
      required this.onTap,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/icons/${isActive ? activeIconFileName : iconFileName}',
              width: 28,
              height: 28,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: themeData.textTheme.bodySmall!.apply(
                  color: isActive
                      ? themeData.colorScheme.primary
                      : themeData.textTheme.bodySmall!.color),
            )
          ],
        ),
      ),
    );
  }
}
