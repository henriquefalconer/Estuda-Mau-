import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:flutter/cupertino.dart';

import 'constants.dart';

class PlanoDeEnsinoBrain extends ChangeNotifier {
  String selectedCourse;

  Map<String, DisciplinaData> disciplinaDatas = {};

  Map<String, Map<kTipoAvaliacao, Map<String, TextEditingController>>>
      pesoAvaliacoesTextEditingControllers = {};
  Map<String, Map<String, TextEditingController>>
      pesosGeraisTextEditingControllers = {};

  Map<String, int> quantidadeTrabalhos = {};
  Map<String, QuantidadeDeProvas> provasExistentes = {};

  Map<String, Map<EditorType, Map<String, bool>>> isParsable = {};

  List<String> get getListaTrabalhos {
    List<String> trabalhos = [];
    if (quantidadeTrabalhos[selectedCourse] == null) return null;
    for (int i = 1; i <= quantidadeTrabalhos[selectedCourse]; i++) {
      trabalhos.add('T$i');
    }
    return trabalhos;
  }

  List<String> get getListaProvas => {
        QuantidadeDeProvas.zero: <String>[],
        QuantidadeDeProvas.umSemestre: ['P1', 'P2'],
        QuantidadeDeProvas.doisSemestres: ['P1', 'P2', 'P3', 'P4']
      }[provasExistentes[selectedCourse]];

  void onChangeTrabalhosDropdownButton(int quantidade) {
    quantidadeTrabalhos[selectedCourse] = quantidade;
    for (int i = 1; i <= quantidadeTrabalhos[selectedCourse]; i++) {
      if (!List.from(pesoAvaliacoesTextEditingControllers[selectedCourse]
                  [kTipoAvaliacao.trabalhos]
              .keys)
          .contains('T$i')) {
        pesoAvaliacoesTextEditingControllers[selectedCourse]
                [kTipoAvaliacao.trabalhos]['T$i'] =
            TextEditingController(text: '0,00');
      }

      if (!List.from(isParsable[selectedCourse][EditorType.trabalhos].keys)
          .contains('T$i')) {
        isParsable[selectedCourse][EditorType.trabalhos]['T$i'] = null;
      }

      if (!List.from(disciplinaDatas[selectedCourse]
              .avaliacoes[kTipoAvaliacao.trabalhos]
              .keys)
          .contains('T$i')) {
        disciplinaDatas[selectedCourse].avaliacoes[kTipoAvaliacao.trabalhos]
            ['T$i'] = AvaliacaoData(peso: 0.0);
      }
    }

    for (int i = quantidadeTrabalhos[selectedCourse] + 1; i <= 16; i++) {
      pesoAvaliacoesTextEditingControllers[selectedCourse]
              [kTipoAvaliacao.trabalhos]
          .remove('T$i');
      isParsable[selectedCourse].remove('T$i');
      disciplinaDatas[selectedCourse]
          .avaliacoes[kTipoAvaliacao.trabalhos]
          .remove('T$i');
    }

    if (quantidade == 0 &&
        List.from(pesosGeraisTextEditingControllers[selectedCourse].keys)
            .contains('Trabalho')) {
      pesosGeraisTextEditingControllers[selectedCourse]['Trabalho'] =
          TextEditingController(text: '0,00');
      disciplinaDatas[selectedCourse].pesosGerais[kTipoAvaliacao.trabalhos] =
          0.0;
    }

    if (!shouldEscolhaPesosGeraisAparecer) {
      disciplinaDatas[selectedCourse].pesosGerais = {
        kTipoAvaliacao.provas: null,
        kTipoAvaliacao.trabalhos: null,
      };
      pesosGeraisTextEditingControllers[selectedCourse] = {
        'Prova': TextEditingController(text: '0,00'),
        'Trabalho': TextEditingController(text: '0,00'),
      };
    }

    notifyListeners();
  }

