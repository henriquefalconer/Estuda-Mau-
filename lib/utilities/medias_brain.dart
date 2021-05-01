import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/widgets/notas_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MediasBrain extends ChangeNotifier {
  Firestore _firestore = Firestore.instance;

  List<String> avaliacoesSemClassificacao({String course}) =>
      List.from(_disciplinaDatas[course ?? currentScreenCourse]
          .avaliacoes[kTipoAvaliacao.semClassificacao]
          .keys);

  bool get showPlanoDeEnsinoWarning =>
      allPlanosDeEnsinoStates[currentScreenCourse] !=
          PlanoDeEnsinoState.verificado &&
      !(allPlanosDeEnsinoStates[currentScreenCourse] ==
              PlanoDeEnsinoState.naoVerificado &&
          !mostrarNovamentePlanoDeEnsinoMontadoPorUsuario);

  Map<String, DisciplinaData> _disciplinaDatas = {};

  bool mostrarNovamentePlanoDeEnsinoMontadoPorUsuario = true;

  void changeMostrarNovamentePlanoDeEnsinoMontadoPorUsuario() {
    mostrarNovamentePlanoDeEnsinoMontadoPorUsuario =
        !mostrarNovamentePlanoDeEnsinoMontadoPorUsuario;
    notifyListeners();
  }

  List<String> getCoursesList() => List.from(_disciplinaDatas.keys);

  Future<void> uploadNotasUsuario({
    String usuarioRA,
    Map<String, dynamic> notasMauaNet,
  }) async {
    DocumentReference notasCollection =
        _firestore.collection('dados_notas').document(usuarioRA);

    MediasBrain mediasBrainTEMP = MediasBrain();
    await mediasBrainTEMP.setupDisciplinaDatas(notasMauaNet);

    formatMauaNetMapFromStringToDouble(notasMauaNet);

    Map<String, dynamic> mediasParciais = {
      'geral': mediasBrainTEMP.calcularMediaGeral,
      'materias': {}
    };

    for (String course in _disciplinaDatas.keys) {
      mediasParciais['materias'][course] =
          mediasBrainTEMP.calcularMediaMateria(curso: course);
    }

    mediasBrainTEMP.changeTipoMedia();

    Map<String, dynamic> mediasFinais = {
      'geral': mediasBrainTEMP.calcularMediaGeral,
      'materias': {}
    };
    for (String course in _disciplinaDatas.keys) {
      mediasFinais['materias'][course] =
          mediasBrainTEMP.calcularMediaMateria(curso: course);
    }

    notasCollection.setData(
      {
        'notas': notasMauaNet,
        'medias': {
          'parciais': mediasParciais,
          'finais': mediasFinais,
        },
      },
    );
  }

  Map<String, dynamic> _planoDeEnsinoMauaNet = {};

  Map<String, dynamic> formatMauaNetMapFromStringToDouble(
      Map<String, dynamic> mauaNetMap) {
    for (String curso in mauaNetMap.keys) {
      if (GeneralFunctionsBrain
          .isMauaNetNotasCursoWith16Trabalhos4ProvasAnd2Substitutivas(
              mauaNetMap[curso])) {
        mauaNetMap[curso].clear();
      }
      for (dynamic avaliacao in mauaNetMap[curso].keys) {
        try {
          mauaNetMap[curso][avaliacao] =
              GeneralFunctionsBrain.convertMauaNetNotaToDouble(
                  mauaNetMap[curso][avaliacao]);
        } catch (e) {}
      }
    }
    return mauaNetMap;
  }

  Map<String, PlanoDeEnsinoState> allPlanosDeEnsinoStates = {};

  Future<void> setupDisciplinasProvisorias() async {
    Map<String, dynamic> notasMauaNet = {
      'EFB105 - Cálculo Diferencial e Integral I': {
        'P1': 9.0,
        'P2': 9.5,
        'P3': 8.0,
        'P4': 2.0,
        'PS1': 10.0,
        'PS2': 7.0,
        'T1': 10.0,
        'T2': 6.0,
        'T3': 9.0,
        'T4': 9.5,
      },
      'EFB106 - Vetores e Geometria Analítica': {
        'P1': 9.0,
        'P2': 9.5,
        'P3': 8.0,
        'P4': 2.0,
        'PS1': 10.0,
        'PS2': 7.0,
        'T1': 10.0,
        'T2': 6.0,
        'T3': 9.0,
        'T4': 9.5,
      },
      'EFB207 - Física I': {
        'P1': 9.0,
        'P2': 9.5,
        'P3': 8.0,
        'P4': 2.0,
        'PS1': 10.0,
        'PS2': 7.0,
        'T1': 10.0,
        'T2': 6.0,
        'T3': 9.0,
        'T4': 9.5,
      },
      'EFB302 - Desenho': {
        'P1': 9.0,
        'P2': 9.5,
        'P3': 8.0,
        'P4': 2.0,
        'PS1': 10.0,
        'PS2': 7.0,
        'T1': 10.0,
        'T2': 6.0,
        'T3': 9.0,
        'T4': 9.5,
      },
      'EFB403 - Algoritmos e Programação': {
        'P1': 9.0,
        'P2': 9.5,
        'P3': 8.0,
        'P4': 2.0,
        'PS1': 10.0,
        'PS2': 7.0,
        'T1': 10.0,
        'T2': 6.0,
        'T3': 9.0,
        'T4': 9.5,
      },
      'EFB502 - Química Geral': {
        'P1': 9.0,
        'P2': 9.5,
        'P3': 8.0,
        'P4': 2.0,
        'PS1': 10.0,
        'PS2': 7.0,
        'T1': 10.0,
        'T2': 6.0,
        'T3': 9.0,
        'T4': 9.5,
      },
      'EFB604 - Fundamentos de Engenharia': {
        'P1': 9.0,
        'P2': 9.5,
        'P3': 8.0,
        'P4': 2.0,
        'PS1': 10.0,
        'PS2': 7.0,
        'T1': 10.0,
        'T2': 6.0,
        'T3': 9.0,
        'T4': 9.5,
      },
    };

    await setupDisciplinaDatas(notasMauaNet);
  }

  Future<void> setupDisciplinaDatas(Map<String, dynamic> notasMauaNet) async {
    Map<String, DisciplinaData> disciplinaDatas = {};

    // Obter dados do plano de ensino do sistema do EstudaMaua:
    CollectionReference planosDeEnsinoCollectionFirebase =
        _firestore.collection('plano_de_ensino');

    // Obter dados de notas do usuário:
    notasMauaNet = formatMauaNetMapFromStringToDouble(notasMauaNet);

    // Adicionando Disciplina extra:
//    try {
//      notasMauaNet['ECM404 - Estrustura de Dados e Técnicas de Programação'] = {
//        'T1': 9.0
//      };
//      notasMauaNet['EFB204 - Mecânica Geral']['T1'] = 4;
//    } catch (e) {}

    _planoDeEnsinoMauaNet = notasMauaNet;

    // Montar a estrutura local de notas para cada disciplina:
    for (String nomeCurso in notasMauaNet.keys) {
      try {
        var pesosGerais;
        var avaliacoes = {};

        List<String> avaliacoesMauaNet =
            List.from(notasMauaNet[nomeCurso].keys);

        dynamic planoDeEnsinoFirebaseMateria =
            await planosDeEnsinoCollectionFirebase.document(nomeCurso).get();

        if (planoDeEnsinoFirebaseMateria.data != null) {
          if (planoDeEnsinoFirebaseMateria.data['verificado_manualmente'] ??
              false) {
            allPlanosDeEnsinoStates[nomeCurso] = PlanoDeEnsinoState.verificado;
          } else {
            allPlanosDeEnsinoStates[nomeCurso] =
                PlanoDeEnsinoState.naoVerificado;
          }

          pesosGerais = planoDeEnsinoFirebaseMateria.data['pesos_gerais'];
          avaliacoes = planoDeEnsinoFirebaseMateria.data['avaliacoes'];
        } else {
          allPlanosDeEnsinoStates[nomeCurso] = PlanoDeEnsinoState.vazio;
          print(
              '$nomeCurso não existe na base de dados do plano de ensino do firebase!');
          pesosGerais = {'provas': null, 'trabalhos': null};

//          for (String avaliacao in notasMauaNet[nomeCurso].keys) {
//            avaliacoes[avaliacao] = {};
//          }
        }

        disciplinaDatas[nomeCurso] = DisciplinaData(
          avaliacoes: {
            kTipoAvaliacao.provas: {},
            kTipoAvaliacao.trabalhos: {},
            kTipoAvaliacao.substitutivas: {},
            kTipoAvaliacao.semClassificacao: {},
          },
          pesosGerais: {
            kTipoAvaliacao.provas: null,
            kTipoAvaliacao.trabalhos: null,
          },
        );

        for (String tipo in pesosGerais.keys) {
          disciplinaDatas[nomeCurso].pesosGerais[
                  GeneralFunctionsBrain.convertStringToTipoAvaliacao(tipo)] =
              pesosGerais[tipo] != null ? pesosGerais[tipo].toDouble() : null;
        }

        for (String avaliacao in avaliacoes.keys) {
          kTipoAvaliacao tipoAvaliacao =
              GeneralFunctionsBrain.convertStringToTipoAvaliacao(
                  avaliacoes[avaliacao]['tipo']);

          // Se, por algum motivo, a avaliacao no firebase não tiver um tipo associado a ela, faça isso:
          if (tipoAvaliacao == kTipoAvaliacao.semClassificacao) {
            tipoAvaliacao =
                GeneralFunctionsBrain.getTipoAvaliacaoFromAvaliacaoName(
                    avaliacao);
          }

          String descricao = avaliacoes[avaliacao]['descricao'];
          final peso = avaliacoes[avaliacao]['peso'];
          List substituiAvaliacoes =
              avaliacoes[avaliacao]['substitui_avaliacoes'];

          var nota;
          bool notaMovelMinimoEsforco = false;

          try {
            nota = notasMauaNet[nomeCurso][avaliacao];

            avaliacoesMauaNet.remove(avaliacao);
          } catch (e) {
            print(
                'ERRO 1 em getPlanoDeEnsino: $avaliacao de $nomeCurso não está no MauaNet: $e');
          }

          if (nota == null) {
            nota = -1.0;
          }
          disciplinaDatas[nomeCurso].avaliacoes[tipoAvaliacao][avaliacao] =
              AvaliacaoData(
            nota: nota.toDouble(),
            peso: peso != null ? peso.toDouble() : null,
            descricao: descricao,
            substituiAvaliacoes: substituiAvaliacoes,
            substituicao: null,
            isNotaMovelMinimoEsforco: notaMovelMinimoEsforco,
          );
        }
//        print('$nomeCurso: $avaliacoesMauaNet');

        // Para todas as avaliacoes que estão no MAUAnet, mas não estão no firebase, adicionar a um tipo de avaliacoes separado:
        for (String avaliacao in avaliacoesMauaNet) {
          print('Sem classificação: $avaliacao ($nomeCurso)');

          disciplinaDatas[nomeCurso].avaliacoes[kTipoAvaliacao.semClassificacao]
              [avaliacao] = AvaliacaoData(
            nota: notasMauaNet[nomeCurso][avaliacao].toDouble(),
          );
        }
      } catch (e) {
        print('ERRO 2 em getPlanoDeEnsino: $e');
      }
    }

    _disciplinaDatas = disciplinaDatas;

    notifyListeners();
  }

  Future<Map<String, dynamic>> getMediasCardInfo(String curso) async {
    return {
      'course_name': selectedCourseWithoutCourseCode(course: curso),
      'media': calcularMediaMateria(curso: curso),
      'mediaDiferenteMauaNet': mediaMateriaDiferenteDoMauaNet(curso: curso),
    };
  }

  void setupCurrentScreen(String newScreen) {
    currentScreenCourse = newScreen;
    mostrarDescricoes = false;
    notifyListeners();
  }

  void signOut() {
    _disciplinaDatas.clear();
    _planoDeEnsinoMauaNet.clear();
    notifyListeners();
  }

  String currentScreenCourse;

  TiposDeCalculoMedia _tipoDeMediaSelecionado = TiposDeCalculoMedia.parcial;

  TiposDeCalculoMedia get tipoDeMediaSelecionado => _tipoDeMediaSelecionado;

  bool permitirCalculoMediaSemestre = true;
  bool mostrarDescricoes = false;
  bool mostrarSubstituicoesDeNota = true;
  bool modoMinimoEsforco = false;
  bool estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco = true;

  void changeMostrarDescricoes() {
    mostrarDescricoes = !mostrarDescricoes;
    notifyListeners();
  }

  List<AvaliacaoPath> listaDeAvaliacoesASeremModificadas = [];
  List<List<double>> conjuntoDeNotasMinimoEsforco = [];
  int sliderMinimoEsforcoValue = 0;

  double get calcularMediaGeral {
    int quantidadeDeCursos = 0;
    double somaDasMediasMaterias = 0;

    for (String course in _disciplinaDatas.keys) {
      double mediaMateria = calcularMediaMateria(curso: course);

      quantidadeDeCursos =
          quantidadeDeCursos + ((mediaMateria ?? -1.0) >= 0.0 ? 1 : 0);

      somaDasMediasMaterias = somaDasMediasMaterias +
          ((mediaMateria ?? -1.0) >= 0.0 ? mediaMateria : 0);
    }

    return quantidadeDeCursos == 0
        ? null
        : somaDasMediasMaterias / quantidadeDeCursos;
  }

  Map<kTipoAvaliacao, List<Widget>> getProvasNotasSlidersMap() {
    Map<kTipoAvaliacao, List<Widget>> sliderWidgetsListsMap = {};

    for (kTipoAvaliacao tipo in [
      kTipoAvaliacao.provas,
      kTipoAvaliacao.substitutivas,
    ]) {
      List<Widget> sliderWidgetsList = [];

      if (_disciplinaDatas[currentScreenCourse].avaliacoes[tipo] != null) {
        List<String> avaliacaoList = List.from(
            _disciplinaDatas[currentScreenCourse].avaliacoes[tipo].keys);
        avaliacaoList.sort();
        for (String avaliacao in avaliacaoList) {
          AvaliacaoData avaliacaoData =
              _disciplinaDatas[currentScreenCourse].avaliacoes[tipo][avaliacao];

          double peso;
          double notaSubstitutiva;
          if (tipo == kTipoAvaliacao.trabalhos) {
            peso = avaliacaoData.peso;
            notaSubstitutiva = null;
          } else if (tipo == kTipoAvaliacao.provas) {
            peso = avaliacaoData.peso;
            verificarPossiveisSubstituicoesDeNota(
              curso: currentScreenCourse,
            );
            notaSubstitutiva = avaliacaoData.substituicao;
//            if (avaliacaoData.nota == -1.0 && notaSubstitutiva != null) {
//              _planoDeEnsinoSet[currentScreenCourse]
//                  .avaliacoes[tipo][avaliacao]
//                  .nota = -0.5;
//            }
          } else if (tipo == kTipoAvaliacao.substitutivas) {
            verificarPossiveisSubstituicoesDeNota(
              curso: currentScreenCourse,
            );
            peso = null;
            notaSubstitutiva = null;
          }
          double notaAvaliacao = avaliacaoData.nota;
          Widget widget = NotasSlider(
            width: 300.0,
            label: avaliacao,
            peso: peso == null ? null : 'x$peso'.replaceAll('.', ','),
            faltaText: tipo == kTipoAvaliacao.trabalhos ? 'NE' : 'NC',
            nota: notaAvaliacao,
            substituicao: notaSubstitutiva,
            nomeSubstitutiva: avaliacaoData.nomeSubstitutiva,
            substituicaoVisivel: mostrarSubstituicoesDeNota,
            descricao: tipo == kTipoAvaliacao.trabalhos
                ? avaliacaoData.descricao
                : (tipo == kTipoAvaliacao.substitutivas
                    ? 'Substitui a nota das provas ${GeneralFunctionsBrain.convertListToStringOfList(GeneralFunctionsBrain.getSubstituiAvaliacoesFromSubstitutivaName(avaliacao))}'
//                    ? 'Substitui a nota das provas ${GeneralFunctionsBrain.convertListToStringOfList(avaliacaoData.substituiAvaliacoes)}'
                    : null),
            descricaoVisivel: mostrarDescricoes &&
                (tipo == kTipoAvaliacao.trabalhos ||
                    tipo == kTipoAvaliacao.substitutivas),
            minimoEsforcoNotaMovel: avaliacaoData.isNotaMovelMinimoEsforco,
            minimoEsforco: modoMinimoEsforco,
            onTapCheckBox: (bool value) {
              if (modoMinimoEsforco) {
                estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco =
                    true;
                _disciplinaDatas[currentScreenCourse]
                    .avaliacoes[tipo][avaliacao]
                    .isNotaMovelMinimoEsforco = value;
                verificacaoDeNotasMarcadasMinimoEsforco();
                notifyListeners();
              }
            },
            onDragging: (double newNota) {
              _disciplinaDatas[currentScreenCourse]
                  .avaliacoes[tipo][avaliacao]
                  .nota = (newNota * 10).round() / 10;
              if (modoMinimoEsforco &&
                  !_disciplinaDatas[currentScreenCourse]
                      .avaliacoes[tipo][avaliacao]
                      .isNotaMovelMinimoEsforco) {
                estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco =
                    true;
              }
//              for (String avaliacao in _disciplinaDatas[currentScreenCourse]
//                  .avaliacoes[kTipoAvaliacao.provas]
//                  .keys) {
//                print(
//                    '$avaliacao: ${_disciplinaDatas[currentScreenCourse].avaliacoes[kTipoAvaliacao.provas][avaliacao].nota}');
//              }
              notifyListeners();
            },
            notaDiferenteMauaNet: ((_planoDeEnsinoMauaNet[currentScreenCourse]
                        [avaliacao] ??
                    -1.0) !=
                notaAvaliacao),
          );

          sliderWidgetsList.add(widget);
        }
      }

      sliderWidgetsListsMap[tipo] =
          sliderWidgetsList == [] ? null : sliderWidgetsList;
    }

    return sliderWidgetsListsMap;
  }

  Map<kTipoAvaliacao, List<Widget>> getTrabalhosNotasSlidersMap() {
    Map<kTipoAvaliacao, List<Widget>> sliderWidgetsListsMap = {};

    List<Widget> sliderWidgetsList = [];

    if (_disciplinaDatas[currentScreenCourse]
            .avaliacoes[kTipoAvaliacao.trabalhos] !=
        null) {
      List<String> avaliacaoList = List.from(
          _disciplinaDatas[currentScreenCourse]
              .avaliacoes[kTipoAvaliacao.trabalhos]
              .keys);
      avaliacaoList.sort();
      for (String avaliacao in avaliacaoList) {
        AvaliacaoData avaliacaoData = _disciplinaDatas[currentScreenCourse]
            .avaliacoes[kTipoAvaliacao.trabalhos][avaliacao];

        double peso;
        double notaSubstitutiva;
        peso = avaliacaoData.peso;

        double notaAvaliacao = avaliacaoData.nota;
        Widget widget = NotasSlider(
          width: 300.0,
          label: avaliacao,
          peso: peso == null ? null : 'x$peso'.replaceAll('.', ','),
          faltaText: 'NE',
          nota: notaAvaliacao,
          substituicao: notaSubstitutiva,
          substituicaoVisivel: mostrarSubstituicoesDeNota,
          descricao: avaliacaoData.descricao,
          descricaoVisivel: mostrarDescricoes,
          minimoEsforcoNotaMovel: avaliacaoData.isNotaMovelMinimoEsforco,
          minimoEsforco: modoMinimoEsforco,
          onTapCheckBox: (bool value) {
            if (modoMinimoEsforco) {
              estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco =
                  true;
              _disciplinaDatas[currentScreenCourse]
                  .avaliacoes[kTipoAvaliacao.trabalhos][avaliacao]
                  .isNotaMovelMinimoEsforco = value;
              verificacaoDeNotasMarcadasMinimoEsforco();
              notifyListeners();
            }
          },
          onDragging: (double newNota) {
            _disciplinaDatas[currentScreenCourse]
                .avaliacoes[kTipoAvaliacao.trabalhos][avaliacao]
                .nota = (newNota * 10).round() / 10;
            if (modoMinimoEsforco &&
                !_disciplinaDatas[currentScreenCourse]
                    .avaliacoes[kTipoAvaliacao.trabalhos][avaliacao]
                    .isNotaMovelMinimoEsforco) {
              estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco =
                  true;
            }
//                calcularTodasAsMediasDaMateria(calculateOnCurrentScreen: true);
            notifyListeners();
          },
          notaDiferenteMauaNet: ((_planoDeEnsinoMauaNet[currentScreenCourse]
                      [avaliacao] ??
                  -1.0) !=
              notaAvaliacao),
        );

        sliderWidgetsList.add(widget);
      }
    }

    sliderWidgetsListsMap[kTipoAvaliacao.trabalhos] =
        sliderWidgetsList == [] ? null : sliderWidgetsList;

    return sliderWidgetsListsMap;
  }

  Map<kTipoAvaliacao, List<Widget>> getIndefinidosNotasSlidersMap(
      {String course}) {
    Map<kTipoAvaliacao, List<Widget>> sliderWidgetsListsMap = {};

    List<Widget> sliderWidgetsList = [];

    if (_disciplinaDatas[course ?? currentScreenCourse]
            .avaliacoes[kTipoAvaliacao.semClassificacao] !=
        null) {
      List<String> avaliacaoList = List.from(
          _disciplinaDatas[course ?? currentScreenCourse]
              .avaliacoes[kTipoAvaliacao.semClassificacao]
              .keys);

      avaliacaoList.sort();

      for (String avaliacao in avaliacaoList) {
        AvaliacaoData avaliacaoData =
            _disciplinaDatas[course ?? currentScreenCourse]
                .avaliacoes[kTipoAvaliacao.semClassificacao][avaliacao];

        double peso = avaliacaoData.peso;
        double notaAvaliacao = avaliacaoData.nota;

        Widget widget = NotasSlider(
          width: 300.0,
          label: avaliacao,
          peso: peso == null ? null : 'x$peso'.replaceAll('.', ','),
          faltaText: 'NE',
          nota: notaAvaliacao,
          substituicaoVisivel: mostrarSubstituicoesDeNota,
          descricao: avaliacaoData.descricao,
          descricaoVisivel: mostrarDescricoes,
          minimoEsforcoNotaMovel: avaliacaoData.isNotaMovelMinimoEsforco,
          minimoEsforco: modoMinimoEsforco,
          onTapCheckBox: (bool value) {
            if (modoMinimoEsforco) {
              estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco =
                  true;
              _disciplinaDatas[course ?? currentScreenCourse]
                  .avaliacoes[kTipoAvaliacao.semClassificacao][avaliacao]
                  .isNotaMovelMinimoEsforco = value;
              verificacaoDeNotasMarcadasMinimoEsforco();
              notifyListeners();
            }
          },
          onDragging: (double newNota) {
            _disciplinaDatas[course ?? currentScreenCourse]
                .avaliacoes[kTipoAvaliacao.semClassificacao][avaliacao]
                .nota = (newNota * 10).round() / 10;
            if (modoMinimoEsforco &&
                !_disciplinaDatas[course ?? currentScreenCourse]
                    .avaliacoes[kTipoAvaliacao.semClassificacao][avaliacao]
                    .isNotaMovelMinimoEsforco) {
              estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco =
                  true;
            }
            notifyListeners();
          },
          notaDiferenteMauaNet:
              ((_planoDeEnsinoMauaNet[course ?? currentScreenCourse]
                          [avaliacao] ??
                      -1.0) !=
                  notaAvaliacao),
        );

        sliderWidgetsList.add(widget);
      }
    }

    sliderWidgetsListsMap[kTipoAvaliacao.semClassificacao] =
        sliderWidgetsList == [] ? null : sliderWidgetsList;

    return sliderWidgetsListsMap;
  }

  double getPesoProvas(String curso) {
    return _disciplinaDatas[curso].pesosGerais[kTipoAvaliacao.provas];
  }

  double getPesoTrabalhos(String curso) {
    if (_disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.trabalhos] == null) {
      return null;
    } else {
      return _disciplinaDatas[curso].pesosGerais[kTipoAvaliacao.trabalhos];
    }
  }

  double calcularMediaProvasMateria({String curso}) {
    curso = curso ?? currentScreenCourse;

    verificarPossiveisSubstituicoesDeNota(curso: curso);

    double mediaProvas;

    double somaPesos = 0.0;
    double somaNotasComPeso = 0.0;

    for (String prova
        in _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas].keys) {
      double nota = _disciplinaDatas[curso]
              .avaliacoes[kTipoAvaliacao.provas][prova]
              .substituicao ??
          _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas][prova].nota;
      double peso =
          _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas][prova].peso;
      if (peso == null) peso = 1.0;
      somaNotasComPeso = somaNotasComPeso +
          (nota >= 0
              ? nota * peso
              : 0); // Se a nota for -0.5 ou -1.0, a nota não será adicionada à soma de notas.
      somaPesos = somaPesos +
          (nota >= -0.5
              ? peso
              : _tipoDeMediaSelecionado == TiposDeCalculoMedia.final_
                  ? peso
                  : 0); // Se, e apenas se, a nota for -1.0 e o tipo de média for parcial, a nota não será adicionada à quantidade de provas.
    }

    if (somaPesos == 0) {
      mediaProvas = null;
    } else {
      mediaProvas = somaNotasComPeso / somaPesos;
    }

    return mediaProvas;
  }

  double calcularMediaTrabalhosMateria({String curso}) {
    curso = curso ?? currentScreenCourse;

    double mediaTrabalhos;

    double quantidadePesos = 0.0;
    double somaNotasComPeso = 0.0;

    for (String trabalho
        in _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.trabalhos].keys) {
      double nota = _disciplinaDatas[curso]
              .avaliacoes[kTipoAvaliacao.trabalhos][trabalho]
              .substituicao ??
          _disciplinaDatas[curso]
              .avaliacoes[kTipoAvaliacao.trabalhos][trabalho]
              .nota;
      double peso = _disciplinaDatas[curso]
          .avaliacoes[kTipoAvaliacao.trabalhos][trabalho]
          .peso;
      if (peso == null) peso = 1.0;

      somaNotasComPeso = somaNotasComPeso +
          (nota >= 0
              ? nota * peso
              : 0); // Se a nota for -0.5 ou -1.0, a nota não será adicionada à soma de notas.
      quantidadePesos = quantidadePesos +
          (nota >= -0.5
              ? peso
              : _tipoDeMediaSelecionado == TiposDeCalculoMedia.final_
                  ? peso
                  : 0); // Se, e apenas se, a nota for -1.0, a nota não será adicionada à quantidade de trabalhos.
    }

    if (quantidadePesos == 0) {
      mediaTrabalhos = null;
    } else {
      mediaTrabalhos = somaNotasComPeso / quantidadePesos;
    }

    return mediaTrabalhos;
  }

