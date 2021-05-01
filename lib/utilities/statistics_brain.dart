import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';
import 'general_functions_brain.dart';

class StatisticsBrain extends ChangeNotifier {
  Firestore _firestore = Firestore.instance;

  bool isAscending = true;
  SortType selectedSortType = SortType.position;

  List<UserStatisticsInfo> usersStatistics;

  EstatisticasType rankingType = EstatisticasType.graficos;

  void changeRankingType(EstatisticasType estatisticasType) {
    rankingType = estatisticasType;
    notifyListeners();
  }

  Future<int> getUserPosition(String user) async {
    await getUsersStatisticsInfo();

    for (UserStatisticsInfo userStatisticsInfo in usersStatistics) {
      if (userStatisticsInfo.userRA == user) {
        return userStatisticsInfo.position;
      }
    }
    return null;
  }

  Future<List<InfoGraphBar>> getUsersGraphInfo() async {
    QuerySnapshot notasCollection =
        await _firestore.collection('dados_notas').getDocuments();

    List<InfoGraphBar> dataLocal = [];

    Map<double, int> quantidadeDeAlunos = {};

    for (double i = -1.0; i <= 10.0; i = i + 1.0) {
      quantidadeDeAlunos[i] = 0;
    }

    for (DocumentSnapshot usuario in notasCollection.documents) {
      quantidadeDeAlunos[GeneralFunctionsBrain.roundNumber(
          usuario.data['medias']['finais']['geral'], 0)]++;
      dataLocal.add(
        InfoGraphBar(
          nota: GeneralFunctionsBrain.roundNumber(
              usuario.data['medias']['finais']['geral'], 0),
//          notaIsMine: i ==
//              GeneralFunctionsBrain.roundNumber(
//                  Provider.of<MediasBrain>(context).calcularMediaGeral,
//                  roundToDecimalPlace: 0),
        ),
      );
    }

    for (InfoGraphBar infoGraphBar in dataLocal) {
      infoGraphBar.quantidadeDeAlunos = quantidadeDeAlunos[infoGraphBar.nota];
    }

    dataLocal.sort((a, b) => (a.nota - b.nota).toInt());

    return dataLocal;
  }

  Future<bool> getUsersStatisticsInfo() async {
    usersStatistics.clear();
//    initDataDebug(30);
    QuerySnapshot notasCollection =
        await _firestore.collection('dados_notas').getDocuments();

    List<UserStatisticsInfo> usersStatisticsLocal = [];

    for (DocumentSnapshot usuario in notasCollection.documents) {
      usersStatisticsLocal.add(
        UserStatisticsInfo(
          position: -1,
          mediaGeral: usuario.data['medias']['finais']['geral'],
          userRA: usuario.documentID,
        ),
      );
    }
    usersStatistics = usersStatisticsLocal;

    sortNota(true);

    int position = 1;

    for (UserStatisticsInfo userStatisticsInfo in usersStatistics) {
      userStatisticsInfo.position = position;
      position++;
    }

    notifyListeners();
    return true;
  }

  void initDataDebug(int size) {
    Random random = Random();
    for (int i = 1; i < size; i++) {
      usersStatistics.add(
        UserStatisticsInfo(
          position: i,
          mediaGeral: i.toDouble(),
          userRA: '19.${random.nextInt(100000)}-0',
        ),
      );
    }
  }

  void sortPosition(bool isAscending) {
    usersStatistics
        .sort((a, b) => (a.position - b.position) * (isAscending ? 1 : -1));
  }

  void sortRA(bool isAscending) {
    usersStatistics.sort((a, b) {
      if (a.userRA == b.userRA) {
        return (a.position - b.position);
      } else {
        return (GeneralFunctionsBrain.formatRAFromStringToInt(a.userRA) -
                GeneralFunctionsBrain.formatRAFromStringToInt(b.userRA)) *
            (isAscending ? 1 : -1);
      }
    });
  }

  void sortNota(bool isAscending) {
    usersStatistics.sort((a, b) {
      if (a.mediaGeral == b.mediaGeral) {
        return (a.position - b.position);
      } else {
        return (a.mediaGeral - b.mediaGeral).toInt() * (!isAscending ? 1 : -1);
      }
    });
  }

  void onPositionPressed() {
    selectedSortType = SortType.position;
    isAscending = !isAscending;
    sortPosition(isAscending);
    notifyListeners();
  }

  void onRAPressed() {
    selectedSortType = SortType.RA;
    isAscending = !isAscending;
    sortRA(isAscending);
    notifyListeners();
  }

  void onNotaPressed() {
    selectedSortType = SortType.nota;
    isAscending = !isAscending;
    sortNota(isAscending);
    notifyListeners();
  }

  String sortArrow(SortType sortType) =>
      (selectedSortType == sortType ? (isAscending ? '↓' : '↑') : '');
}
