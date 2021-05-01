import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/widgets/monitor_type_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplicacaoMonitorVerificadoScreen extends StatelessWidget {
  static String id = 'explicacao_monitor_verificado_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BlandTopArea(
              title: 'Mais informações',
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Ao se inscrever no aplicativo do Estuda Mauá, '
                          'um usuário pode escolher quaisquer de 3 cursos para tornar-se monitor. '
                          'Como medida de verificação, foi instituído um sistema no qual '
                          'professores coordenadores de curso '
                          'verificam se o aluno é ou não um monitor oficial da Mauá. Assim, os monitores passam a ser classificados com um dos seguintes grupos:',
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              MonitorTypeIcon(
                                type: MonitorType.oficial,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Monitor oficial da Mauá. Este, após ser registrado '
                                  'no sistema do aplicativo, foi reconhecido pelo '
                                  'professor coordenador como oficial. Este deve possuir '
                                  'a maior capacidade de ajuda com matérias.',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              MonitorTypeIcon(
                                type: MonitorType.aguardandoOficializacao,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Monitor aguardando oficialização. Este foi registrado '
                                  'no sistema do aplicativo, porém ainda não foi '
                                  'reconhecido pelo professor coordenador do'
                                  ' curso correspondente. Deste modo, pode '
                                  'não possuir o mesmo conhecimento de um '
                                  'monitor oficial, e sim de um extra-oficial.',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              MonitorTypeIcon(
                                type: MonitorType.extraOficial,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Monitor extra-oficial do Estuda Mauá. '
                                  'Este, após ser registrado no sistema do aplicativo, '
                                  'pode ter se auto-intitulado como extra-oficial, ou pode ter '
                                  'sido rejeitado '
                                  'pelo professor coordenador do curso '
                                  'como um monitor oficial da Mauá. '
                                  'Este pode não possuir o mesmo conhecimento de um '
                                  'monitor oficial, mas ainda assim pode cumprir seu papel.',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