//  bool get algumaMateriaNaoPossuiPlanoDeEnsino {
//    for (String curso in _planoDeEnsinoSet.keys) {
//      if (planoDeEnsinoNaoExisteParaMateria(curso: curso)) {
//        return true;
//      }
//    }
//
//    return false;
//  }
//
//  bool planoDeEnsinoNaoExisteParaMateria({String curso}) {
//    try {
//      return allPlanosDeEnsinoStates[curso ?? currentScreenCourse] ==
//          PlanoDeEnsinoState.vazio;
//    } catch (e) {
//      print('ERRO em planoDeNaoEnsinoExisteParaMateria: $e');
//      return false;
//    }
//  }

  bool get mediaGeralDiferenteDoMauaNet {
    for (String curso in _disciplinaDatas.keys) {
      if (mediaMateriaDiferenteDoMauaNet(curso: curso)) {
        return true;
      }
    }

    return false;
  }

  bool mediaMateriaDiferenteDoMauaNet({String curso}) {
    curso = curso ?? currentScreenCourse;

    return (mediaProvasDiferenteDoMauaNet(curso: curso) ||
            mediaTrabalhosDiferenteDoMauaNet(curso: curso))
//       || planoDeEnsinoNaoExisteParaMateria(curso: curso)
        ;
  }

  bool mediaProvasDiferenteDoMauaNet({String curso}) {
    curso = curso ?? currentScreenCourse;

    if (_disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.substitutivas] !=
        null) {
      for (String substitutiva in _disciplinaDatas[curso]
          .avaliacoes[kTipoAvaliacao.substitutivas]
          .keys) {
        if (_disciplinaDatas[curso]
                .avaliacoes[kTipoAvaliacao.substitutivas][substitutiva]
                .nota !=
            (_planoDeEnsinoMauaNet[curso][substitutiva] ?? -1.0)) {
          return true;
        }
      }
    }

    if (_disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas] != null) {
      for (String prova
          in _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas].keys) {
        if (_disciplinaDatas[curso]
                .avaliacoes[kTipoAvaliacao.provas][prova]
                .nota !=
            (_planoDeEnsinoMauaNet[curso][prova] ?? -1.0)) {
          return true;
        }
      }
    }

    return false;
  }

  bool mediaTrabalhosDiferenteDoMauaNet({String curso}) {
    curso = curso ?? currentScreenCourse;

    for (String trabalho
        in _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.trabalhos].keys) {
      if (_disciplinaDatas[curso]
              .avaliacoes[kTipoAvaliacao.trabalhos][trabalho]
              .nota !=
          (_planoDeEnsinoMauaNet[curso][trabalho] ?? -1.0)) {
        return true;
      }
    }

    return false;
  }

  double calcularMediaMateria({String curso}) {
    curso = curso ?? currentScreenCourse;

    double mediaMateria;

    double pesoProvas = getPesoProvas(curso);
    double pesoTrabalhos = getPesoTrabalhos(curso);

    double mediaProvas = calcularMediaProvasMateria(curso: curso);
    double mediaTrabalhos = calcularMediaTrabalhosMateria(curso: curso);

    if (_tipoDeMediaSelecionado == TiposDeCalculoMedia.parcial &&
        (mediaProvas == null && mediaTrabalhos == null)) {
      mediaMateria = null;
    } else if (_tipoDeMediaSelecionado == TiposDeCalculoMedia.parcial &&
        (mediaProvas == null && mediaTrabalhos != null)) {
      mediaMateria = mediaTrabalhos;
    } else if (_tipoDeMediaSelecionado == TiposDeCalculoMedia.parcial &&
        (mediaProvas != null && mediaTrabalhos == null)) {
      mediaMateria = mediaProvas;
    } else {
      mediaMateria = ((pesoProvas ?? 0.0) + (pesoTrabalhos ?? 0.0)) == 0
          ? null
          : ((mediaProvas ?? 0.0) * (pesoProvas ?? 0.0) +
                  (mediaTrabalhos ?? 0.0) * (pesoTrabalhos ?? 0.0)) /
              ((pesoProvas ?? 0.0) + (pesoTrabalhos ?? 0.0));
    }

    return mediaMateria;
  }

  void verificarPossiveisSubstituicoesDeNota({@required String curso}) {
    if (_disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas] != null) {
      for (String prova
          in _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas].keys) {
        AvaliacaoData provaData =
            _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas][prova];
        provaData.substituicao = null;
        if (_disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.substitutivas] !=
            null) {
          for (String substitutiva in _disciplinaDatas[curso]
              .avaliacoes[kTipoAvaliacao.substitutivas]
              .keys) {
            AvaliacaoData substitutivaData = _disciplinaDatas[curso]
                .avaliacoes[kTipoAvaliacao.substitutivas][substitutiva];
//            if (substitutivaData.substituiAvaliacoes.contains(prova)) {
            if (GeneralFunctionsBrain
                    .getSubstituiAvaliacoesFromSubstitutivaName(substitutiva)
                .contains(prova)) {
              provaData.nomeSubstitutiva = substitutiva;

              var notaSub =
                  (substitutivaData.substituicao ?? substitutivaData.nota);

              var notaProva = (provaData.substituicao ?? provaData.nota);

              if (notaSub > notaProva) {
                provaData.substituicao = substitutivaData.nota;
              }
            }
          }
        }
        _disciplinaDatas[curso].avaliacoes[kTipoAvaliacao.provas][prova] =
            provaData;
      }
    }
  }

  void zerarSubstituicoesDeNota(String curso) {
    for (kTipoAvaliacao tipo in [
      kTipoAvaliacao.provas,
      kTipoAvaliacao.trabalhos,
      kTipoAvaliacao.substitutivas
    ]) {
      if (_disciplinaDatas[curso].avaliacoes[tipo] != null) {
        for (String avaliacao
            in _disciplinaDatas[curso].avaliacoes[tipo].keys) {
          _disciplinaDatas[curso].avaliacoes[tipo][avaliacao].substituicao =
              null;
        }
      }
    }
  }

  void marcacaoAutomaticaDeAvaliacoesParaMinimoEsforco(String curso) {
    for (kTipoAvaliacao tipo in [
      kTipoAvaliacao.provas,
      kTipoAvaliacao.trabalhos,
      kTipoAvaliacao.substitutivas
    ]) {
      if (_disciplinaDatas[curso].avaliacoes[tipo] != null) {
        for (String avaliacao
            in _disciplinaDatas[curso].avaliacoes[tipo].keys) {
          if (_disciplinaDatas[curso].avaliacoes[tipo][avaliacao].nota ==
              -1.0) {
            _disciplinaDatas[curso]
                .avaliacoes[tipo][avaliacao]
                .isNotaMovelMinimoEsforco = true;
          } else {
            _disciplinaDatas[curso]
                .avaliacoes[tipo][avaliacao]
                .isNotaMovelMinimoEsforco = false;
          }
        }
      }
    }
  }

