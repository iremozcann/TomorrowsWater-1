import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:suyumuz/anasayfa.dart';
import 'package:suyumuz/main.dart';
import 'package:suyumuz/model/model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DataPage extends StatelessWidget {
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
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
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
        body: Column(
          children: [
            FirebaseAnimatedList(
              shrinkWrap: true,
              query: databaseReference,
              itemBuilder: (BuildContext? context, DataSnapshot snapshot,
                      Animation animation, int index) =>
                  Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context!).size.height * 0.09,
                  ),
                  Center(
                    child: Container(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title:
                            ChartTitle(text: 'Annual Water Consumption Table'),
                        legend: Legend(isVisible: false),
                        tooltipBehavior: _tooltipBehavior,
                        series: <LineSeries<ConsumptionAmount, String>>[
                          LineSeries<ConsumptionAmount, String>(
                              dataSource: <ConsumptionAmount>[
                                ConsumptionAmount(
                                    'Jan', snapshot.value['ocak']),
                                ConsumptionAmount(
                                    'Feb', snapshot.value['subat']),
                                ConsumptionAmount(
                                    'Mar', snapshot.value['mart']),
                                ConsumptionAmount(
                                    'Apr', snapshot.value['nisan']),
                                ConsumptionAmount(
                                    'May', snapshot.value['mayis']),
                                ConsumptionAmount(
                                    'Jun', snapshot.value['haziran']),
                                ConsumptionAmount(
                                    'Jul', snapshot.value['temmuz']),
                                ConsumptionAmount(
                                    'Aug', snapshot.value['agus']),
                                ConsumptionAmount(
                                    'Sep', snapshot.value['eylul']),
                                ConsumptionAmount(
                                    'Oct', snapshot.value['ekim']),
                                ConsumptionAmount(
                                    'Nov', snapshot.value['kasim']),
                                ConsumptionAmount(
                                    'Dec', snapshot.value['aralik']),
                              ],
                              xValueMapper: (ConsumptionAmount sales, _) =>
                                  sales.year,
                              yValueMapper: (ConsumptionAmount sales, _) =>
                                  sales.amount,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
