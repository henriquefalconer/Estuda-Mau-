import 'package:estuda_maua/screens/calculo_de_medias_screen/calculo_de_medias_screen.dart';
import 'package:estuda_maua/screens/estatisticas_screen/estatisticas_screen.dart';
import 'package:estuda_maua/screens/explicacao_plano_de_ensino_screen/explicacao_plano_de_ensino_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/plano_de_ensino_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/widgets/imageless_card.dart';
import 'package:estuda_maua/widgets/medias_course_selection_card.dart';
import 'package:estuda_maua/widgets/plano_de_ensino_info_simple.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediasScroll extends StatefulWidget {
  @override
  _MediasScrollState createState() => _MediasScrollState();
}

class _MediasScrollState extends State<MediasScroll> {
  @override
  void initState() {
    super.initState();
//    Provider.of<NetworkBrain>(context, listen: false).copyCollectionDirectory();
//    Provider.of<UserBrain>(context, listen: false).createRandomUsers();
  }

  @override
  Widget build(BuildContext context) {
    MediasBrain mediasBrain = Provider.of<MediasBrain>(context);

    return Builder(builder: (context) {
      List<Widget> planoDeEnsinoList = [];

      try {
        var courses = mediasBrain.getCoursesList();

        for (var course in courses) {
          Widget mediasCard = FutureBuilder(
            future: mediasBrain.getMediasCardInfo(course),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return MediasCourseSelectionCard(
                  courseName: 'Carregando...',
                );
              }
              return MediasCourseSelectionCard(
                courseName: snapshot.data['course_name'],
                mediaMateria: GeneralFunctionsBrain.formatMediaToText(
                    snapshot.data['media']),
                onTap: () {
                  mediasBrain.setupCurrentScreen(course);
                  Navigator.pushNamed(context, CalculoDeMediasScreen.id);

                  Provider.of<PlanoDeEnsinoBrain>(context).selectedCourse =
                      course;
                },
                mediaDiferenteMauaNet: snapshot.data['mediaDiferenteMauaNet'],
//                planoDeEnsinoNaoExiste:
//                    mediasBrain.planoDeEnsinoNaoExisteParaMateria(
//                  curso: course,
//                ),
                planoDeEnsinoState: mediasBrain.allPlanosDeEnsinoStates[course],
              );
            },
          );

          planoDeEnsinoList.add(mediasCard);
        }
      } catch (e) {
        print('-------- ERRO (refreshAbaMedias): $e --------');
        planoDeEnsinoList.clear();
        planoDeEnsinoList.add(
          Column(
            children: <Widget>[
              SizedBox(
                height: 80.0,
              ),
              Icon(
                Icons.warning,
                size: 120.0,
                color: Colors.yellow,
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Ocorreu um erro no carregamento desta aba.',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Erro: $e',
                  style: TextStyle(fontSize: 15.0, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: planoDeEnsinoList +
            <Widget>[
              Visibility(
                visible: planoDeEnsinoList.length == 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 180.0),
                  child: PlanoDeEnsinoNotLoaded(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    visible: mediasBrain.mediaGeralDiferenteDoMauaNet,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 0.0),
                          child: Text(
                            '* Nota não é igual à do MAUAnet.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: planoDeEnsinoList.length != 0,
                    child: PlanoDeEnsinoInfo(),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ImagelessButton(
                            title: 'Acessar o MAUAnet',
                            cardColor: Colors.blue[900],
                            onTap: () {
                              GeneralFunctionsBrain.openURL(
                                  'https://www2.maua.br/mauanet.2.0');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: ImagelessButton(
                            title: 'Estatísticas',
                            cardColor: Colors.redAccent[200],
                            onTap: () {
                              Navigator.pushNamed(
                                  context, EstatisticasScreen.id);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ImagelessButton(
                      title: 'Recuperar notas já baixadas',
                      cardColor: Color(0xFFAAAAAA),
                      textColor: (Provider.of<NetworkBrain>(context)
                                  .lastDownloadedInfoMauaNet !=
                              null)
                          ? Color(0xFFFFFFFF)
                          : Color(0xAAFFFFFF),
                      onTap: (Provider.of<NetworkBrain>(context)
                                  .lastDownloadedInfoMauaNet !=
                              null)
                          ? () async {
                              await Provider.of<MediasBrain>(context)
                                  .setupDisciplinaDatas(
                                      Provider.of<NetworkBrain>(context)
                                          .lastDownloadedInfoMauaNet
                                          .planoDeEnsino);

                              for (String curso
                                  in Provider.of<MediasBrain>(context)
                                      .getCoursesList()) {
                                Provider.of<PlanoDeEnsinoBrain>(context)
                                    .setupPlanoDeEnsinoEditor(
                                  course: curso,
                                  avaliacoesSemClassificacao:
                                      Provider.of<MediasBrain>(context)
                                          .avaliacoesSemClassificacao(
                                              course: curso),
                                );
                              }

                              setState(() {});
                              try {} catch (e) {
                                print('ERRO em mediasScrollArea: $e');
                              }
                            }
                          : null,
                    ),
                  ],
                ),
              )
            ],
      );
    });
  }
}

class PlanoDeEnsinoNotLoaded extends StatelessWidget {
  const PlanoDeEnsinoNotLoaded({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.cloud_download,
          size: 70.0,
          color: Colors.grey[800],
        ),
        Text(
          'O plano de ensino não foi carregado.\nArraste para baixo para carregá-lo.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[700],
          ),
        )
      ],
    );
  }
}
