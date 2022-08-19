import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final int QuizLength;
  final VoidCallback resetQuizHandler;
  Result(this.resultScore, this.resetQuizHandler, this.QuizLength);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Wrap(
              runSpacing: 5.0,
              spacing: 20.0,
              children: [
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'Quiz Analysis \n',
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                        ],
                      ),
                    )),
                Container(
                    padding: const EdgeInsets.only(top: 60, bottom: 40),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0), width: 3),
                      color: Color.fromARGB(54, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(54, 1, 29, 74),
                                    width: 3),
                                color: Color.fromARGB(54, 108, 147, 188),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: new EdgeInsets.all(5.0),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Correct\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 45, 21, 21))),
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text:
                                            ((resultScore).toInt()).toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(54, 1, 29, 74),
                                    width: 3),
                                color: Color.fromARGB(54, 108, 147, 188),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: new EdgeInsets.all(5.0),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Incorrect\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text:
                                            ((QuizLength - resultScore).toInt())
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(54, 1, 29, 74),
                                    width: 3),
                                color: Color.fromARGB(54, 108, 147, 188),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: new EdgeInsets.all(5.0),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Percentage\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: 'Scored',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 15, 6, 6))),
                                    TextSpan(
                                        text:
                                            (((resultScore / QuizLength) * 100)
                                                    .toInt())
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: ("%"),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 100.0,
                              width: 130.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(54, 1, 29, 74),
                                    width: 3),
                                color: Color.fromARGB(54, 108, 147, 188),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              alignment: Alignment.center,
                              padding: new EdgeInsets.all(5.0),
                              margin:
                                  new EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Total\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 55, 17, 17))),
                                    TextSpan(
                                        text: 'Questions',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    TextSpan(
                                        text: ((QuizLength).toInt()).toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: (((resultScore / QuizLength) * 100 >= 60)
                              ? Text("Passed")
                              : Text("Failed")),
                        ),
                      ],
                    )),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(15),
                  child: ElevatedButton(
                    child: (((resultScore / QuizLength) * 100 >= 60)
                        ? Text("Enjoy")
                        : Text("Re-Test")),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 155, 173, 240),
                      //onPrimary: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
