import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ----- User profile card dimensions and attributes: -----
const double kProfileCardHeight = 100.0;
const Color kProfileBackgroundColor = Color(0xFF01579B);
const double kTextPaddingSize = 15.0;
const double kImagePaddingSize = 15.0;

const TextStyle kUserCourseTextStyle = TextStyle(
  fontSize: 11.0,
  color: Colors.white,
);
const int kUserNameMaxLines = 2;
const int kUserCourseMaxLines = 1;
const double kUserPictureRadius = 25.0;
const double kUserPicturePadding = 15.0;

// ----- General card dimensions and attributes: -----
const double kCardBorderRadius = 15.0;
const BoxShadow kBoxShadowAttributes = BoxShadow(
  color: Colors.grey,
  spreadRadius: 2.0,
  offset: Offset(-0.707, 0.707),
  blurRadius: 4.0,
);

// ----- Course card specific dimensions and attributes: -----
const Color kCourseCardBackgroundColor = Colors.white;
const double kCardTextVerticalSpace = 55.0;
const double kCardVerticalSpace = 130.0;
const double kStarIconSize = 27.0;
const double kOuterStarHorizontalPaddingSize = 6.0;
const double kInnerStarHorizontalPaddingSize = 3.0;
const Color kActiveStarColor = Color(0xFFFBC02D);
const Color kInactiveStarColor = Colors.grey;
const double kCourseTextSize = 18.0;
const Color kCourseTextColor = Color(0xFF494949);
const int kMaxNumberOfCardTextLines = 2;
const Color kActiveCheckColor = Color(0xFFFBC02D);
const Color kInactiveCheckColor = Colors.grey;

// ----- Imageless card specific dimensions and attributes: -----
const Color kImagelessBackgroundColor = Color(0xFF1565C0);
const Color kImagelessTextColor = Colors.white;
const double kImagelessHeight = 50.0;
const double kImagelessTextSize = 16.0;
const double kImagelessTopMarginSize = 10.0;
const Decoration kImagelessDecoration = BoxDecoration(
  color: kImagelessBackgroundColor,
  borderRadius: BorderRadius.all(Radius.circular(kCardBorderRadius)),
  boxShadow: [kBoxShadowAttributes],
);

// ----- Input box dimensions and attributes: -----
const InputDecoration kInputDecoration = InputDecoration(
  hintText: 'Insira o valor',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF0D47A1), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF0D47A1), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

// ----- Rounded button specific dimensions and attributes: -----
const double kRoundedButtonHeight = 42.0;
const Color kRoundedButtonBackgroundColor = Color(0xFF0D47A1);
const Color kRoundedButtonTextColor = Colors.white;
const int kRoundedButtonMaxTextLines = 1;

// ----- Logo attributes: -----
const Color kLogoColor = Color(0xFF0D47A1);

// ----- Main navigation screen attributes: -----
enum MainScreens {
  Moodle,
  Medias,
  Monitoria,
  Settings,
}

// ----- Bottom navigation bar attributes: -----
const Color kActiveTabColor = Color(0xFF0D47A1);
const Color kInactiveTabColor = Color(0xFF757575);

// ----- MédiasScreen: -----
enum TiposDeCalculoMedia {
  parcial,
  final_,
}

class AvaliacaoPath {
  AvaliacaoPath({this.tipo, this.semestre, this.avaliacao});

  kTipoAvaliacao tipo;
  String semestre;
  String avaliacao;
}

class ChatCardInfo {
  ChatCardInfo({
    this.monitorias,
    this.userRA,
    this.userUid,
    this.userName,
    this.lastMessageData,
    this.unreadMessages,
    this.lastMessageSenderIsMe,
    this.userDescription,
    this.userImage,
    this.monitorType = MonitorType.aguardandoOficializacao,
  });

  String userName;
  String userRA;
  dynamic userUid;
  String userDescription;
  ImageProvider userImage;
  List<dynamic> monitorias;
  MessageData lastMessageData;
  int unreadMessages;
  bool lastMessageSenderIsMe;
  MonitorType monitorType;

  String get lastMessageText {
    if (lastMessageData != null) {
      return lastMessageData.text;
    }
    return null;
  }

  String get lastMessageTimeUnparsed {
    if (lastMessageData != null) {
      return lastMessageData.time;
    }
    return null;
  }

  bool get lastMessageRead {
    if (lastMessageData != null) {
      return lastMessageData.read;
    }
    return null;
  }

