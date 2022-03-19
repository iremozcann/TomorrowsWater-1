import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:suyumuz/main.dart';
import 'package:suyumuz/model/model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF151026);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: MyHomePage(title: "Tomorrow's water"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final dref = FirebaseDatabase.instance.reference();
  late DatabaseReference databaseReference;
  showData() {
    dref.once().then((snapshot) {
      print(snapshot.value);
    });
  }

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    databaseReference = dref;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context!).size.height * 0.09),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 15, 0, 44),
            leading: IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                return runApp(MyApp());
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            title: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context!).size.height * 0.026,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: FirebaseAnimatedList(
          shrinkWrap: true,
          query: databaseReference,
          itemBuilder: (BuildContext? context, DataSnapshot snapshot,
                  Animation animation, int index) =>
              Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context!).size.height * 0.02,
              ),
              Center(
                child: Text(
                  snapshot.value['Anlikbaslik'].toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 175, 175, 175)),
                ),
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context!).size.height * 0.5,
                  width: MediaQuery.of(context!).size.width * 0.7,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(minimum: 0, maximum: 70, ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0, endValue: 20, color: Colors.blue),
                        GaugeRange(
                            startValue: 20, endValue: 40, color: Colors.green),
                        GaugeRange(
                            startValue: 40, endValue: 70, color: Colors.red)
                      ], pointers: <GaugePointer>[
                        NeedlePointer(
                          value: snapshot.value['Anlik'],
                          needleColor: Colors.black,
                        ),
                      ], annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                                child: Text(
                                    snapshot.value['Anlik'].round().toString() +
                                        "  L",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                            angle: 90,
                            positionFactor: 0.5)
                      ])
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context!).size.height * 0.1,
                    width: MediaQuery.of(context!).size.height * 0.23,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(69, 138, 129, 156),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0))),
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context!).size.height * 0.08,
                      width: MediaQuery.of(context!).size.height * 0.21,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 63, 0, 180),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.value['TuketimBaslik'].toString(),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context!).size.height * 0.015,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ((snapshot.value['Toplam'] / 1000) *
                                        snapshot.value['metrekupFiyati'])
                                    .round()
                                    .toString(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context!).size.height *
                                            0.015,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text(
                                snapshot.value['ParaBirim'].toString(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context!).size.height *
                                            0.015,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context!).size.height * 0.1,
                    width: MediaQuery.of(context!).size.height * 0.23,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(69, 138, 129, 156),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0))),
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context!).size.height * 0.08,
                      width: MediaQuery.of(context!).size.height * 0.21,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 63, 0, 180),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25.0),
                              bottomLeft: Radius.circular(25.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.value['Toplambaslik'].toString(),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context!).size.height * 0.015,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.value['Toplam'].toString(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context!).size.height *
                                            0.015,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              Text(
                                snapshot.value['Birim'].toString(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context!).size.height *
                                            0.015,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context!).size.height * 0.06,
              ),
              Center(
                child: Container(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'Annual Water Consumption Table'),
                    legend: Legend(isVisible: false),
                    tooltipBehavior: _tooltipBehavior,
                    series: <LineSeries<ConsumptionAmount, String>>[
                      LineSeries<ConsumptionAmount, String>(
                          dataSource: <ConsumptionAmount>[
                            ConsumptionAmount('Jan', snapshot.value['ocak']),
                            ConsumptionAmount('Feb', snapshot.value['subat']),
                            ConsumptionAmount('Mar', snapshot.value['mart']),
                            ConsumptionAmount('Apr', snapshot.value['nisan']),
                            ConsumptionAmount('May', snapshot.value['mayis']),
                            ConsumptionAmount('Jun', snapshot.value['haziran']),
                            ConsumptionAmount('Jul', snapshot.value['temmuz']),
                            ConsumptionAmount('Aug', snapshot.value['agus']),
                            ConsumptionAmount('Sep', snapshot.value['eylul']),
                            ConsumptionAmount('Oct', snapshot.value['ekim']),
                            ConsumptionAmount('Nov', snapshot.value['kasim']),
                            ConsumptionAmount('Dec', snapshot.value['aralik']),
                          ],
                          xValueMapper: (ConsumptionAmount sales, _) =>
                              sales.year,
                          yValueMapper: (ConsumptionAmount sales, _) =>
                              sales.amount,
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
