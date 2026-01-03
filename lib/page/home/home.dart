import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quest_app/page/center/center.dart';
import 'package:quest_app/page/index/index.dart';
import '../../helper/style.dart';
import '../../provider/route_state.dart';
import '../accept/accept.dart';
import '../order/order.dart';
import 'home_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> _dialogExitApp(BuildContext context) async {
    return Future.value(false);
  }
  String? token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    // final sharedPrefs = getIt<SharedPreferenceHelper>();
    // final String? cacheToken = await sharedPrefs.getToken();
    // setState(() {
    //   token = cacheToken;
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routerState = Provider.of<RouterState>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        return _dialogExitApp(context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getSystemUiOverlayStyle(false),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: routerState.changeIndex,
                  controller: routerState.pageController,
                  children: [
                    CenterPage(),
                    AcceptPage(),
                    CenterPage(),
                    IndexPage(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: const HomeBottomBar(),
        ),
      ),
    );
  }
}
