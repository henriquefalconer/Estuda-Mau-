import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/statistics_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/widgets/estatisticas_card.dart';
import 'package:estuda_maua/widgets/selection_button.dart';
import 'package:estuda_maua/widgets/table_notas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstatisticasScreen extends StatelessWidget {
  static String id = 'estatisticas_screen';

  @override
  Widget build(BuildContext context) {
    StatisticsBrain statisticsBrain = Provider.of<StatisticsBrain>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BlandTopArea(
              title: 'Estatísticas',
              showDivider: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 8.0,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SelectionButton(
                      onTap: () {
                        statisticsBrain
                            .changeRankingType(EstatisticasType.ranking);
                      },
                      buttonText: 'Ranking',
                      value: EstatisticasType.ranking,
                      groupValue: statisticsBrain.rankingType,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: SelectionButton(
                      onTap: () {
                        statisticsBrain
                            .changeRankingType(EstatisticasType.graficos);
                      },
                      buttonText: 'Gráficos',
                      value: EstatisticasType.graficos,
                      groupValue: statisticsBrain.rankingType,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                if (statisticsBrain.rankingType == EstatisticasType.graficos) {
                  return ListView(
                    children: <Widget>[
                      FutureBuilder(
                          future: statisticsBrain.getUserPosition(
                            Provider.of<UserBrain>(context).getUserRA(),
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return EstatisticasCard(
                                title: 'Carregando...',
                              );
                            }
                            return EstatisticasCard(
                              title: 'Posição na Mauá:',
                              value:
                                  '${snapshot.data}/${statisticsBrain.usersStatistics.length}',
                            );
                          }),
                      EstatisticasCard(
                        title:
                            'Posição em ${Provider.of<UserBrain>(context).getFormattedUserDescription()}:',
                        value: '2/102',
                      ),
                    ],
                  );
                } else {
                  return FutureBuilder(
                    future: Provider.of<StatisticsBrain>(context)
                        .getUsersStatisticsInfo(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.all(15.0),
                        child: TableNotas(),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
