import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_management_app/screens/product_history.dart';
import 'package:inventory_management_app/screens/stock_in_product_history.dart';
import 'package:inventory_management_app/screens/stock_out_product_history.dart';
import 'package:inventory_management_app/widgets/color.dart';
import 'package:inventory_management_app/widgets/icon_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/chart.dart';
import '../widgets/chart2.dart';

enum HistoryMenu {
  historyStockOut,
  historyStockIn,
  historyProduct,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int touchedIndex = 0;
  double totalQuantity = 0.0;
  double totalPrice = 0.0;
  int totalItem = 0;
  final userId = FirebaseAuth.instance.currentUser;
  late TooltipBehavior _toolTipBehavior;

  @override
  void initState() {
    _toolTipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('products')
          .doc(userId!.uid)
          .collection('user_product_list')
          .get(),
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
                totalPrice += double.parse(docIndex['productPrice']);
                totalItem = snapshot.data!.size;
              }
            }
          }
        }
        List<GDPData> getChartData() {
          final List<GDPData> chartData = [
            GDPData('Total Quantity', totalQuantity, LightColor.bar2),
            GDPData('Total Price', totalPrice,  LightColor.bar3),
            GDPData(
                'Total Item', totalItem.toDouble(),  LightColor.bar1),
          ];
          return chartData;
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white70,
          extendBody: true,
          appBar: AppBar(
            toolbarHeight: 50,
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              PopupMenuButton(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children:  [
                      Padding(
                        padding: const EdgeInsets.only(right: 5, bottom: 15),
                        child: Icon(Icons.history, color: Colors.lightBlue.shade900, size: 22,),
                      ),
                      Text(
                        'History',
                        style: TextStyle(color: Colors.lightBlue.shade900, fontSize: 16),
                      ),

                    ],
                  ),
                ),
                onSelected: (HistoryMenu selectedValue) async {
                  setState(
                    () {
                      if (selectedValue == HistoryMenu.historyProduct) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductHistory(),
                          ),
                        );

                      }
                      if (selectedValue == HistoryMenu.historyStockIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StockInHistory(),
                          ),
                        );
                      }
                      if (selectedValue == HistoryMenu.historyStockOut) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StockOutHistory(),
                          ),
                        );
                      }
                    },
                  );
                },
                color: Colors.white,
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.boxOpen),
                      title: Text('Products History'),
                    ),
                    value: HistoryMenu.historyProduct,
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(
                        IconsData.boxPlus,
                        size: 30,
                      ),
                      title: Text('Stock-In History'),
                    ),
                    value: HistoryMenu.historyStockIn,
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(
                        IconsData.boxMinus,
                        size: 30,
                      ),
                      title: Text('Stock-Out History'),
                    ),
                    value: HistoryMenu.historyStockOut,
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              children: [
                SfCircularChart(
                  backgroundColor: Colors.white,
                  title: ChartTitle(
                    text: 'Brief of the inventory',
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  legend: Legend(
                      position: LegendPosition.bottom,
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  tooltipBehavior: _toolTipBehavior,
                  series: <CircularSeries>[
                    PieSeries<GDPData, String>(
                      pointColorMapper: (GDPData data, _) => data.color,
                      dataSource: getChartData(),
                      xValueMapper: (GDPData data, _) => data.continent,
                      yValueMapper: (GDPData data, _) => data.dgp,
                      radius: '%100',
                      dataLabelSettings: const DataLabelSettings(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.middle,
                      ),
                      enableTooltip: true,
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Daily total quantity.',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Flexible(child: YesterdayChart()),
                        Flexible(child: TodayChart()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GDPData {
  GDPData(this.continent, this.dgp, this.color);

  final String continent;
  final double dgp;
  final Color color;
}
