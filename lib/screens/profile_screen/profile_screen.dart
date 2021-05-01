import 'package:estuda_maua/screens/login_screen/login_screen.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_1.dart';
import 'package:estuda_maua/screens/profile_photo_full_screen/profile_photo_full_screen.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_7.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/profile_photo_full_screen_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/utilities/user_data_selection_brain.dart';
import 'package:estuda_maua/widgets/loading_full_screen.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:estuda_maua/widgets/warning_sign.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool recarregandoDadosUsuario = false;
  bool showWarningSign = false;

  @override
  Widget build(BuildContext context) {
    UserBrain userBrain = Provider.of<UserBrain>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(15.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: FlatButton(
                                  onPressed: () {
                                    Provider.of<ProfilePhotoFullScreenBrain>(
                                            context)
                                        .nome = userBrain.getUserName();
                                    Provider.of<ProfilePhotoFullScreenBrain>(
                                            context)
                                        .image = userBrain.getUserImage();
                                    Navigator.pushNamed(
                                        context, ProfilePhotoFullScreen.id);
                                  },
                                  child: Hero(
                                    tag: 'user_picture',
                                    child: CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: userBrain.getUserImage(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              userBrain.getUserName() ?? 'Carregando...',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 25.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 8.0,
                              width: double.infinity,
                            ),
                            Text(
                              userBrain.getFormattedCourseInfo() ??
                                  'Carregando...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ] +
                      (userBrain.getUserMonitorias() == null
                          ? <Widget>[]
                          : <Widget>[
                              Builder(
                                builder: (context) {
                                  List<Widget> listMonitorias = [
                                    Text(
                                      'Monitorias:',
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ];

                                  try {
                                    for (int index = 0;
                                        index <
                                            userBrain
                                                .getUserMonitorias()
                                                .length;
                                        index++) {
                                      listMonitorias.add(
                                        Text(
                                          '${userBrain.getUserMonitorias()[index] ?? 'Carregando...'}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    listMonitorias = [
                                      Text(
                                        'Erro ao carregar monitorias.',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ];
                                  }

                                  return Column(
                                    children: listMonitorias,
                                  );
                                },
                              ),
                            ]) +
                      <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'RA: ${userBrain.getUserRA() ?? 'Carregando...'}',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Visibility(
                              visible: (userBrain.getUserMonitorias() ?? [])
                                      .length !=
                                  0,
                              child: Text(
                                'Número registrado: ${userBrain.getUserNumber() ?? 'Carregando...'}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              'Instituição: ${userBrain.userInstitution ?? 'Carregando...'}',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            RoundedButton(
                              onTap: () async {
                                setState(() {
                                  recarregandoDadosUsuario = true;
                                });
                                try {
                                  List responses = await Future.wait([
                                    Provider.of<NetworkBrain>(context)
                                        .downloadInfoMauaNet(),
                                    Provider.of<NetworkBrain>(context)
                                        .downloadMateriasCursadas(),
                                  ]);

                                  InfoMauaNet infoMauaNet = responses.first;
                                  List<String> materiasCursadas =
                                      responses.last;

                                  print(responses);

                                  if (infoMauaNet != null &&
                                      materiasCursadas != null) {
                                    userBrain.userInfoMauaNet =
                                        infoMauaNet.infoUsuario;

                                    userBrain.userPlanoDeEnsinoMauaNet =
                                        infoMauaNet.planoDeEnsino;

                                    Provider.of<UserDataSelectionBrain>(context)
                                        .getMateriasCursadasEmAnosAnteriores(
                                      materiasUltimoAno: List.of(
                                          infoMauaNet.planoDeEnsino.keys),
                                      allMaterias: materiasCursadas,
                                    );

                                    Provider.of<UserDataSelectionBrain>(context)
                                        .reset();
                                    if (Provider.of<UserDataSelectionBrain>(
                                                context)
                                            .materiasCursadasEmAnosAnteriores
                                            .length !=
                                        0) {
                                      Navigator.pushNamed(
                                          context, UserDataSelectionScreen1.id);
                                    } else {
                                      Provider.of<UserDataSelectionBrain>(
                                              context)
                                          .monitoriasSelected = [];

                                      Navigator.pushNamed(
                                          context, UserDataSelectionScreen7.id);
                                    }
                                  }

                                  showWarningSign = false;
                                } catch (e) {
                                  if (e.toString() ==
                                      'ERRO em downloadPlanoDeEnsinoMauaNet: 500: dados não puderam ser obtidos.') {}
                                  showWarningSign = true;

                                  print(e);
                                }
                                setState(
                                  () {
                                    recarregandoDadosUsuario = false;
                                  },
                                );
                              },
                              buttonText: 'Atualizar dados de usuário',
                              backgroundColor: Colors.blue[600],
                            ),
                            showWarningSign
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: Container(
                                      width: 250.0,
                                      child: WarningSign(
                                        text:
                                            'Erro em obter dados.\nTente novamente.',
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 20.0,
                                  ),
                            RoundedButton(
                              onTap: () async {
                                Navigator.popUntil(context,
                                    ModalRoute.withName('login_screen'));
                                await Navigator.popAndPushNamed(
                                    context, LoginScreen.id);
                              },
                              buttonText: 'Sair da conta',
                              backgroundColor: Colors.red[500],
                            ),
                          ],
                        ),
                      ],
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                    ),
                  ),
                  alignment: AlignmentDirectional.topStart,
                ),
              ],
            ),
          ),
          Visibility(
            visible: recarregandoDadosUsuario,
            child: LoadingFullScreen(
              cancelButtonOnTap: () {
                setState(
                  () {
                    recarregandoDadosUsuario = false;
                    Provider.of<NetworkBrain>(context)
                        .cancelDownloadInfoMauaNet();
                    Provider.of<NetworkBrain>(context).cancelMateriasCursadas();
                  },
                );
              },
              loadTime: 70,
            ),
          )
        ],
      )),
    );
  }
}
