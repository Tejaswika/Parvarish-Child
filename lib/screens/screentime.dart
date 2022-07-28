import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueGrey[800]),
        )),
      ),
      home: TimeScreen()));
}

class TimeScreen extends StatefulWidget {
  TimeScreen({Key? key}) : super(key: key);

  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('Sunday', 10),
      _ChartData('Monday', 20),
      _ChartData('Tuesday', 30),
      _ChartData('Wednesday', 5),
      _ChartData('Thursday', 20),
      _ChartData('Friday', 10),
      _ChartData('Saturday', 30),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Screen Time'),
        ),
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Wrap(
                  runSpacing: 5.0,
                  spacing: 10.0,
                  children: [
                    Container(
                        child: RichText(
                      text: TextSpan(
                        children: const <TextSpan>[
                          TextSpan(
                              text: '3hrs 8mins \n',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 0, 0, 0))),
                          TextSpan(
                              text: 'Today \n',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 190, 190, 190))),
                        ],
                      ),
                    )),
                    Container(
                      height: 200,
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(
                              minimum: 0,
                              maximum: 50,
                              interval: 10,
                              isVisible: false),
                          tooltipBehavior: _tooltip,
                          series: <ChartSeries<_ChartData, String>>[
                            BarSeries<_ChartData, String>(
                                dataSource: data,
                                isTrackVisible: false,
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y,
                                name: ' ',
                                color: Color.fromRGBO(8, 142, 255, 1))
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.arrow_back),
                        Container(
                          width: 5.0,
                          height: 0,
                        ),
                        Text(
                          'Sunday,17 July',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.0, fontFamily: 'Times'),
                        ),
                        Container(
                          width: 5.0,
                          height: 0,
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.video_call),
                            title: Text('YouTube'),
                          ),
                          ListTile(
                            leading: Icon(Icons.chat),
                            title: Text('WhatsApp'),
                          ),
                          ListTile(
                            leading: Icon(Icons.tiktok_outlined),
                            title: Text('Tiktok'),
                          ),
                          ListTile(
                            leading: Icon(Icons.music_note),
                            title: Text('Music'),
                          ),
                          ListTile(
                            leading: Icon(Icons.snapchat),
                            title: Text('SnapChat'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
