import 'package:community_material_icon/community_material_icon.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:estuda_maua/widgets/selection_button.dart';
import 'package:estuda_maua/widgets/termos_de_uso.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplicacaoTelefoneMonitoriaOnline extends StatelessWidget {
  static String id = 'explicacao_telefone';

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
                            'A monitoria online do Estuda Mauá possibilita dois modos de contato entre o monitor e o aluno:',
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
                                Icon(
                                  Icons.chat,
                                  size: 25.0,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    'Contato pelo sistema interno de comunicações. Através deste meio, é possível enviar mensagens de texto e fotos. Não é necessário fornecer seu número de telefone para utilizar este sistema.',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  CommunityMaterialIcons.whatsapp,
                                  size: 25.0,
                                  color: Colors.green[600],
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    'Contato por WhatsApp. Através deste meio, é possível utilizar funcionalidades que não existem no sistema interno de comunicação, como mensagens de voz, envio de vídeos e ligações. Para tais funcionalidades, é necessário que o monitor forneça seu número de telefone.',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'A Estuda Mauá tem a segurança dos seus dados em mente e não os divulgará a qualquer indivíduo. Para mais informações, leia nossa política de privacidade:',
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            color: Colors.white,
                            height: 300.0,
                            width: 350.0,
                            child: PoliticaDePrivacidade(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