  bool get doesLastMessageHavePhoto {
    if (lastMessageData != null) {
      return lastMessageData.photo != null;
    }
    return null;
  }

  int get lastMessageTimeInMilliseconds {
    if (lastMessageData != null) {
      if (lastMessageData.time != null) {
        return DateTime.parse(lastMessageData.time).millisecondsSinceEpoch;
      }
    }
    return null;
  }

  String get formattedTime {
    if (lastMessageData != null) {
      return GeneralFunctionsBrain.getFormattedTime(
          fromIso8601String: lastMessageData.time);
    }
    return null;
  }
}

class MonitoriaCardInfo {
  MonitoriaCardInfo({this.monitoria, this.monitorCardInfoList = const []});

  String monitoria;
  List<ChatCardInfo> monitorCardInfoList;

  bool get isEmpty => monitorCardInfoList.length == 0;
}

class MonitoriaChatWithStream {
  MonitoriaChatWithStream({this.contatoRA, this.monitoriaDataStream});

  Stream<QuerySnapshot> monitoriaDataStream;
  String contatoRA;
}

class MessageData {
  MessageData({
    this.text,
    this.photo,
    this.senderRA,
    this.senderName,
    this.receiver,
    this.read,
    this.time,
  });

  String text;
  String senderRA;
  String senderName;
  String receiver;
  bool read;
  String time;
  String photo;

  bool get hasPhoto => photo != null;

  int get timeInMilliseconds {
    if (time != null) {
      return DateTime.parse(time).millisecondsSinceEpoch;
    }
    return null;
  }

  String get formattedTime {
    if (time != null) {
      return GeneralFunctionsBrain.getFormattedTime(fromIso8601String: time);
    }
    return null;
  }
}

class InfoMauaNet {
  InfoMauaNet({this.planoDeEnsino, this.infoUsuario});

  Map<String, dynamic> planoDeEnsino;
  Map<String, dynamic> infoUsuario;
}

enum EstatisticasType {
  ranking,
  graficos,
}

class InfoGraphBar {
  InfoGraphBar({
    @required this.nota,
    this.quantidadeDeAlunos,
    this.notaIsMine,
  });

  double nota;
  int quantidadeDeAlunos;
  bool notaIsMine;

  charts.Color get getBarColor => notaIsMine ?? false
      ? charts.ColorUtil.fromDartColor(Colors.red[400])
      : charts.ColorUtil.fromDartColor(Colors.red[700]);

  String get getBarName => nota >= 0.0 ? nota.toString() : 'NC';
}

class UserStatisticsInfo {
  UserStatisticsInfo({
    this.position,
    this.mediaGeral,
    this.userRA,
  });

  int position;
  double mediaGeral;
  String userRA;
}

enum SortType {
  position,
  RA,
  nota,
}

class AvaliacaoData {
  AvaliacaoData({
    this.nota,
    this.descricao,
    this.peso,
    this.substituicao,
    this.isNotaMovelMinimoEsforco = false,
    this.substituiAvaliacoes,
    this.nomeSubstitutiva,
    this.isAvaliacaoInFirebase = true,
  });

  double nota;
  double peso;
  String descricao;
  String
      nomeSubstitutiva; // Se a avaliacao é uma prova, este é o nome da substitutiva que substitui sua nota.
  List<dynamic> substituiAvaliacoes;
  double
      substituicao; // caso a prova P1 seja substituida pela substitutiva PS1, aqui aparecerá a nota da PS1.
  bool isNotaMovelMinimoEsforco; // utilizado no MinimoEsforco.
  bool isAvaliacaoInFirebase;
}

class DisciplinaData {
  DisciplinaData({
    this.pesosGerais,
    this.avaliacoes,
  });

  Map<kTipoAvaliacao, double> pesosGerais;
  Map<kTipoAvaliacao, Map<String, AvaliacaoData>> avaliacoes;
}

enum kTipoAvaliacao {
  provas,
  trabalhos,
  substitutivas,
  semClassificacao,
}

enum PlanoDeEnsinoScreen {
  pdf,
  editor,
}

enum QuantidadeDeProvas {
  zero,
  umSemestre,
  doisSemestres,
}

enum PlanoDeEnsinoState {
  verificado,
  naoVerificado,
  vazio,
}

enum EditorType {
  provas,
  trabalhos,
  pesosGerais,
}

enum MonitorType {
  oficial,
  extraOficial,
  aguardandoOficializacao,
}

class MonitoriaData {
  MonitoriaData({this.type = MonitorType.extraOficial, this.name});

  MonitorType type;
  String name;
}
