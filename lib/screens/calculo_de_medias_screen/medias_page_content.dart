import 'package:estuda_maua/screens/plano_de_ensino_viewer_screen/plano_de_ensino_viewer_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/widgets/notas_card.dart';
import 'package:estuda_maua/widgets/notas_sliders_column.dart';
import 'package:estuda_maua/widgets/warning_sign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediasPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediasBrain mediasBrain = Provider.of<MediasBrain>(context);
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 90.0,
        ),
        NotasCard(
          title:
              'Média ${mediasBrain.tipoDeMediaSelecionado == TiposDeCalculoMedia.final_ ? 'Final' : 'Parcial'} Total',
          sliderlessColors: true,
          media: mediasBrain.calcularMediaMateria(),
          textColor: Colors.white,
          redText: Colors.redAccent[400],
          mediaDiferenteMauaNet: mediasBrain.mediaMateriaDiferenteDoMauaNet(),
        ),
        Visibility(
          visible: mediasBrain.showPlanoDeEnsinoWarning,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: {
                    PlanoDeEnsinoState.vazio: WarningSign(
                      backgroundColor: Colors.red[400],
                      icon: Icons.remove_circle,
                      iconColor: Colors.redAccent[700],
                      textColor: Color(0xFF222222),
                      text:
                          'O plano de ensino desta matéria ainda não foi incorporado ao nosso sistema. Caso queira, clique na flecha a seguir e preencha as informações do plano de ensino.',
                    ),
                    PlanoDeEnsinoState.naoVerificado: WarningSign(
                      icon: Icons.check_circle,
                      iconColor: Colors.yellow[700],
                      backgroundColor: Colors.yellow[400],
                      textColor: Color(0xFF333333),
                      text:
                          'O plano de ensino desta matéria foi montado por um usuário. Caso algo pareça errado ou haja alguma avaliação sem classificação, clique na flecha a seguir e modifique as informações do plano de ensino.',
                      showLink: true,
                      linkOnTap: () {
                        mediasBrain
                            .changeMostrarNovamentePlanoDeEnsinoMontadoPorUsuario();
                      },
                    ),
                  }[mediasBrain.allPlanosDeEnsinoStates[
                      mediasBrain.currentScreenCourse]],
                ),
                IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, PlanoDeEnsinoViewerScreen.id);
                  },
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: mediasBrain
                  .getProvasNotasSlidersMap()[kTipoAvaliacao.provas]
                  .length !=
              0,
          child: NotasCard(
            title: 'Provas',
            backgroundColor: Colors.blue[800],
            textColor: Colors.white,
            mediaText:
                'Média ${mediasBrain.tipoDeMediaSelecionado == TiposDeCalculoMedia.final_ ? 'Final' : 'Parcial'}: ',
            mainChild: MediasScrollersColumn(
                mediasBrain.getProvasNotasSlidersMap(), kTipoAvaliacao.provas),
            sliderlessColors: false,
            media: mediasBrain.calcularMediaProvasMateria(),
            pesoMedia:
                mediasBrain.getPesoProvasOuTrabalhos(kTipoAvaliacao.provas),
            mediaDiferenteMauaNet: mediasBrain.mediaProvasDiferenteDoMauaNet(),
          ),
        ),
        Visibility(
          visible: mediasBrain
                  .getTrabalhosNotasSlidersMap()[kTipoAvaliacao.trabalhos]
                  .length !=
              0,
          child: NotasCard(
            title: 'Trabalhos',
            backgroundColor: Colors.blue[800],
            textColor: Colors.white,
            mediaText:
                'Média ${mediasBrain.tipoDeMediaSelecionado == TiposDeCalculoMedia.final_ ? 'Final' : 'Parcial'}: ',
            mainChild: MediasScrollersColumn(
                mediasBrain.getTrabalhosNotasSlidersMap(),
                kTipoAvaliacao.trabalhos),
            sliderlessColors: false,
            media: mediasBrain.calcularMediaTrabalhosMateria(),
            pesoMedia:
                mediasBrain.getPesoProvasOuTrabalhos(kTipoAvaliacao.trabalhos),
            mediaDiferenteMauaNet:
                mediasBrain.mediaTrabalhosDiferenteDoMauaNet(),
          ),
        ),
        Visibility(
          visible: mediasBrain
                  .getIndefinidosNotasSlidersMap()[
                      kTipoAvaliacao.semClassificacao]
                  .length !=
              0,
          child: NotasCard(
            title: 'Sem classificação',
            backgroundColor: Colors.blue[800],
            textColor: Colors.white,
            mediaText:
                'Média ${mediasBrain.tipoDeMediaSelecionado == TiposDeCalculoMedia.final_ ? 'Final' : 'Parcial'}: ',
            mainChild: MediasScrollersColumn(
                mediasBrain.getIndefinidosNotasSlidersMap(),
                kTipoAvaliacao.semClassificacao),
            sliderlessColors: false,
            showMedia: false,
          ),
        ),
        mediasBrain.mediaMateriaDiferenteDoMauaNet()
            ? Padding(
                padding: EdgeInsets.only(left: 15.0, top: 6.0),
                child: Text(
                  '* Nota não é igual à do MAUAnet.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              )
            : SizedBox(),
//        (mediasBrain.algumaMateriaNaoPossuiPlanoDeEnsino
//            ? Padding(
//                padding: EdgeInsets.only(left: 15.0, top: 6.0),
//                child: Row(
//                  children: <Widget>[
//                    Text(
//                      '*',
//                      style: TextStyle(color: Colors.red[400]),
//                    ),
//                    Text(
//                      ' Plano de ensino não incorporado.',
//                      style: TextStyle(color: Colors.grey[700]),
//                    ),
//                  ],
//                ),
//              )
//            : SizedBox()),
        SizedBox(
          height: 14.0,
        ),
      ],
    );
  }
}
