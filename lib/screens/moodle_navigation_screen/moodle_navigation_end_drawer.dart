import 'package:estuda_maua/utilities/moodle_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodleNavigationEndDrawer extends StatelessWidget {
  final List<String> abasList = [
    'Boas vindas',
    '1º Bimestre',
    '2º Bimestre',
    '3º Bimestre',
    '4º Bimestre',
    'Plano de Ensino',
    'Atendimento de Professores',
    'Programa de Apoio',
    'Revisão de Provas',
    'Gabaritos de Provas',
    'Corpo Docente',
    'Disciplinas Semipresenciais 2020',
    'Preparação para as Provas PS2',
    'Painel do curso',
  ];

  @override
  Widget build(BuildContext context) {
    final moodleBrain = Provider.of<MoodleBrain>(context);
    return Container(
      height: double.infinity,
      width: 250.0,
      color: Colors.grey[100],
      child: SafeArea(
        child: ListView.builder(
          itemCount: abasList.length,
          itemBuilder: (context, index) {
            List<Widget> abasElement = [
              SelecaoAbaMoodle(
                nome: abasList[index],
                onTap: () {
                  moodleBrain.changeSelectedPage(abasList[index]);
                  Navigator.pop(context);
                },
              ),
            ];

            if (index == 0) {
              abasElement.insert(
                0,
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Conteúdo',
                    style: TextStyle(
                      fontSize: 33.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: abasElement,
              ),
            );
          },
        ),
      ),
    );
  }
}

class SelecaoAbaMoodle extends StatelessWidget {
  SelecaoAbaMoodle({@required this.nome, @required this.onTap});

  final String nome;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.0,
      ),
      child: InkWell(
        onTap: onTap,
        child: Text(
          nome ?? '',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 21.0,
          ),
        ),
      ),
    );
  }
}
