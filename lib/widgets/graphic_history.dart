import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../configs/app_settings.dart';
import '../models/coin.dart';
import '../repositories/coin.repository.dart';

class GraphicHistory extends StatefulWidget {
  final Coin coin;
  const GraphicHistory({Key? key, required this.coin}) : super(key: key);

  @override
  _GraficHistoryState createState() => _GraficHistoryState();
}

enum Period { time, day, week, month, year, total }

class _GraficHistoryState extends State<GraphicHistory> {
  List<Color> colors = [
    const Color(0xFF3F51B5),
  ];
  Period period = Period.time;
  List<Map<String, dynamic>> history = [];
  List completeData = [];
  List<FlSpot> graphicData = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;
  ValueNotifier<bool> loaded = ValueNotifier(false);
  late CoinRepository repository;
  late Map<String, String> loc;
  late NumberFormat real;

  setData() async {
    loaded.value = false;
    graphicData = [];

    if (history.isEmpty) history = await repository.getCoinHistory(widget.coin);

    completeData = history[period.index]['prices'];
    completeData = completeData.reversed.map((item) {
      double price = double.parse(item[0]);
      int time = int.parse(item[1].toString() + '000');
      return [price, DateTime.fromMillisecondsSinceEpoch(time)];
    }).toList();

    maxX = completeData.length.toDouble();
    maxY = 0;
    minY = double.infinity;

    for (var item in completeData) {
      maxY = item[0] > maxY ? item[0] : maxY;
      minY = item[0] < minY ? item[0] : minY;
    }

    for (int i = 0; i < completeData.length; i++) {
      graphicData.add(FlSpot(
        i.toDouble(),
        completeData[i][0],
      ));
    }
    loaded.value = true;
  }

  LineChartData getChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: graphicData,
          isCurved: true,
          colors: colors,
          barWidth: 2,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            colors: colors.map((color) => color.withOpacity(0.15)).toList(),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: const Color(0xFF343434),
          getTooltipItems: (data) {
            return data.map((item) {
              final date = getDate(item.spotIndex);
              return LineTooltipItem(
                real.format(item.y),
                const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: '\n $date',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(.5),
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  getDate(int index) {
    DateTime date = completeData[index][1];
    if (period != Period.year && period != Period.total)
      return DateFormat('dd/MM - hh:mm').format(date);
    else
      return DateFormat('dd/MM/y').format(date);
  }

  chartButton(Period p, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        onPressed: () => setState(() => period = p),
        child: Text(label),
        style: (period != p)
            ? ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.grey),
              )
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.indigo[50]),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    repository = context.read<CoinRepository>();
    loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    setData();

    return Container(
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  chartButton(Period.time, '1H'),
                  chartButton(Period.day, '24H'),
                  chartButton(Period.week, '7D'),
                  chartButton(Period.month, 'Month'),
                  chartButton(Period.year, 'Year'),
                  chartButton(Period.total, 'Total'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ValueListenableBuilder(
                valueListenable: loaded,
                builder: (context, bool isLoaded, _) {
                  return (isLoaded)
                      ? LineChart(
                          getChartData(),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
