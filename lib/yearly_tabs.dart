import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:smart_scale_export/main.dart';

class YearlyTabs extends StatefulWidget {
  const YearlyTabs({super.key, required this.title});

  final String title;

  @override
  State<YearlyTabs> createState() => _YearlyTabsState();
}

class _YearlyTabsState extends State<YearlyTabs> {
  final GlobalKey _globalKeyWeekly = GlobalKey();
  final GlobalKey _globalKeyMonthly = GlobalKey();
  final GlobalKey _globalKeyYearly = GlobalKey();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF is being created'),
        ),
      );
      Future.delayed(const Duration(milliseconds: 200), () {
        printDoc();
      });
    });
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
              const SizedBox(
                height: 30,
              ),
              RepaintBoundary(
                key: _globalKeyMonthly,
                child: SizedBox(
                  height: 200,
                  width: 350,
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
              const SizedBox(
                height: 30,
              ),
              RepaintBoundary(
                key: _globalKeyYearly,
                child: SizedBox(
                  height: 200,
                  width: 350,
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
              // const SizedBox(
              //   height: 50,
              // ),
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
      MaterialPageRoute(builder: (context) => const tab_view()),
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
