// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_scale_export/app_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:fl_chart/fl_chart.dart';

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
      length: 3, // The number of tabs
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Weekly'),
              Tab(text: 'Monthly'),
              Tab(text: 'Yearly'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Offstage(
              offstage: false,
              child: Center(
                child: RepaintBoundary(
                  key: _globalKeyWeekly,
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
              ),
            ),
            Offstage(
              offstage: false,
              child: Center(
                child: RepaintBoundary(
                  key: _globalKeyMonthly,
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
              ),
            ),
            Offstage(
              offstage: false,
              child: Center(
                child: RepaintBoundary(
                  key: _globalKeyYearly,
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
                              FlSpot(
                                  (context.watch<app_provider>().getWeight), 3),
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
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => printDoc(),
          child: Icon(Icons.print),
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