//  void calcularTodasAsMediasDaMateria(
//      {String course, bool calculateOnCurrentScreen = true}) {
//    String curso = (calculateOnCurrentScreen && course == null)
//        ? currentScreenCourse
//        : course;
//
//    verificarPossiveisSubstituicoesDeNota(
//      curso: curso,
//      semestreParaFazerSubstituicao: 1,
//    );
//    verificarPossiveisSubstituicoesDeNota(
//      curso: curso,
//      semestreParaFazerSubstituicao: 2,
//    );
//    calcularMediaProvasMateria(curso: curso);
//    calcularMediaTrabalhosMateria(curso: curso);
//
//    calcularMediaMateria();
//  }

  double calcularMediaComNotaEspecificaMinimoEsforco(
      {double notaEspecifica, String curso}) {
    for (AvaliacaoPath avaliacaoPath in listaDeAvaliacoesASeremModificadas) {
      _disciplinaDatas[curso]
          .avaliacoes[avaliacaoPath.tipo][avaliacaoPath.avaliacao]
          .nota = notaEspecifica;
    }

    zerarSubstituicoesDeNota(curso);

    return (calcularMediaMateria() * 10).round() / 10;
  }

  void montarConjuntosDeNotasMinimoEsforco(
      {double notaEspecifica, String curso}) {
    List<List<double>> conjuntoDeNotas = [];
    int numeroMaxConjuntos = 50;
    int loopsDados = 0;
    int limiteDeLoops = 300000;

    double mediaMateria = calcularMediaMateria();

    var randomGenerator = math.Random();

    if (notaEspecifica == null) {
      while (conjuntoDeNotas.length < numeroMaxConjuntos &&
          loopsDados < limiteDeLoops) {
        for (AvaliacaoPath avaliacaoPath
            in listaDeAvaliacoesASeremModificadas) {
          double randomNota = randomGenerator.nextInt(21) / 2;
          _disciplinaDatas[curso]
              .avaliacoes[avaliacaoPath.tipo][avaliacaoPath.avaliacao]
              .nota = (randomNota == 0.0 ? -0.5 : randomNota);
        }

//        calcularTodasAsMediasDaMateria(course: curso);

        if (mediaMateria >= 6.0 && mediaMateria <= 6.1) {
          List<double> conjuntoValidoDeNotas = [];
          for (AvaliacaoPath avaliacaoPath
              in listaDeAvaliacoesASeremModificadas) {
            conjuntoValidoDeNotas.add(_disciplinaDatas[curso]
                .avaliacoes[avaliacaoPath.tipo][avaliacaoPath.avaliacao]
                .nota);
          }
          if (conjuntoDeNotas.contains(conjuntoValidoDeNotas) == false) {
            conjuntoDeNotas.add(conjuntoValidoDeNotas);
          }
        }
        zerarSubstituicoesDeNota(curso);
        loopsDados++;
      }
//      print(loopsDados);
      if (listaDeAvaliacoesASeremModificadas.length == 1) {
        double notaMinima = 10.0;
        for (List<double> nota in conjuntoDeNotas) {
          if (nota[0] < notaMinima) {
            notaMinima = nota[0];
          }
        }
        conjuntoDeNotas = [];
        while (conjuntoDeNotas.length < numeroMaxConjuntos) {
          conjuntoDeNotas.add([notaMinima]);
        }
      }
    } else {
      while (conjuntoDeNotas.length < numeroMaxConjuntos) {
        List<double> conjuntoValidoDeNotas = [];
        // ignore: unused_local_variable
        for (AvaliacaoPath avaliacaoPath
            in listaDeAvaliacoesASeremModificadas) {
          conjuntoValidoDeNotas.add(notaEspecifica);
        }
        conjuntoDeNotas.add(conjuntoValidoDeNotas);
      }
    }
    int index = conjuntoDeNotas[0].length - 1;
    while (index >= 0) {
      conjuntoDeNotas.sort((a, b) => a[index].compareTo(b[index]));
      index--;
    }
//    print(conjuntoDeNotas);

    conjuntoDeNotasMinimoEsforco = conjuntoDeNotas;
  }

  void aplicarValoresDoConjuntoDeNotasMinimoEsforco() {
    int index = 0;
    for (AvaliacaoPath avaliacaoPath in listaDeAvaliacoesASeremModificadas) {
      _disciplinaDatas[currentScreenCourse]
          .avaliacoes[avaliacaoPath.tipo][avaliacaoPath.avaliacao]
          .nota = conjuntoDeNotasMinimoEsforco[sliderMinimoEsforcoValue][index];
      index++;
    }
  }

  void setupMinimoEsforco() {
    listaDeAvaliacoesASeremModificadas = [];
    _tipoDeMediaSelecionado = TiposDeCalculoMedia.final_;
    mostrarSubstituicoesDeNota = false;
    permitirCalculoMediaSemestre = true;
    mostrarDescricoes = false;
    estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco = true;
    marcacaoAutomaticaDeAvaliacoesParaMinimoEsforco(currentScreenCourse);
    verificacaoDeNotasMarcadasMinimoEsforco();
  }

  void onPressRecalcularMinimoEsforcoButton() {
    estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco = false;
    sliderMinimoEsforcoValue = 0;
    algoritmoDeMinimoEsforco();
    notifyListeners();
  }

  void verificacaoDeNotasMarcadasMinimoEsforco() {
    listaDeAvaliacoesASeremModificadas = [];

    for (kTipoAvaliacao tipo in [
      kTipoAvaliacao.provas,
      kTipoAvaliacao.trabalhos,
      kTipoAvaliacao.substitutivas
    ]) {
      if (_disciplinaDatas[currentScreenCourse].avaliacoes[tipo] != null) {
        for (String avaliacao
            in _disciplinaDatas[currentScreenCourse].avaliacoes[tipo].keys) {
          if (_disciplinaDatas[currentScreenCourse]
              .avaliacoes[tipo][avaliacao]
              .isNotaMovelMinimoEsforco) {
            listaDeAvaliacoesASeremModificadas.add(AvaliacaoPath(
              tipo: tipo,
              avaliacao: avaliacao,
            ));
          }
        }
      }
    }
    notifyListeners();
  }

  void algoritmoDeMinimoEsforco() {
    if (calcularMediaComNotaEspecificaMinimoEsforco(
            notaEspecifica: -0.5, curso: currentScreenCourse) >=
        6.0) {
      print('média mínima maior que 6.0');
      montarConjuntosDeNotasMinimoEsforco(
          notaEspecifica: -0.5, curso: currentScreenCourse);
    } else if (calcularMediaComNotaEspecificaMinimoEsforco(
            notaEspecifica: 10.0, curso: currentScreenCourse) <
        6.0) {
      print('média máxima menor que 6.0');
      montarConjuntosDeNotasMinimoEsforco(
          notaEspecifica: 10.0, curso: currentScreenCourse);
    } else {
      print('média mínima menor que 6.0 e máxima maior que 6.0');
      montarConjuntosDeNotasMinimoEsforco(
          notaEspecifica: null, curso: currentScreenCourse);
    }
  }

  String selectedCourseWithoutCourseCode({String course}) {
    return course == null
        ? currentScreenCourse.split('- ')[1]
        : course.split('- ')[1];
  }

  void changeTipoMedia() {
    _tipoDeMediaSelecionado =
        _tipoDeMediaSelecionado == TiposDeCalculoMedia.final_
            ? TiposDeCalculoMedia.parcial
            : TiposDeCalculoMedia.final_;

    if (currentScreenCourse != null) {
//      calcularTodasAsMediasDaMateria(calculateOnCurrentScreen: true);
    }

    notifyListeners();
  }

  bool shouldMediasTrabalhosEProvasBeVisible(
          kTipoAvaliacao tipo1, kTipoAvaliacao tipo2) =>
      !(_disciplinaDatas[currentScreenCourse].avaliacoes[tipo1] == null ||
          _disciplinaDatas[currentScreenCourse].avaliacoes[tipo2] == null);

  String getPesoProvasOuTrabalhos(kTipoAvaliacao tipo) =>
      _disciplinaDatas[currentScreenCourse].pesosGerais[tipo] == null
          ? ''
          : 'x${_disciplinaDatas[currentScreenCourse].pesosGerais[tipo]}'
              .replaceAll('.', ',');

  void onChangeMinimoEsforcoSlider(double value) {
    sliderMinimoEsforcoValue = value.toInt();
    aplicarValoresDoConjuntoDeNotasMinimoEsforco();
//    calcularTodasAsMediasDaMateria(calculateOnCurrentScreen: true);
    notifyListeners();
  }

  void onTapMinimoEsforcoCard() {
    modoMinimoEsforco = !modoMinimoEsforco;
    setupMinimoEsforco();
    notifyListeners();
  }

  void onTapMinimoEsforcoSwitch(bool value) {
    modoMinimoEsforco = value;
    setupMinimoEsforco();
    notifyListeners();
  }
}