  void onChangeProvasDropdownButton(QuantidadeDeProvas quantidadeDeProvas) {
    List<String> provasRestantes = ['P1', 'P2', 'P3', 'P4'];

    provasExistentes[selectedCourse] = quantidadeDeProvas;

    for (String prova in getListaProvas) {
      if (!List.from(pesoAvaliacoesTextEditingControllers[selectedCourse]
                  [kTipoAvaliacao.provas]
              .keys)
          .contains(prova)) {
        pesoAvaliacoesTextEditingControllers[selectedCourse]
                [kTipoAvaliacao.provas][prova] =
            TextEditingController(text: '0,00');
      }

      if (!List.from(isParsable[selectedCourse][EditorType.provas].keys)
          .contains(prova)) {
        isParsable[selectedCourse][EditorType.provas][prova] = null;
      }

      if (!(List.from(disciplinaDatas[selectedCourse]
              .avaliacoes[kTipoAvaliacao.provas]
              .keys)
          .contains(prova))) {
        disciplinaDatas[selectedCourse].avaliacoes[kTipoAvaliacao.provas]
            [prova] = AvaliacaoData(peso: 0.0);
      }
      provasRestantes.remove(prova);
    }

    if (quantidadeDeProvas == QuantidadeDeProvas.umSemestre ||
        quantidadeDeProvas == QuantidadeDeProvas.doisSemestres) {
      disciplinaDatas[selectedCourse].avaliacoes[kTipoAvaliacao.substitutivas]
          ['PS1'] = AvaliacaoData(substituiAvaliacoes: ['P1', 'P2']);
    }
    if (quantidadeDeProvas == QuantidadeDeProvas.doisSemestres) {
      disciplinaDatas[selectedCourse].avaliacoes[kTipoAvaliacao.substitutivas]
          ['PS2'] = AvaliacaoData(substituiAvaliacoes: ['P3', 'P4']);
    }

    for (String prova in provasRestantes) {
      pesoAvaliacoesTextEditingControllers[selectedCourse]
              [kTipoAvaliacao.provas]
          .remove(prova);
      isParsable[selectedCourse][EditorType.provas].remove(prova);
      disciplinaDatas[selectedCourse]
          .avaliacoes[kTipoAvaliacao.provas]
          .remove(prova);
    }

    if (quantidadeDeProvas == QuantidadeDeProvas.zero &&
        List.from(pesosGeraisTextEditingControllers[selectedCourse].keys)
            .contains('Prova')) {
      pesosGeraisTextEditingControllers[selectedCourse]['Prova'] =
          TextEditingController(text: '0,00');
      disciplinaDatas[selectedCourse].pesosGerais[kTipoAvaliacao.provas] = 0.0;
    }

    if (!shouldEscolhaPesosGeraisAparecer) {
      disciplinaDatas[selectedCourse].pesosGerais = {
        kTipoAvaliacao.provas: null,
        kTipoAvaliacao.trabalhos: null,
      };
      pesosGeraisTextEditingControllers[selectedCourse] = {
        'Prova': TextEditingController(text: '0,00'),
        'Trabalho': TextEditingController(text: '0,00'),
      };
    }

    notifyListeners();
  }

