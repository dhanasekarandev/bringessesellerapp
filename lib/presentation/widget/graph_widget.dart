
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesGraph extends StatefulWidget {
  const SalesGraph({Key? key}) : super(key: key);

  @override
  State<SalesGraph> createState() => _SalesGraphState();
}

class _SalesGraphState extends State<SalesGraph> {
  bool isWeekly = true;

  final List<double> weeklyData = [8, 6, 9, 7, 10, 12, 11];
  final List<double> monthlyData = [45, 60, 55, 70, 65, 90, 80, 95, 100, 85, 60, 75];

  final List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final data = isWeekly ? weeklyData : monthlyData;

    return Container(
      height: 300.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, 
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
        
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text("Weekly"),
                selected: isWeekly,
                onSelected: (_) => setState(() => isWeekly = true),
              ),
              SizedBox(width: 10.w),
              ChoiceChip(
                label: const Text("Monthly"),
                selected: !isWeekly,
                onSelected: (_) => setState(() => isWeekly = false),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // 📈 Chart
          Expanded(
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) {
                        if (isWeekly) {
                          if (value.toInt() >= 0 && value.toInt() < weekDays.length) {
                            return Text(
                              weekDays[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        } else {
                          return Text(
                            '${value.toInt() + 1}',
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                  ),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                      (i) => FlSpot(i.toDouble(), data[i]),
                    ),
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blueAccent.withOpacity(0.2),
                    ),
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
