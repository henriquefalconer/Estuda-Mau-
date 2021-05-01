import 'dart:math';
import 'dart:typed_data';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

import 'constants.dart';

class GeneralFunctionsBrain {
  static String cutStringToLength({int maxLength, String string}) {
    return string.length > maxLength
        ? string.substring(0, maxLength) + '...'
        : string;
  }

  static double convertMauaNetNotaToDouble(String mauaNetNota) {
    String notaString = mauaNetNota.replaceAll(',', '.');

    notaString = notaString == '-' ? '-1.0' : notaString;
    notaString = notaString == 'NC' || notaString == 'NE' ? '-0.5' : notaString;

    return double.parse(notaString);
  }

  static get userNullPhoto => AssetImage('images/null_user_photo.png');

  static String getCurrentTime() => DateTime.now().toIso8601String();

  static DateTime getDayStartingHourFromString(String time) {
    return DateTime.parse(time.split('T')[0] + 'T00:00:00.000000');
  }

  static DateTime getMonthStartingHourFromString(String time) {
    return DateTime.parse(
        time.substring(0, time.lastIndexOf('-')) + '-01T00:00:00.000000');
  }

  static DateTime getDayStartingHourFromDateTime(DateTime time) {
    return DateTime.parse(
        time.toIso8601String().split('T')[0] + 'T00:00:00.000000');
  }

  static String getFormattedTime({
    DateTime fromDateTime,
    String fromIso8601String,
    bool forceHoursAndMinutes = false,
    bool forceDayOfTheWeekOrFullDate = false,
    bool forceFullDate = false,
    bool forceHoursMinutesAndSeconds = false,
  }) {
    DateTime dateTime;

    if (fromDateTime != null && fromIso8601String == null) {
      dateTime = fromDateTime;
    } else if (fromDateTime == null && fromIso8601String != null) {
      dateTime = DateTime.parse(fromIso8601String);
    } else {
      throw 'fromDateTime amd fromIso8601String parameters cannot be not null at same time';
    }

    if ((dateTime.day == DateTime.now().day || forceHoursAndMinutes) &&
        !forceDayOfTheWeekOrFullDate &&
        !forceFullDate &&
        !forceHoursMinutesAndSeconds) {
      return '${dateTime.hour}:'.padLeft(3, '0') +
          '${dateTime.minute}'.padLeft(2, '0');
    } else if (getDayStartingHourFromDateTime(
                DateTime.now().subtract(Duration(days: 1)))
            .isBefore(dateTime) &&
        !forceFullDate &&
        !forceHoursMinutesAndSeconds) {
      return getDayStartingHourFromDateTime(DateTime.now()).isAfter(dateTime)
          ? 'Ontem'
          : 'Hoje';
    } else if (getDayStartingHourFromDateTime(
                DateTime.now().subtract(Duration(days: 6)))
            .isBefore(dateTime) &&
        !forceFullDate &&
        !forceHoursMinutesAndSeconds) {
      return {
        1: 'Segunda-feira',
        2: 'Terça-feira',
        3: 'Quarta-feira',
        4: 'Quinta-feira',
        5: 'Sexta-feira',
        6: 'Sábado',
        7: 'Domingo',
      }[dateTime.weekday];
    } else if (!forceHoursMinutesAndSeconds) {
      return '${dateTime.day}/'.padLeft(3, '0') +
          '${dateTime.month}/'.padLeft(3, '0') +
          '${dateTime.year}'.padLeft(4, '0');
    } else {
      return '${dateTime.hour}:'.padLeft(3, '0') +
          '${dateTime.minute}:'.padLeft(3, '0') +
          '${dateTime.second}'.padLeft(2, '0');
    }
  }

  static int formatRAFromStringToInt(String userRA) =>
      int.parse(userRA.replaceAll('-', '').replaceAll('.', ''));

  static String formatMediaToText(double media,
          {int roundToDecimalPlace = 1}) =>
      media == null
          ? '---'
          : '${(media * pow(10, roundToDecimalPlace)).round() / pow(10, roundToDecimalPlace)}'
              .replaceAll('.', ',');

  static double roundNumber(double number, [int roundToDecimalPlace = 1]) =>
      number == null
          ? null
          : (number * pow(10, roundToDecimalPlace)).round() /
              pow(10, roundToDecimalPlace);

  static void openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

//  static Future<List<Asset>> getImageFromGallery() async {
//    return await MultiImagePicker.pickImages(maxImages: 50, enableCamera: true);
//  }
//
//  static Future<void> saveMediaToUserDevice(String mediaPath) async {
//    if (mediaPath != null) {
//      final String path =
//          mediaPath.split('gs://estudamaua-ea6ad.appspot.com/').last;
//      final StorageReference ref = FirebaseStorage.instance.ref().child(path);
//      String mediaUrl = (await ref.getDownloadURL()).toString();
//      var response = await Dio()
//          .get(mediaUrl, options: Options(responseType: ResponseType.bytes));
//      final result =
//          await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
////      print(result);
//    }
//  }

