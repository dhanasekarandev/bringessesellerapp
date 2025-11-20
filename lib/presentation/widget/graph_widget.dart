import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/revenue_graph_cubit.dart';
import 'package:bringessesellerapp/presentation/screen/dashboard/bloc/revenue_graph_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesGraph extends StatefulWidget {
  const SalesGraph({Key? key}) : super(key: key);

  @override
  State<SalesGraph> createState() => _SalesGraphState();
}

class _SalesGraphState extends State<SalesGraph> {
  bool isWeekly = true;

  final List<String> weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  @override
  void initState() {
    super.initState();
    loadGraph();
  }

  void loadGraph() {
    context.read<RevenueGraphCubit>().login(); // load data from API / Cubit
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RevenueGraphCubit, RevenueGraphState>(
      listener: (context, state) {},
      builder: (context, state) {
// Use model data if available, else fallback to empty
        final dashboardData = state.revenueGraphResModel;
        final List<double> weeklyData = dashboardData?.revenueGraph?.week
                ?.map((e) => e.amount?.toDouble() ?? 0)
                .toList() ??
            List.filled(7, 0); // fallback 0 for 7 days
        final List<double> monthlyData = dashboardData?.revenueGraph?.month
                ?.map((e) => e.amount?.toDouble() ?? 0)
                .toList() ??
            List.filled(31, 0); // fallback 0 for 31 days

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
                              if (value.toInt() >= 0 &&
                                  value.toInt() < weekDays.length) {
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
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 32),
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
      },
    );
  }
}
