import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:smart_scale_export/app_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui' as ui;
import 'package:fl_chart/fl_chart.dart';
// ignore: unused_import
import 'package:smart_scale_export/main.dart';

class WeeklyTabs extends StatefulWidget {
  const WeeklyTabs({super.key, required this.title});

  final String title;

  @override
  State<WeeklyTabs> createState() => _WeeklyTabsState();
}

class _WeeklyTabsState extends State<WeeklyTabs> {
  final GlobalKey _globalKeyWeekly = GlobalKey();
  final GlobalKey _globalKeyMonthly = GlobalKey();
  final GlobalKey _globalKeyYearly = GlobalKey();

  @override
  void initState() {
    super.initState();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('PDF is being created'),
    //     ),
    //   );
    //   Future.delayed(const Duration(milliseconds: 200), () {
    //     printDoc();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              RepaintBoundary(
                key: _globalKeyWeekly,
                child: SizedBox(
                  height: 200,
                  width: 350,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 100,
                      minY: 0,
                      maxY: 100,
                      backgroundColor: Colors.black,
                      lineTouchData: const LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
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
              const SizedBox(
                height: 30,
              ),
              RepaintBoundary(
                key: _globalKeyMonthly,
                child: SizedBox(
                  height: 200,
                  width: 350,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 100,
                      minY: 0,
                      maxY: 100,
                      backgroundColor: Colors.black,
                      lineTouchData: const LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
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
              const SizedBox(
                height: 30,
              ),
              RepaintBoundary(
                key: _globalKeyYearly,
                child: SizedBox(
                  height: 200,
                  width: 350,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 100,
                      minY: context.watch<app_provider>().getWeight,
                      maxY: 50,
                      backgroundColor: Colors.black,
                      lineTouchData: const LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
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
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => printDoc(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Text('Save To PDF'),
              ),
              // ElevatedButton(
              //   onPressed: () => {
              //     context.read<app_provider>().setWeight(10.0),
              //   },
              //   child: const Text("change weight"),
              // ),
              ElevatedButton(
                onPressed: () async {
                  final path = await shareDoc();
                  await Share.shareFiles([path],
                      mimeTypes: ['application/pdf']);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Text('Share PDF'),
              ),
              // const SizedBox(
              //   height: 50,
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const tab_view(),
              //       ),
              //     );
              //   },
              //   child: const Text('Tab View'),
              // ),
            ],
          ),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TabView(),
      ),
    );
  }

  Future<String> shareDoc() async {
    final doc = await getPDF();
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/ExportedData.pdf");
    await file.writeAsBytes(await doc.save());

    return file.path;
  }

  Future<ui.Image> _captureImage(GlobalKey key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    return await boundary.toImage();
  }

  Future<Uint8List> _imageToPngBytes(ui.Image image) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