  static kTipoAvaliacao convertStringToTipoAvaliacao(String tipo) => {
        'provas': kTipoAvaliacao.provas,
        'trabalhos': kTipoAvaliacao.trabalhos,
        'substitutivas': kTipoAvaliacao.substitutivas,
        null: kTipoAvaliacao.semClassificacao,
      }[tipo];

  static String convertTipoAvaliacaoToString(kTipoAvaliacao tipoAvaliacao) => {
        kTipoAvaliacao.provas: 'provas',
        kTipoAvaliacao.trabalhos: 'trabalhos',
        kTipoAvaliacao.substitutivas: 'substitutivas',
        null: null,
      }[tipoAvaliacao];

  static String convertListToStringOfList(List list) {
    String result = '';
    List listCopy = List.from(list);
    listCopy.sort();
    String lastElement = listCopy.removeLast();
    for (String element in listCopy) {
      result = result + element + ', ';
    }
    return result.substring(0, result.lastIndexOf(',')) + ' e ' + lastElement;
  }

  static Map<String, dynamic> convertDisciplinaDataToMap(
      DisciplinaData disciplinaData) {
    Map<String, dynamic> finalMap = {
      'verificado_manualmente': false,
      'avaliacoes': {},
      'pesos_gerais': {
        'provas': disciplinaData.pesosGerais[kTipoAvaliacao.provas],
        'trabalhos': disciplinaData.pesosGerais[kTipoAvaliacao.trabalhos]
      }
    };

    for (kTipoAvaliacao tipoAvaliacao in [
      kTipoAvaliacao.trabalhos,
      kTipoAvaliacao.provas,
      kTipoAvaliacao.substitutivas,
    ]) {
      for (String avaliacao in disciplinaData.avaliacoes[tipoAvaliacao].keys) {
        finalMap['avaliacoes'][avaliacao] = {
          'peso': disciplinaData.avaliacoes[tipoAvaliacao][avaliacao].peso,
          'descricao': null,
          'substitui_avaliacoes': disciplinaData
              .avaliacoes[tipoAvaliacao][avaliacao].substituiAvaliacoes,
          'tipo': convertTipoAvaliacaoToString(tipoAvaliacao),
        };
      }
    }

    return finalMap;
  }

  static DisciplinaData convertPlanoDeEnsinoFirebaseToDisciplinaData(
      Map<String, dynamic> planoDeEnsinoFirebase) {
//    print('firebase: $planoDeEnsinoFirebase');
    DisciplinaData disciplinaData = DisciplinaData(
      avaliacoes: {
        kTipoAvaliacao.trabalhos: {},
        kTipoAvaliacao.provas: {},
        kTipoAvaliacao.substitutivas: {},
      },
      pesosGerais: {
        kTipoAvaliacao.trabalhos: null,
        kTipoAvaliacao.provas: null,
      },
    );

    if (planoDeEnsinoFirebase['pesos_gerais'] != null) {
      for (String tipo in planoDeEnsinoFirebase['pesos_gerais'].keys) {
        disciplinaData.pesosGerais[convertStringToTipoAvaliacao(tipo)] =
            planoDeEnsinoFirebase['pesos_gerais'][tipo];
      }
    }

    for (String avaliacao in planoDeEnsinoFirebase['avaliacoes'].keys) {
      disciplinaData.avaliacoes[convertStringToTipoAvaliacao(
              planoDeEnsinoFirebase['avaliacoes'][avaliacao]['tipo'])]
          [avaliacao] = AvaliacaoData(
        peso: planoDeEnsinoFirebase['avaliacoes'][avaliacao]['peso'],
        substituiAvaliacoes: planoDeEnsinoFirebase['avaliacoes'][avaliacao]
            ['substitui_avaliacoes'],
      );
//      print(
//          '$avaliacao: ${planoDeEnsinoFirebase['avaliacoes'][avaliacao]['peso']}');
    }

    return disciplinaData;
  }

  static String formatTextFieldTextFromText(String text) {
    if (text == null) {
      return '0,00';
    }

    String pureText = text.replaceAll(',', '');

    for (int index = 0; index < pureText.length; index++) {
      if (pureText.substring(0, 1) == '0') {
        pureText = pureText.substring(1);
      }
    }

    while (pureText.length < 3) {
      pureText = '0' + pureText;
    }

    return pureText.substring(0, pureText.length - 2) +
        ',' +
        pureText.substring(pureText.length - 2, pureText.length);
  }

  static String formatTextFieldTextFromDouble(double number) {
    String text = number.toString().replaceAll('.', ',');

    while (text.split(',').last.length < 2) {
      text = text + '0';
    }

    while (text.split(',').last.length > 2) {
      text = text.substring(0, text.length - 1);
    }

    return formatTextFieldTextFromText(text);
  }

