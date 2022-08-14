import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;
  Answer(this.selectHandler, this.answerText);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: MaterialButton(
        color: Color.fromARGB(255, 255, 255, 255),
        onPressed: selectHandler,
        textColor: Color.fromARGB(255, 0, 0, 0),
        child: Text(
          answerText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
