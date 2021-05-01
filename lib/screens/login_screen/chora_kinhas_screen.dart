import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class ChoraKinhasScreen extends StatelessWidget {
  static String id = 'chora_kinhas_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'Todos sabemos da natureza de Kinhas... Você pode até tentar tampar seus ouvidos, mas, mesmo assim, seu choro alcaçará, em um tom inconfundível. É com muito orgulho que a ChoraKinhas apresenta-lhes: Kinhas, o chorão mais amado da Mauá.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 70.0,
                ),
                Column(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 70.0,
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 70.0,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 70.0,
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: CircleAvatar(
                radius: 90.0,
                backgroundImage: AssetImage('images/chora_kinhas.png'),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 20.0,
              ),
              child: RoundedButton(
                onTap: () {
                  Navigator.pop(context);
                },
                buttonText: 'Retornar ao login',
                textColor: Colors.blue[900],
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
