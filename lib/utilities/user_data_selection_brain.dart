import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/cupertino.dart';

class UserDataSelectionBrain extends ChangeNotifier {
  int quantidadeMonitorias;
  List<MonitoriaData> monitoriasSelected = [];

  bool escolhaDivulgacaoNotas;

  bool escolhaRegistroTelefone;
  String telefone;
  TextEditingController telefoneEditingController;

  String userConfirmationCode;
  String realConfirmationCode;

  List<String> materiasCursadasEmAnosAnteriores;

  void getMateriasCursadasEmAnosAnteriores({
    List<String> allMaterias,
    List<String> materiasUltimoAno,
  }) {
    List<String> materiasAnosAnteriores = List.from(allMaterias);

    for (String materia in materiasUltimoAno) {
      materiasAnosAnteriores.remove(materia);
      print(materia);
      print(materiasAnosAnteriores);
    }

    materiasCursadasEmAnosAnteriores = materiasAnosAnteriores;
    notifyListeners();
  }

  bool get isTelefoneReady {
    String pureNumbers = (telefone ?? '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '')
        .replaceAll(' ', '');

    if (pureNumbers.length != 11) return false;

    for (int index = 0; index < pureNumbers.length; index++) {
      if (!['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
          .contains(pureNumbers.substring(index, index + 1))) {
        print('oi');
        return false;
      }
    }

    return true;
  }

  void reset() {
    quantidadeMonitorias = null;
    telefoneEditingController = TextEditingController(text: '(11) 97606-2566');
    escolhaDivulgacaoNotas = null;
    monitoriasSelected = [];
    telefone = '(11) 97606-2566';
    escolhaDivulgacaoNotas = null;
    escolhaRegistroTelefone = null;
    userConfirmationCode = null;
    notifyListeners();
  }

  bool get isSelectedMonitoriasReady {
    for (MonitoriaData monitoriaData in monitoriasSelected) {
      if (monitoriaData.name == null) {
        return false;
      }
    }
    return true;
  }
}
