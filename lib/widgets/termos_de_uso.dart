import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PoliticaDePrivacidade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      child: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Política de privacidade',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Todas as suas informações pessoais recolhidas serão usadas com o intuito de tornar o uso deste aplicativo a mais produtiva e agradável possível. A garantia da confidencialidade dos dados pessoais dos utilizadores do aplicativo é importante para a organização Estuda Mauá. Todas as informações pessoais relativas a membros que utilizem nosso aplicativo serão tratadas em concordância com a Lei da Proteção de Dados Pessoais de 26 de outubro de 1998 (Lei n.º 67/98). As informações pessoas que são recolhidas pelo Estuda Mauá obtidas pelo MAUAnet incluem: nome completo, registro de aluno, período, curso, série de ensino e disciplinas que cursa. Além desses, aramzena-se dados obtidos pela interação do usuário com o app, tais como monitorias de que o aluno participa, mensagens de texto e imagens trocadas por meio do aplicativo, notas e médias caso o usuário concorde com a divulgação das mesmas aos nossos servidores. A equipe do Estuda Mauá em nenhum momento armazenará em seus servidores a senha que o usuário utiliza para acesso ao MAUAnet, sendo esta apenas utilizada localmente no aparelho do usuário. O uso do Estuda Mauá pressupõe a aceitação deste acordo de privacidade.',
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
