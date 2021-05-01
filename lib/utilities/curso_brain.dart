import 'package:flutter/cupertino.dart';

class CursoBrain extends ChangeNotifier {
  List<String> courses() => List.from(_courseSet.keys);

  Map<String, Map<String, dynamic>> _courseSet = {
    'EFB106 - Vetores e Geometria Analítica': {
      'favorited': true,
      'url': 'https://imt.mrooms.net/course/view.php?id=210',
      'imageURL':
          'https://conexaoestudante.com.br/wp-content/uploads/2019/04/geometria.jpg',
    },
    'EFB207 - Física I': {
      'favorited': true,
      'url': 'https://imt.mrooms.net/course/view.php?id=214',
      'imageURL':
          'https://s1.static.brasilescola.uol.com.br/be/conteudo/images/a-olimpiada-brasileira-fisica-pode-ser-utilizada-como-estimulo-ao-estudo-fisica-5970cfc67f54d.jpg',
    },
    'EFB105 - Cálculo Diferencial e Integral I': {
      'favorited': false,
      'url': 'https://imt.mrooms.net/course/view.php?id=209',
      'imageURL':
          'https://st.depositphotos.com/1007995/1960/i/450/depositphotos_19608595-stock-photo-business-man-looking-at-some.jpg'
    },
    'EFB106 - Química': {
      'favorited': false,
      'url': 'https://imt.mrooms.net/course/view.php?id=218',
      'imageURL':
          'https://cdn.mos.cms.futurecdn.net/PLcixwv9qrPXCp99jdzw57-320-80.jpg'
    },
    'EFB604 - Fundamentos de Engenharia': {
      'favorited': true,
      'url': 'https://imt.mrooms.net/course/view.php?id=219',
      'imageURL':
          'https://abrilguiadoestudante.files.wordpress.com/2016/12/engenharia-civil-obras-1024x683.jpg',
    },
    'EFB302 - Desenho': {
      'favorited': false,
      'url': 'https://imt.mrooms.net/course/view.php?id=216',
      'imageURL':
          'https://imagens-revista-pro.vivadecora.com.br/uploads/2018/08/desenho-tecnico.jpg',
    },
    'EFB403.pdf': {
      'favorited': false,
      'url': 'https://imt.mrooms.net/course/view.php?id=217',
      'imageURL':
          'https://portal.comunique-se.com.br/wp-content/uploads/2019/08/algoritmos-990x556.jpg',
    },
  };

  bool _editing = false;
  bool get editing => _editing;

  String _selectedCourse;
  String get selectedCourse => _selectedCourse;
  void changeSelectedCourse(String newCourse) {
    _selectedCourse = newCourse;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> get listOfCourseWidgetsInfo async {
    List<Map<String, dynamic>> courseInfoList = [];

    List<dynamic> unorderedCoursesNames = [];
    List<String> favoritedCoursesNames = [];
    List<String> unfavoritedCoursesNames = [];
    List<String> orderedCoursesNames = [];

    unorderedCoursesNames = _courseSet.keys.toList();

    for (String course in unorderedCoursesNames) {
      if (_courseSet[course]['favorited'] == true) {
        favoritedCoursesNames.add(course);
      } else {
        unfavoritedCoursesNames.add(course);
      }
    }

    favoritedCoursesNames.sort();
    unfavoritedCoursesNames.sort();
    orderedCoursesNames = favoritedCoursesNames + unfavoritedCoursesNames;

    for (String course in orderedCoursesNames) {
      courseInfoList.add({
        'courseName': course,
        'favorited': _courseSet[course]['favorited'],
        'imageURL': _courseSet[course]['imageURL'],
        'onFavoritedPress': () {
          _courseSet[course]['favorited'] = !_courseSet[course]['favorited'];
          notifyListeners();
        },
      });
    }

    return courseInfoList;
  }

  void onTapEditButton() {
    _editing = !_editing;
    for (String course in _courseSet.keys) {
      _courseSet[course]['checkSelected'] = false;
    }
    notifyListeners();
  }

  bool get allCoursesChecked {
    bool allChecked = true;
    for (String course in _courseSet.keys) {
      if (_courseSet[course]['checkSelected'] == false) {
        allChecked = false;
      }
    }
    return allChecked;
  }

  void onTapVisibilityButton() {
    for (String course in _courseSet.keys) {
      if (_courseSet[course]['checkSelected']) {
        _courseSet[course]['invisible'] = false;
      }
    }
    notifyListeners();
  }

  void onTapInvisibilityButton() {
    for (String course in _courseSet.keys) {
      if (_courseSet[course]['checkSelected']) {
        _courseSet[course]['invisible'] = true;
      }
    }
    notifyListeners();
  }

  void onTapSelectAllButton() {
    for (String course in _courseSet.keys) {
      _courseSet[course]['checkSelected'] = !allCoursesChecked;
    }
    notifyListeners();
  }
}
