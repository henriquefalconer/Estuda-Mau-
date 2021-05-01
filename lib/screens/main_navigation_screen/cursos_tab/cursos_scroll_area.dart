import 'package:estuda_maua/screens/moodle_navigation_screen/moodle_navigation_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/curso_brain.dart';
import 'package:estuda_maua/utilities/moodle_brain.dart';
import 'package:estuda_maua/widgets/course_card.dart';
import 'package:estuda_maua/widgets/imageless_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CursosScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: TextField(
            onChanged: (value) {
              //Do something with the user input.
            },
            decoration: kInputDecoration.copyWith(hintText: 'Buscar curso'),
          ),
        ),
        FutureBuilder(
          future: Provider.of<CursoBrain>(context).listOfCourseWidgetsInfo,
          builder: (context, snapshot) {
            List<Widget> courseList = [];

            if (!snapshot.hasData) {
              for (int i = 0; i <= 3; i++) {
                courseList.add(
                  CourseCard(
                    courseName: 'Carregando...',
                  ),
                );
              }
            } else {
              for (Map<String, dynamic> courseInfo in snapshot.data) {
                courseList.add(
                  CourseCard(
                    courseName: courseInfo['courseName'],
                    favorited: courseInfo['favorited'],
                    imageURL: courseInfo['imageURL'],
                    onCoursePress: () {
                      Provider.of<CursoBrain>(context)
                          .changeSelectedCourse(courseInfo['courseName']);
                      Provider.of<MoodleBrain>(context)
                          .changeSelectedPage('Boas vindas');
                      Navigator.pushNamed(context, MoodleNavigationScreen.id);
                    },
                    onFavoritedLongPress: courseInfo['onFavoritedPress'],
                  ),
                );
              }
            }

            return Column(
              children: courseList,
            );
          },
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: ImagelessButton(
            cardColor: Colors.blue[900],
            title: 'Inscrever-me em outros cursos',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
