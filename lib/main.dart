import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smart_scale_export/monthly_tabs.dart';
import 'package:smart_scale_export/weekly_tabs.dart';
import 'package:smart_scale_export/app_provider.dart';
import 'package:smart_scale_export/yearly_tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app_provider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const tab_view(),
      ),
    );
  }
}

class tab_view extends StatefulWidget {
  const tab_view({super.key});

  @override
  State<tab_view> createState() => _tab_viewState();
}

class _tab_viewState extends State<tab_view> {
  final GlobalKey _globalKeyWeekly = GlobalKey();
  final GlobalKey _globalKeyMonthly = GlobalKey();
  final GlobalKey _globalKeyYearly = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('PDF Export', style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Container(
                  child: const Text(
                    'Weekly',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: const Text(
                    'Monthly',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: const Text(
                    'Yearly',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            weeklyTabs(),
            monthlyTabs(),
            yearlyTabs(),
          ],
        ),
      ),
    );
  }

  weeklyTabs() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            indicatorWeight: 6.0,
            indicatorColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.monitor_weight_outlined,
                  color: Colors.blue,
                ),
                child: Text(
                  'Weight',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.favorite_outline,
                  color: Colors.blue,
                ),
                child: Text(
                  'BMI',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.auto_graph,
                  color: Colors.blue,
                ),
                child: Text(
                  'Calorie',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 100,
                    minY: 0,
                    maxY: 100,
                    backgroundColor: Colors.black,
                    lineTouchData: const LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipMargin: 10,
                      ),
                      handleBuiltInTouches: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 3),
                          const FlSpot(33, 64),
                          const FlSpot(53, 39),
                          const FlSpot(68, 74),
                          const FlSpot(95, 11),
                        ],
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 100,
                    minY: 0,
                    maxY: 100,
                    backgroundColor: Colors.black,
                    lineTouchData: const LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipMargin: 10,
                      ),
                      handleBuiltInTouches: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 3),
                          const FlSpot(33, 64),
                          const FlSpot(53, 39),
                          const FlSpot(68, 74),
                          const FlSpot(95, 11),
                        ],
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 100,
                    minY: context.watch<app_provider>().getWeight,
                    maxY: 50,
                    backgroundColor: Colors.black,
                    lineTouchData: const LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipMargin: 10,
                      ),
                      handleBuiltInTouches: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot((context.watch<app_provider>().getWeight), 3),
                          const FlSpot(15, 30),
                          const FlSpot(95, 15),
                          const FlSpot(35, 40),
                          const FlSpot(50, 45),
                        ],
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WeeklyTabs(
                  title: 'Widget to PDF',
                ),
              ),
            );
          },
          child: const Icon(Icons.print),
        ),
      ),
    );
  }

  monthlyTabs() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            indicatorWeight: 6.0,
            indicatorColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.monitor_weight_outlined,
                  color: Colors.blue,
                ),
                child: Text(
                  'Weight',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.favorite_outline,
                  color: Colors.blue,
                ),
                child: Text(
                  'BMI',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.auto_graph,
                  color: Colors.blue,
                ),
                child: Text(
                  'Calorie',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 100,
                    minY: 0,
                    maxY: 100,
                    backgroundColor: Colors.black,
                    lineTouchData: const LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipMargin: 10,
                      ),
                      handleBuiltInTouches: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 3),
                          const FlSpot(33, 64),
                          const FlSpot(53, 39),
                          const FlSpot(68, 74),
                          const FlSpot(95, 11),
                        ],
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 100,
                    minY: 0,
                    maxY: 100,
                    backgroundColor: Colors.black,
                    lineTouchData: const LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipMargin: 10,
                      ),
                      handleBuiltInTouches: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 3),
                          const FlSpot(33, 64),
                          const FlSpot(53, 39),
                          const FlSpot(68, 74),
                          const FlSpot(95, 11),
                        ],
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 100,
                    minY: context.watch<app_provider>().getWeight,
                    maxY: 50,
                    backgroundColor: Colors.black,
                    lineTouchData: const LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        tooltipMargin: 10,
                      ),
                      handleBuiltInTouches: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot((context.watch<app_provider>().getWeight), 3),
                          const FlSpot(15, 30),
                          const FlSpot(95, 15),
                          const FlSpot(35, 40),
                          const FlSpot(50, 45),
                        ],
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MonthlyTabs(
                  title: 'Widget to PDF',
                ),
              ),
            );
          },
          child: const Icon(Icons.print),
        ),
      ),
    );
  }

  yearlyTabs() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            indicatorWeight: 6.0,
            indicatorColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.monitor_weight_outlined,
                  color: Colors.blue,
                ),
                child: Text(
                  'Weight',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.favorite_outline,
                  color: Colors.blue,
                ),
                child: Text(
                  'BMI',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.auto_graph,
                  color: Colors.blue,
                ),
                child: Text(
                  'Calorie',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: Colors.red,
                        value: 10,
                        title: 'Carb',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: 20,
                        title: 'Protein',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 30,
                        title: 'Vitamin',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        color: Colors.yellow,
                        value: 40,
                        title: 'Oil',
                        radius: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: Colors.red,
                        value: 25,
                        title: 'Carb',
                        radius: 25,
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: 5,
                        title: 'Protein',
                        radius: 35,
                      ),
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 25,
                        title: 'Vitamin',
                        radius: 10,
                      ),
                      PieChartSectionData(
                        color: Colors.yellow,
                        value: 45,
                        title: 'Oil',
                        radius: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width / 1.1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: Colors.red,
                        value: 10,
                        title: 'Carb',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: 10,
                        title: 'Protein',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 35,
                        title: 'Vitamin',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        color: Colors.yellow,
                        value: 95,
                        title: 'Oil',
                        radius: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const YearlyTabs(
                  title: 'Widget to PDF',
                ),
              ),
            );
          },
          child: const Icon(Icons.print),
        ),
      ),
    );
  }

  Future<pw.Document> getPDF() async {
    ui.Image imageWeekly = await _captureImage(_globalKeyWeekly);
    ui.Image imageMonthly = await _captureImage(_globalKeyMonthly);
    ui.Image imageYearly = await _captureImage(_globalKeyYearly);

    final pngBytesWeekly = await _imageToPngBytes(imageWeekly);
    final pngBytesMonthly = await _imageToPngBytes(imageMonthly);
    final pngBytesYearly = await _imageToPngBytes(imageYearly);

    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Weekly Chart'),
              pw.Image(pw.MemoryImage(pngBytesWeekly)),
              pw.SizedBox(height: 20),
              pw.Text('Monthly Chart'),
              pw.Image(pw.MemoryImage(pngBytesMonthly)),
              pw.SizedBox(height: 20),
              pw.Text('Yearly Chart'),
              pw.Image(pw.MemoryImage(pngBytesYearly)),
            ],
          );
        }));

    return doc;
  }

  Future<void> printDoc() async {
    final doc = await getPDF();
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<ui.Image> _captureImage(GlobalKey key) async {
    if (key.currentContext != null) {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      return await boundary.toImage();
    } else {
      throw Exception('Key is not attached to an element in the tree.');
    }
  }

  Future<Uint8List> _imageToPngBytes(ui.Image image) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