  bool get isDisciplinaReady {
    if (!((provasExistentes[selectedCourse] != null &&
        quantidadeTrabalhos[selectedCourse] != null))) {
      print('Ou provas ou trabalhos estão vazios.');
      return false;
    }

    for (kTipoAvaliacao tipoAvaliacao in [
      kTipoAvaliacao.trabalhos,
      kTipoAvaliacao.provas
    ]) {
      for (String avaliacao
          in disciplinaDatas[selectedCourse].avaliacoes[tipoAvaliacao].keys) {
        if (disciplinaDatas[selectedCourse]
                .avaliacoes[tipoAvaliacao][avaliacao]
                .peso ==
            0.0) {
          print('$avaliacao estava vazia');
          return false;
        }

        if (disciplinaDatas[selectedCourse]
                .avaliacoes[tipoAvaliacao][avaliacao]
                .peso >=
            10.0) {
          print('$avaliacao tinha peso maior ou igual a 10');

          return false;
        }
      }
      if (shouldEscolhaPesosGeraisAparecer &&
          (disciplinaDatas[selectedCourse].pesosGerais[tipoAvaliacao] ?? 0.0) ==
              0.0) {
        print('peso de $tipoAvaliacao estava vazio');
        return false;
      }
    }

    if (shouldEscolhaPesosGeraisAparecer) {
      for (kTipoAvaliacao tipo in [
        kTipoAvaliacao.trabalhos,
        kTipoAvaliacao.provas
      ]) {
        if (disciplinaDatas[selectedCourse].pesosGerais[tipo] == 0.0) {
          print('Um dos pesos gerais estava vazio');
          return false;
        }
      }
    }

    for (String trabalho
        in isParsable[selectedCourse][EditorType.trabalhos].keys) {
      if (!(isParsable[selectedCourse][trabalho] ?? true)) {
        print('$trabalho unparsable');
        return false;
      }
    }

    for (String prova in isParsable[selectedCourse][EditorType.provas].keys) {
      if (!(isParsable[selectedCourse][EditorType.provas][prova] ?? true)) {
        print('$prova unparsable');
        return false;
      }
    }

    for (String tipo
        in isParsable[selectedCourse][EditorType.pesosGerais].keys) {
      if (!(isParsable[selectedCourse][EditorType.pesosGerais][tipo] ?? true)) {
        print('$tipo unparsable');
        return false;
      }
    }

    print('isDisciplinaReady: true');
    return true;
  }

  void onTapConfirmButton(List<String> avaliacoesSemClassificacao) async {
    Firestore _firestore = Firestore.instance;

    if (provasExistentes[selectedCourse] == QuantidadeDeProvas.umSemestre ||
        provasExistentes[selectedCourse] == QuantidadeDeProvas.doisSemestres) {
      disciplinaDatas[selectedCourse].avaliacoes[kTipoAvaliacao.substitutivas]
          ['PS1'] = AvaliacaoData(substituiAvaliacoes: ['P1', 'P2']);
    }

    if (provasExistentes[selectedCourse] == QuantidadeDeProvas.doisSemestres) {
      disciplinaDatas[selectedCourse].avaliacoes[kTipoAvaliacao.substitutivas]
          ['PS2'] = AvaliacaoData(substituiAvaliacoes: ['P3', 'P4']);
    }

//    print(GeneralFunctionsBrain.convertDisciplinaDataToMap(disciplinaDatas[selectedCourse]));

    await _firestore
        .collection('plano_de_ensino')
        .document(selectedCourse)
        .setData(GeneralFunctionsBrain.convertDisciplinaDataToMap(
            disciplinaDatas[selectedCourse]));

    setupPlanoDeEnsinoEditor(
      course: selectedCourse,
      avaliacoesSemClassificacao: avaliacoesSemClassificacao,
    );
    notifyListeners();
  }

