import 'package:estuda_maua/utilities/moodle_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'moodle_navigation_end_drawer.dart';

class MoodleNavigationScreen extends StatefulWidget {
  static String id = 'moodle_navigation_screen';

  @override
  _MoodleNavigationScreenState createState() => _MoodleNavigationScreenState();
}

class _MoodleNavigationScreenState extends State<MoodleNavigationScreen> {
  final GlobalKey<ScaffoldState> _moodleNavigationScreenKey =
      GlobalKey<ScaffoldState>();

  void toggleDrawer() {
    if (_moodleNavigationScreenKey.currentState.isEndDrawerOpen) {
      _moodleNavigationScreenKey.currentState.openDrawer();
    } else {
      _moodleNavigationScreenKey.currentState.openEndDrawer();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  String urlMoodle = 'https://imt.mrooms.net/';

  Future<String> getMoodleText(String url) async {
//    WebDriver webDriver =
//        await createDriver(uri: Uri.parse('https://imt.mrooms.net/'));
//    try {
//      Stream<WebElement> webElementStream =
//          webDriver.findElements(By.className('h4'));
//
//      await for (WebElement webElement in webElementStream) {
//        print(webElement.toString());
//      }
//    } catch (e) {
//      print(e);
//    }
    http.Response response = await http.get(url);

    String moodleHtml = response.body.toString();
    print(moodleHtml);
    return moodleHtml;
  }

  @override
  Widget build(BuildContext context) {
    final moodleBrain = Provider.of<MoodleBrain>(context);

    return Scaffold(
      key: _moodleNavigationScreenKey,
      endDrawer: MoodleNavigationEndDrawer(),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BlandTopArea(
              title: moodleBrain.selectedPage,
            ),
            Expanded(
              child: FutureBuilder(
                future: getMoodleText(urlMoodle),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: <Widget>[
                      Html(
                        data: snapshot.data,
                        //Optional parameters:
                        padding: EdgeInsets.all(8.0),
                        backgroundColor: Colors.white70,
                        defaultTextStyle: TextStyle(fontFamily: 'serif'),
                        linkStyle: const TextStyle(
                          color: Colors.redAccent,
                        ),
                        onLinkTap: (url) {
                          setState(() {
                            urlMoodle = url;
                          });
                        },
                        onImageTap: (src) {
                          // Display the image in large form.
                          setState(() {});
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleDrawer,
        child: Icon(Icons.format_list_bulleted),
      ),
    );
  }
}