  static kTipoAvaliacao getTipoAvaliacaoFromAvaliacaoName(String avaliacao) {
    if (avaliacao.substring(0, 1) == 'T')
      return kTipoAvaliacao.trabalhos;
    else if (avaliacao.startsWith('PS'))
      return kTipoAvaliacao.substitutivas;
    else if (avaliacao.startsWith('P'))
      return kTipoAvaliacao.provas;
    else
      return kTipoAvaliacao.semClassificacao;
  }

  static List<String> getSubstituiAvaliacoesFromSubstitutivaName(
          String substitutiva) =>
      {
        'PS1': ['P1', 'P2'],
        'PS2': ['P3', 'P4'],
      }[substitutiva];

  static bool isMauaNetNotasCursoWith16Trabalhos4ProvasAnd2Substitutivas(
      Map<String, dynamic> notasCurso) {
    List<String> avaliacoes = [];

    for (int i = 1; i <= 4; i++) {
      avaliacoes.add('P$i');
    }
    for (int i = 1; i <= 2; i++) {
      avaliacoes.add('PS$i');
    }
    for (int i = 1; i <= 16; i++) {
      avaliacoes.add('T$i');
    }

    for (String avaliacao in avaliacoes) {
      if (!notasCurso.keys.contains(avaliacao)) {
        return false;
      }
    }
    return true;
  }

  static int getQuantidadeDeTrabalhosFromDisciplinaData(
      DisciplinaData disciplinaData) {
    List<String> trabalhos =
        List.from(disciplinaData.avaliacoes[kTipoAvaliacao.trabalhos].keys);

    int maxInt = 0;
    for (String trabalho in trabalhos) {
      try {
        if (int.parse(trabalho.substring(1)) > maxInt) {
          maxInt = int.parse(trabalho.substring(1));
        }
      } catch (e) {
        print('ERRO em getQuantidadeDeTrabalhosFromListTrabalhos: $e');
      }
    }
    return maxInt;
  }

  static QuantidadeDeProvas getQuantidadeDeProvasFromDisciplinaData(
      DisciplinaData disciplinaData) {
    Map<String, dynamic> provasDisciplina =
        disciplinaData.avaliacoes[kTipoAvaliacao.provas];
    Map<String, dynamic> substitutivasDisciplina =
        disciplinaData.avaliacoes[kTipoAvaliacao.substitutivas];

    if (provasDisciplina.containsKey('P1') &&
        provasDisciplina.containsKey('P2') &&
        substitutivasDisciplina.containsKey('PS1')) {
      if (provasDisciplina.containsKey('P3') &&
          provasDisciplina.containsKey('P4') &&
          substitutivasDisciplina.containsKey('PS2')) {
        return QuantidadeDeProvas.doisSemestres;
      } else {
        return QuantidadeDeProvas.umSemestre;
      }
    } else {
      return QuantidadeDeProvas.zero;
    }
  }

  static String getPlainPhoneNumberFromFormattedPhoneNumber(
          String phoneNumber) =>
      phoneNumber
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll('-', '')
          .replaceAll(' ', '');

  static String formatTelefonePlainText(text) {
    String pureNumbers = text
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '')
        .replaceAll(' ', '');

    String finalText = pureNumbers;

    if (finalText.length >= 5) {
      finalText = pureNumbers.substring(0, pureNumbers.length - 4) +
          '-' +
          pureNumbers.substring(pureNumbers.length - 4);

      if (finalText.length >= 11) {
        finalText = '(' +
            finalText.substring(0, pureNumbers.length - 9) +
            ') ' +
            finalText.substring(pureNumbers.length - 9);
      }
    }

    return finalText;
  }

  static List<ChatCardInfo> sortMonitorCardInfoList(
      List<ChatCardInfo> listChatCardInfo) {
    List<ChatCardInfo> list = List.from(listChatCardInfo);

    list.sort((a, b) => a.userName.compareTo(b.userName));
    list.sort((a, b) =>
        (a.monitorType == MonitorType.aguardandoOficializacao ? 0 : 1)
            .compareTo(
                b.monitorType == MonitorType.aguardandoOficializacao ? 0 : 1));
    list.sort((a, b) => (a.monitorType == MonitorType.oficial ? 0 : 1)
        .compareTo(b.monitorType == MonitorType.oficial ? 0 : 1));

    return list;
  }

  static String convertMonitorTypeToString(MonitorType monitorType) => {
        MonitorType.oficial: 'oficial',
        MonitorType.extraOficial: 'extra-oficial',
        MonitorType.aguardandoOficializacao: 'aguardando_oficializacao',
      }[monitorType];

  static MonitorType convertStringToMonitorType(String string) => {
        'oficial': MonitorType.oficial,
        'extra-oficial': MonitorType.extraOficial,
        'aguardando_oficializacao': MonitorType.aguardandoOficializacao,
      }[string];
}
