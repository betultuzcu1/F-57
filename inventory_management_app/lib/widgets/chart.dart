import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_app/service/firebase_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class TodayChart extends StatefulWidget {
  const TodayChart({Key? key}) : super(key: key);

  static const routeName = 'todayChart';

  @override
  State<TodayChart> createState() => _TodayChartState();
}

class _TodayChartState extends State<TodayChart> {
  double totalQuantity = 0;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    DateTime todayDate = DateTime.now();
    return FutureBuilder(
      future: getTodayDateTotalItem(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.error != null) {
            return const Center(
              child: Text('An error occurred!'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              for (var docIndex in snapshot.data!.docs) {
                totalQuantity += double.parse(docIndex['productQuantity']);
              }
            }
          }
        }
        List<ChartData> getChartData() {
          final List<ChartData> chartData = [
            ChartData(DateFormat.EEEE().format(todayDate), totalQuantity),
          ];
          return chartData;
        }

        return SfCartesianChart(
          backgroundColor: Colors.white,
          title: ChartTitle(
              text: 'Today',
              alignment: ChartAlignment.center,
              textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
          series: <ChartSeries>[
            ColumnSeries<ChartData, String>(
              color: Colors.lightBlue.shade900,
              dataSource: getChartData(),
              xValueMapper: (ChartData data, _) => data.label,
              yValueMapper: (ChartData data, _) => data.totalQuantity,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              enableTooltip: true,
            ),
          ],
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
            isVisible: false,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          plotAreaBorderWidth: 0,
        );
      },
    );
  }
}

class ChartData {
  ChartData(
    this.label,
    this.totalQuantity,
  );

  final double totalQuantity;
  final String label;
}