  Future<void> setupPlanoDeEnsinoEditor(
      {String course, List<String> avaliacoesSemClassificacao}) async {
    try {
      if (course != null) selectedCourse = course;

      reset(course: course);

      Firestore _firestore = Firestore.instance;

      DocumentSnapshot documentSnapshot = await _firestore
          .collection('plano_de_ensino')
          .document(selectedCourse)
          .get();

      Map<String, dynamic> planoDeEnsinoFirebase = documentSnapshot.data;

      if (planoDeEnsinoFirebase != null) {
        disciplinaDatas[course ?? selectedCourse] =
            GeneralFunctionsBrain.convertPlanoDeEnsinoFirebaseToDisciplinaData(
                planoDeEnsinoFirebase);
      }

      // Para toda avaliacao fora do plano de ensino do firebase, mas que está no MAUAnet, faça o seguinte:
      for (String avaliacao in avaliacoesSemClassificacao) {
        try {
          if (disciplinaDatas[course ?? selectedCourse].avaliacoes[
                  GeneralFunctionsBrain.getTipoAvaliacaoFromAvaliacaoName(
                      avaliacao)][avaliacao] ==
              null) {
            disciplinaDatas[course ?? selectedCourse].avaliacoes[
                GeneralFunctionsBrain.getTipoAvaliacaoFromAvaliacaoName(
                    avaliacao)][avaliacao] = AvaliacaoData(peso: 0.0);
            pesoAvaliacoesTextEditingControllers[course ?? selectedCourse][
                    GeneralFunctionsBrain.getTipoAvaliacaoFromAvaliacaoName(
                        avaliacao)][avaliacao] =
                TextEditingController(text: '0,00');
          }
        } catch (e) {
          print(
              'ERRO em setupPlanoDeEnsinoEditor: não foi possível associar $avaliacao, de avaliacoesSemClassificacao, a disiciplinaData');
        }
      }

      if (!(planoDeEnsinoFirebase == null &&
          avaliacoesSemClassificacao.length == 0)) {
        provasExistentes[course ?? selectedCourse] =
            GeneralFunctionsBrain.getQuantidadeDeProvasFromDisciplinaData(
                disciplinaDatas[course ?? selectedCourse]);

        quantidadeTrabalhos[course ?? selectedCourse] =
            GeneralFunctionsBrain.getQuantidadeDeTrabalhosFromDisciplinaData(
                disciplinaDatas[course ?? selectedCourse]);
      }

      pesosGeraisTextEditingControllers[course ?? selectedCourse] = {
        'Prova': TextEditingController(
            text: GeneralFunctionsBrain.formatTextFieldTextFromDouble(
                disciplinaDatas[course ?? selectedCourse]
                        .pesosGerais[kTipoAvaliacao.provas] ??
                    0.0)),
        'Trabalho': TextEditingController(
          text: GeneralFunctionsBrain.formatTextFieldTextFromDouble(
              disciplinaDatas[course ?? selectedCourse]
                      .pesosGerais[kTipoAvaliacao.trabalhos] ??
                  0.0),
        ),
      };

      for (String trabalho in disciplinaDatas[course ?? selectedCourse]
          .avaliacoes[kTipoAvaliacao.trabalhos]
          .keys) {
        pesoAvaliacoesTextEditingControllers[course ?? selectedCourse]
            [kTipoAvaliacao.trabalhos][trabalho] = TextEditingController(
          text: GeneralFunctionsBrain.formatTextFieldTextFromDouble(
              disciplinaDatas[course ?? selectedCourse]
                      .avaliacoes[kTipoAvaliacao.trabalhos][trabalho]
                      .peso ??
                  0.0),
        );
        isParsable[course ?? selectedCourse][EditorType.trabalhos][trabalho] =
            true;
      }

      for (String prova in disciplinaDatas[course ?? selectedCourse]
          .avaliacoes[kTipoAvaliacao.provas]
          .keys) {
        pesoAvaliacoesTextEditingControllers[course ?? selectedCourse]
            [kTipoAvaliacao.provas][prova] = TextEditingController(
          text: GeneralFunctionsBrain.formatTextFieldTextFromDouble(
              disciplinaDatas[course ?? selectedCourse]
                      .avaliacoes[kTipoAvaliacao.provas][prova]
                      .peso ??
                  0.0),
        );
        isParsable[course ?? selectedCourse][EditorType.provas][prova] = true;
      }
    } catch (e) {
      print('ERRO em setupPlanoDeEnsinoEditor: $e');
      reset();
    }
  }

