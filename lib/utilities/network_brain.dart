import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

class NetworkBrain extends ChangeNotifier {
  final _firestore = Firestore.instance;

  InfoMauaNet lastDownloadedInfoMauaNet;
  List<String> lastDownloadedMateriasCursadas;

  String usuarioRA;
  String senhaUsuario;

  DateTime lastDownloadMauaNetTime;
  DateTime lastDownloadMateriasCursadasTime;

  RefreshController mauaNetRefreshController = RefreshController(
    initialRefresh: false,
  );

  bool notasDownloadError = false;

  int _downloadPlanoDeEnsinoMauaNetRepetitions =
      0; // Impede que o pedido http das informações do MauaNet continue após o usuário apertar o botão de cancelar tal processo.
  void cancelDownloadInfoMauaNet() {
    _downloadPlanoDeEnsinoMauaNetRepetitions++;
    notifyListeners();
  }

  int _downloadMateriasCursadasRepetitions =
      0; // Impede que o pedido http das informações do MauaNet continue após o usuário apertar o botão de cancelar tal processo.
  void cancelMateriasCursadas() {
    _downloadMateriasCursadasRepetitions++;
    notifyListeners();
  }

  Future<InfoMauaNet> downloadInfoMauaNet() async {
    final int _id = _downloadPlanoDeEnsinoMauaNetRepetitions;

//    print(usuarioRA);
//    print(senhaUsuario);

    Random random = Random();

    final int seed = random.nextInt(100000);

    http.Response response = await http.get(
        'https://us-central1-estudamaua-ea6ad.cloudfunctions.net/ssr?RA=$usuarioRA&SENHA=$senhaUsuario&t=$seed');

    if (_id == _downloadPlanoDeEnsinoMauaNetRepetitions) {
      if (response.statusCode == 200) {
        String data = response.body;

        Map<String, dynamic> decodedData;

        decodedData = await json.decode(data);

        lastDownloadedInfoMauaNet = InfoMauaNet(
          planoDeEnsino: decodedData['notas'],
          infoUsuario: decodedData['informacoes'],
        );

        _downloadPlanoDeEnsinoMauaNetRepetitions++;
        notasDownloadError = false;
        lastDownloadMauaNetTime = DateTime.now();
      } else {
        notasDownloadError = true;
        throw 'ERRO em downloadPlanoDeEnsinoMauaNet: ${response.statusCode}: dados não puderam ser obtidos.';
      }
    }
    notifyListeners();
    return lastDownloadedInfoMauaNet;
  }

  Future<List<String>> downloadMateriasCursadas() async {
    final int _id = _downloadMateriasCursadasRepetitions;

    Random random = Random();

    final int seed = random.nextInt(100000);

    http.Response response = await http.get(
        'https://us-central1-estudamaua-ea6ad.cloudfunctions.net/materiasCursadas?RA=$usuarioRA&SENHA=$senhaUsuario&t=$seed');

    if (_id == _downloadMateriasCursadasRepetitions) {
      if (response.statusCode == 200) {
        String data = response.body;

        lastDownloadedMateriasCursadas =
            List<String>.from(await json.decode(data));

        print(lastDownloadedMateriasCursadas);

        _downloadMateriasCursadasRepetitions++;
        notasDownloadError = false;
        lastDownloadMateriasCursadasTime = DateTime.now();
      } else {
        notasDownloadError = true;
        throw 'ERRO em downloadMateriasCursadas: ${response.statusCode}: dados não puderam ser obtidos.';
      }
    }
    notifyListeners();
    return lastDownloadedMateriasCursadas;
  }

  Future<void> assignMonitorToMonitoriaChat() async {
    QuerySnapshot usuarios =
        await _firestore.collection('dados_usuarios').getDocuments();

    Map<String, List<Map<String, dynamic>>> monitoresBasedOnMonitoria = {};

    for (DocumentSnapshot usuario in usuarios.documents) {
      List<String> monitoriaStrings =
          List<String>.from(usuario.data['monitoria'].keys);

      if (monitoriaStrings.length != 0) {
        for (String monitoria in monitoriaStrings) {
          try {
            monitoresBasedOnMonitoria[monitoria].add(
                {'RA': usuario.documentID, 'numero': usuario.data['numero']});
          } catch (e) {
            monitoresBasedOnMonitoria[monitoria] = [
              {'RA': usuario.documentID, 'numero': usuario.data['numero']}
            ];
          }
        }
      }
    }

    QuerySnapshot monitoriasFirebase =
        await _firestore.collection('dados_monitoria_online').getDocuments();

    List<String> monitoriasDocumentIdsInFirebase = [];

    for (DocumentSnapshot monitoria in monitoriasFirebase.documents) {
      monitoriasDocumentIdsInFirebase.add(monitoria.documentID.toString());
    }

    for (String monitoria in monitoresBasedOnMonitoria.keys) {
      await _firestore
          .collection('dados_monitoria_online')
          .document(monitoria)
          .setData({
        'monitores': monitoresBasedOnMonitoria[monitoria],
      });

      if (monitoriasDocumentIdsInFirebase.contains(monitoria))
        monitoriasDocumentIdsInFirebase.remove(monitoria);
    }

    // Para todas as matérias em que não existem mais monitores, apagar lista de monitores:
    for (String monitoria in monitoriasDocumentIdsInFirebase) {
      await _firestore
          .collection('dados_monitoria_online')
          .document(monitoria)
          .setData({
        'monitores': null,
      });
    }
  }

  Future<void> sendPlanoDeEnsinoDebugReport(
      String nomeCurso, String userRA) async {
    DateTime time = DateTime.now();

    String timeString = GeneralFunctionsBrain.getFormattedTime(
            fromDateTime: time, forceFullDate: true) +
        ' - ' +
        GeneralFunctionsBrain.getFormattedTime(
            fromDateTime: time, forceHoursMinutesAndSeconds: true);

    timeString = timeString.replaceAll('/', '-');

    DocumentReference reference = _firestore
        .collection('plano_de_ensino_debug_reports')
        .document('debug')
        .collection(nomeCurso)
        .document(timeString);

    await reference.setData({'usuario': userRA});
  }

  Future<void> copyCollectionDirectory() async {
    CollectionReference oldReference = _firestore
        .collection('dados_compartilhados')
        .document('medias')
        .collection('plano_de_ensino');

    CollectionReference newReference = _firestore.collection('plano_de_ensino');

    QuerySnapshot planoDeEnsinoCollection = await newReference.getDocuments();

    for (DocumentSnapshot documentSnapshot
        in planoDeEnsinoCollection.documents) {
      newReference
          .document(documentSnapshot.documentID)
          .updateData({'verificado_manualmente': true});
    }
    print('copyCollectionDirectory: Done!');
  }

  void signOut() {
    lastDownloadMauaNetTime = null;
    notifyListeners();
  }
}
