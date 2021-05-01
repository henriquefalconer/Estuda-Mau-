import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:estuda_maua/widgets/selection_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplicacaoPlanoDeEnsinoScreen extends StatelessWidget {
  static String id = 'explicacao_plano_de_ensino_screen';

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
                            'Como o Estuda Mauá não tem acesso direto aos dados dos planos de ensino, torna-se necessário o preenchimento manual dos pesos e das quantidades de avaliações das disciplinas. Assim, com a organização em mente, classificou-se as matérias em tais grupos:',
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
                                  Icons.check_circle,
                                  color: Colors.green[700],
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    'Plano de ensino verificado pelo Estuda Mauá. Com quase total certeza este plano de ensino estará montado corretamente. Em caso de erros, basta reportar o problema para o e-mail estudamaua@gmail.com.',
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
                                  Icons.check_circle,
                                  color: Colors.yellow[700],
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    'Plano de ensino montado por usuário. Este plano de ensino poderá não estar montado corretamente. Em caso de erros, modifique os dados na aba com o símbolo de documento dentro da tela da matéria.',
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
                                  Icons.remove_circle,
                                  color: Colors.red[600],
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Text(
                                    'Plano de ensino vazio. Não temos informações sobre essa matéria. Se possível, preencha os dados na aba com o símbolo de documento dentro da tela da matéria.',
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
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 60.0,
                                  child: Switch(
                                    activeColor: Colors.blue[800],
                                    inactiveThumbColor: Colors.grey[200],
                                    inactiveTrackColor: Colors.grey,
                                    value: Provider.of<MediasBrain>(context)
                                        .mostrarNovamentePlanoDeEnsinoMontadoPorUsuario,
                                    onChanged: (value) {
                                      Provider.of<MediasBrain>(context)
                                          .changeMostrarNovamentePlanoDeEnsinoMontadoPorUsuario();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Text(
                                    'Mostrar avisos de plano de ensino montado por usuário',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                              ],
                            ),
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