  bool get shouldEscolhaPesosGeraisAparecer =>
      ((provasExistentes[selectedCourse] ?? QuantidadeDeProvas.umSemestre) !=
          QuantidadeDeProvas.zero) &&
      ((quantidadeTrabalhos[selectedCourse] ?? 1) != 0);

  kTipoAvaliacao getTipoAvaliacaoFromString(String tipo) => {
        'Trabalho': kTipoAvaliacao.trabalhos,
        'Prova': kTipoAvaliacao.provas
      }[tipo];

  String get getConfirmText {
    Map<kTipoAvaliacao, String> stringPesosDisciplinaMap = {};
    try {
      for (kTipoAvaliacao tipo in [
        kTipoAvaliacao.trabalhos,
        kTipoAvaliacao.provas
      ]) {
        stringPesosDisciplinaMap[tipo] = '';

        for (String avaliacao
            in disciplinaDatas[selectedCourse].avaliacoes[tipo].keys) {
          try {
            stringPesosDisciplinaMap[tipo] = stringPesosDisciplinaMap[tipo] +
                '\n$avaliacao: ${disciplinaDatas[selectedCourse].avaliacoes[tipo][avaliacao].peso.toString().replaceAll('.', ',')}';
          } catch (e) {
            stringPesosDisciplinaMap[tipo] =
                stringPesosDisciplinaMap[tipo] + '\n$avaliacao: ERRO';
          }
        }

        if (stringPesosDisciplinaMap[tipo] == '') {
          stringPesosDisciplinaMap[tipo] = '\n---';
        }
      }
    } catch (e) {
      print(e);
    }
    String trabalhos =
        '\n\nTrabalhos:${stringPesosDisciplinaMap[kTipoAvaliacao.trabalhos]}';
    String provas =
        '\n\nProvas:${stringPesosDisciplinaMap[kTipoAvaliacao.provas]}';
    String pesosGerais =
        '\n\nPesos Gerais:\nTrabalhos: ${disciplinaDatas[selectedCourse].pesosGerais[kTipoAvaliacao.trabalhos].toString().replaceAll('.', ',')}\nProvas: ${disciplinaDatas[selectedCourse].pesosGerais[kTipoAvaliacao.provas].toString().replaceAll('.', ',')}';

    return 'Você tem certeza de que estes pesos estão corretos?' +
        trabalhos +
        provas +
        (shouldEscolhaPesosGeraisAparecer ? pesosGerais : '');
  }

  void reset({String course}) {
    disciplinaDatas[course ?? selectedCourse] = DisciplinaData(
      avaliacoes: {
        kTipoAvaliacao.trabalhos: {},
        kTipoAvaliacao.provas: {},
        kTipoAvaliacao.substitutivas: {}
      },
      pesosGerais: {
        kTipoAvaliacao.provas: null,
        kTipoAvaliacao.trabalhos: null,
      },
    );

    quantidadeTrabalhos[course ?? selectedCourse] = null;
    provasExistentes[course ?? selectedCourse] = null;

    disciplinaDatas[course ?? selectedCourse]
        .pesosGerais[kTipoAvaliacao.provas] = 0.0;
    disciplinaDatas[course ?? selectedCourse]
        .pesosGerais[kTipoAvaliacao.trabalhos] = 0.0;

    pesoAvaliacoesTextEditingControllers[course ?? selectedCourse] = {
      kTipoAvaliacao.provas: {},
      kTipoAvaliacao.trabalhos: {},
      kTipoAvaliacao.substitutivas: {},
    };

    pesosGeraisTextEditingControllers[course ?? selectedCourse] = {
      'Prova': TextEditingController(text: '0,00'),
      'Trabalho': TextEditingController(text: '0,00'),
    };

    isParsable[course ?? selectedCourse] = {
      EditorType.provas: {},
      EditorType.trabalhos: {},
      EditorType.pesosGerais: {},
    };
    try {} catch (E) {}
  }
}
