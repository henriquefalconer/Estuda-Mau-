import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/main_navigation_brain.dart';
import 'package:estuda_maua/screens/main_navigation_screen/main_navigation_top_area.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:estuda_maua/screens/main_navigation_screen/main_navigation_page_content.dart';
import 'package:provider/provider.dart';
import 'navigation_bottom_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  static String id = 'course_choice_screen';

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation topScreenAnimation;

//  final _fireMessages = FirebaseMessaging();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    Provider.of<UserBrain>(context, listen: false).signOut();
    Provider.of<MediasBrain>(context, listen: false).signOut();
    Provider.of<MonitoriaBrain>(context, listen: false).signOut();
    Provider.of<NetworkBrain>(context, listen: false).signOut();
  }

  @override
  void initState() {
    super.initState();
//    _fireMessages.getToken().then((token) {
//      print(token);
//    });
//    _fireMessages.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print('onMessage: $message');
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('onResume: $message');
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print('onLaunch: $message');
//      },
//    );
    Provider.of<MonitoriaBrain>(context, listen: false).modoMonitor = false;
    Provider.of<MainNavigationBrain>(context, listen: false)
        .changeMainNavigationScreen(MainScreens.Monitoria);
    animationSetup(
      key: topScreenAnimation,
      duration: Duration(milliseconds: 700),
    );
  }

  Future<void> animationSetup(
      {@required Animation key, @required Duration duration}) async {
    controller = AnimationController(
      duration: duration,
      vsync: this,
    );

    topScreenAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              TopScreenArea(
                cardHeight: 90.0 + (1 - topScreenAnimation.value) * 90,
                titleSize: 27.0,
                userPictureRadius: topScreenAnimation.value * 28.0,
              ),
              Expanded(
                child: MainPageContent(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 15.0,
          ),
          child: NavigationBar(),
        ),
      ),
    );
  }
}
