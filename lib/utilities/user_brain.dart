import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'curso_brain.dart';

class UserBrain extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;
  String userInstitution = 'Instituto Mauá de Tecnologia (SCS)';

  bool cadastroMode;

  String _usuarioRA;
  dynamic uid;

  Map<String, dynamic> _dadosUsuario;

  Future<void> setUser({String userRA}) async {
    if (userRA == null) {
      try {
        final user = await _auth.currentUser();
        if (user != null) {
          loggedInUser = user;
          uid = user.uid;
          _usuarioRA = user.email.split('@')[0];
        }
      } catch (e) {
        print('ERRO (getCurrentUser): $e');
      }
    } else {
      _usuarioRA = userRA;
    }
    await getDadosUsuario();
  }

  String get getUserMauaNetFirstName =>
      userInfoMauaNet['Nome'].toString().split(' ')[0];

  dynamic userInfoMauaNet;
  dynamic userPlanoDeEnsinoMauaNet;

  Future<void> setNotasForRandomUsers() async {
    final randomGenerator = math.Random();

    List<String> usersCreated = [];

    for (int number = 1; number < 30; number++) {
      int randomIndex =
          randomGenerator.nextInt(List.from(CursoBrain().courses()).length);

      String randomRA =
          '19.0${randomGenerator.nextInt(10)}${randomGenerator.nextInt(10)}${randomGenerator.nextInt(10)}${randomGenerator.nextInt(10)}-${randomGenerator.nextInt(10)}';

      print(randomRA);

      List<String> monitoria = List.from(CursoBrain().courses());

      DocumentReference userDataRef =
          _firestore.collection('dados_usuarios').document(randomRA);

      await userDataRef.setData({
        'nome': randomRA,
        'curso': 'Engenharia',
        'periodo': 'Noturno',
        'serie': '2a.',
        'monitoria': [monitoria[randomIndex]],
      });

      usersCreated.add(randomRA);
      try {} catch (e) {
        print(e);
      }
    }

    DocumentReference myDataRef =
        _firestore.collection('dados_usuarios').document(_usuarioRA);

    await myDataRef.updateData({
      'contatos': ['19.01343-4'] + usersCreated
    });
  }

  Future<void> createRandomUsers() async {
    final randomGenerator = math.Random();

    List<String> monitorias = [];

    QuerySnapshot monitoriasFirebase =
        await _firestore.collection('dados_monitoria_online').getDocuments();

    for (DocumentSnapshot documentSnapshot in monitoriasFirebase.documents) {
      monitorias.add(documentSnapshot.documentID);
    }

    for (int number = 1; number < 45; number++) {
      int randomIndex = randomGenerator.nextInt(monitorias.length);

      String randomRA =
          '19.0${randomGenerator.nextInt(10)}${randomGenerator.nextInt(10)}${randomGenerator.nextInt(10)}${randomGenerator.nextInt(10)}-${randomGenerator.nextInt(10)}';

      print(randomRA);

      DocumentReference userDataRef =
          _firestore.collection('dados_usuarios').document(randomRA);

      await userDataRef.setData({
        'nome': 'Cleber da Silva $number',
        'curso': 'Engenharia',
        'periodo': 'Noturno',
        'serie': '2a.',
        'monitoria': {
          monitorias[randomIndex]: {
            'tipo': GeneralFunctionsBrain.convertMonitorTypeToString([
              MonitorType.oficial,
              MonitorType.extraOficial,
              MonitorType.aguardandoOficializacao
            ][randomGenerator.nextInt(3) % 3])
          }
        },
      });
    }
  }

  Future<void> uploadInfoUsuarioFirebase({
    List<MonitoriaData> monitorias,
    bool escolhaDivulgacaoNotas,
    String numeroDeTelefone,
  }) async {
    // Envia as informações do usuário para o Firebase.

    try {
      final user = await _auth.currentUser();

      if (user != null) {
        loggedInUser = user;
        _usuarioRA = user.email.split('@')[0];
      }

      Map<String, Map<String, dynamic>> monitoriasMap = {};

      for (MonitoriaData monitoria in monitorias) {
        monitoriasMap[monitoria.name] = {
          'tipo':
              GeneralFunctionsBrain.convertMonitorTypeToString(monitoria.type)
        };
      }

      print(monitoriasMap);

      DocumentReference userDataRef =
          _firestore.collection('dados_usuarios').document(_usuarioRA);

      if (!escolhaDivulgacaoNotas) {
        DocumentReference notasRef =
            _firestore.collection('dados_notas').document(_usuarioRA);
        notasRef.delete();
      }

      await userDataRef.setData({
        'nome': userInfoMauaNet['Nome'],
        'curso': userInfoMauaNet['Curso'],
        'periodo': userInfoMauaNet['Periodo'],
        'serie': userInfoMauaNet['Serie'],
        'monitoria': monitoriasMap,
        'numero': numeroDeTelefone,
        'permite_divulgacao_notas': escolhaDivulgacaoNotas,
        'uid': user.uid,
        'disciplinas': List.of(userPlanoDeEnsinoMauaNet.keys),
      });
    } catch (e) {
      print('ERRO (uploadInfoUsuarioFirebase): $e');
    }
  }

  Future<void> getDadosUsuario() async {
    try {
      final dados = await _firestore
          .collection('dados_usuarios')
          .document(_usuarioRA)
          .get();
      _dadosUsuario = dados.data;
    } catch (e) {
      _dadosUsuario = {
        'nome': null,
        'curso': null,
        'periodo': null,
        'serie': null,
        'monitoria': null,
        'numero': null,
      };
      print(e);
    }
  }

  String getUserRA() => _usuarioRA;

  String getUserName() {
    try {
      return _dadosUsuario['nome'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  String getUserNumber() {
    try {
      return _dadosUsuario['numero'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  ImageProvider getUserImage() {
    try {
      return NetworkImage(
          'https://www2.maua.br/fotos/aluno/ra/${GeneralFunctionsBrain.formatRAFromStringToInt(_usuarioRA)}');
    } catch (e) {
      print(e);
      return GeneralFunctionsBrain.userNullPhoto;
    }
  }

  String getUserCourse() {
    try {
      return _dadosUsuario['curso'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<dynamic> getUserContatos() {
    try {
      return _dadosUsuario['contatos'];
    } catch (e) {
      print(e);
      return [];
    }
  }

  String getUserPeriod() {
    try {
      return _dadosUsuario['periodo'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  String getUserSerie() {
    try {
      return _dadosUsuario['serie'] + ' Série';
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<dynamic> getUserMonitorias() {
    try {
      return List<String>.from(_dadosUsuario['monitoria'].keys).length == 0
          ? null
          : List<String>.from(_dadosUsuario['monitoria'].keys);
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<String> getUserDisciplinas() {
    try {
      return List<String>.from(_dadosUsuario['disciplinas']);
    } catch (e) {
      print('ERRO em getUserDisciplinas: $e');
      return null;
    }
  }

  String getFormattedCourseInfo() =>
      '${getUserCourse() ?? 'null'}: ${getUserSerie() ?? 'null'} (${getUserPeriod() ?? 'null'})';

  String getFormattedUserDescription() {
    return getFormattedCourseInfo();
  }

  bool getUserWillingnessToShareNotas() {
    try {
      return _dadosUsuario['permite_divulgacao_notas'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  dynamic getUserUid() {
    try {
      return _dadosUsuario['uid'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  dynamic getUserMonitoriaFullMap() {
    try {
      return _dadosUsuario['monitoria'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  dynamic getIsUserProfessor() {
    try {
      return _dadosUsuario['professor'] ?? false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void signOut() {
    _auth.signOut();
    _dadosUsuario = null;
  }
}
