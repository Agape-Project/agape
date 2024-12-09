import 'package:agape/common/controllers/record_controller.dart';
import 'package:agape/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardStats extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsyncValue = ref.watch(statsProvider);

    return statsAsyncValue.when(
      data: (stats) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {},
            ),
            backgroundColor: Colors.deepPurple,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: width > 600 ? 4 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: width > 600 ? 3 / 2 : 2 / 2.3,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          DashboardCard(
                            icon: Icons.people,
                            count: stats['disability']?['total_records']
                                    ?.toString() ??
                                '0',
                            label: "Total Records",
                            color: Colors.green,
                          ),
                          DashboardCard(
                            icon: Icons.wheelchair_pickup,
                            count: stats['disability']['equipments']
                                .values
                                .reduce((sum, val) => sum + val)
                                .toString(),
                            label: "Total Wheelchair",
                            color: Colors.green,
                          ),
                          DashboardCard(
                            icon: Icons.group,
                            count: stats['users']?['sub_admins']?.toString() ??
                                '0',
                            label: "Sub Admins",
                            color: Colors.green,
                          ),
                          DashboardCard(
                            icon: Icons.admin_panel_settings,
                            count: stats['users']?['admins']?.toString() ?? '0',
                            label: "Admin",
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ChartSection(
                          title: "Gender Distribution",
                          chartWidget: PieChartWidget1(
                            maleCount: stats['disability']?['num_of_males']?.toDouble() ?? '0',
                            femaleCount: stats['disability']?['num_of_females']?.toDouble() ?? '0',
                          ),
                          legendItems: [
                            {
                              'color': pieOne,
                              'label': 'Male',
                              'value':
                                  stats['disability']?['num_of_males']?.toDouble() ?? '0',
                            },
                            {
                              'color': pieTwo,
                              'label': 'Female',
                              'value': stats['disability']?['num_of_females']?.toDouble() ?? '0',
                            },
                          ]),
                      ChartSection(
                        title: "Equipment type",
                        chartWidget: BarChartWidget(),
                        legendItems: const [
                          {
                            'color': Colors.blue,
                            'label': 'Pedatric Wheelchair',
                            'value': 10
                          },
                          {
                            'color': Color.fromARGB(255, 2, 5, 2),
                            'label': 'American Wheelchair',
                            'value': 5
                          },
                          {
                            'color': Colors.red,
                            'label': '(FWP) WheelChair',
                            'value': 15
                          },
                          {
                            'color': Colors.orange,
                            'label': 'Walker',
                            'value': 12
                          },
                          {
                            'color': Colors.purple,
                            'label': 'Crutches',
                            'value': 8
                          },
                          {
                            'color': Colors.blueGrey,
                            'label': 'Cane',
                            'value': 9
                          }
                        ],
                      ),
                      ChartSection(
                        title: "Approval Status",
                        chartWidget: PieChartWidget2(
                            apporovedCount: stats['disability']?
                                    ['approved_records']
                                ?.toDouble() ?? '0',
                            pendingCount: stats['disability']?
                                    ['unapproved_records']
                                ?.toDouble() ?? '0'),
                        legendItems: [
                          {
                            'color': pieThree,
                            'label': 'Approved',
                            'value': stats['disability']?['approved_records']
                              ?.toDouble() ?? '0',
                          },
                          {
                            'color': pieFour,
                            'label': 'Pending',
                            'value': stats['disability']?['unapproved_records']
                              ?.toDouble() ?? '0',
                          },
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final Color color;

  const DashboardCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                count,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final List<Map<String, dynamic>> indicators;

  const Legend({required this.indicators});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: indicators.map((indicator) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: indicator['color'],
            ),
            const SizedBox(width: 4),
            Text(
              indicator['label'],
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 4),
            Text(
              "(${indicator['value']})",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class ChartSection extends StatelessWidget {
  final String title;
  final Widget chartWidget;
  final List<Map<String, dynamic>> legendItems;

  const ChartSection({
    required this.title,
    required this.chartWidget,
    required this.legendItems,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: isSmallScreen ? 1 : 3,
                  child: SizedBox(height: 200, child: chartWidget),
                ),
                if (!isSmallScreen)
                  const SizedBox(width: 16), // Spacing between chart and legend
                if (!isSmallScreen)
                  Expanded(
                    flex: 1,
                    child: Legend(indicators: legendItems),
                  ),
              ],
            ),
            if (isSmallScreen)
              const SizedBox(height: 16), // Spacing before the legend
            if (isSmallScreen) Legend(indicators: legendItems),
          ],
        ),
      ),
    );
  }
}

class PieChartWidget1 extends StatelessWidget {
  final double maleCount;
  final double femaleCount;

  PieChartWidget1({required this.maleCount, required this.femaleCount});

  @override
  Widget build(BuildContext context) {
    double total = maleCount + femaleCount;
    double malePercentage = (maleCount / total) * 100;
    double femalePercentage = (femaleCount / total) * 100;

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: pieOne,
            value: malePercentage,
            title: "${malePercentage.toStringAsFixed(0)}%",
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          PieChartSectionData(
            color: pieTwo,
            value: femalePercentage,
            title: "${femalePercentage.toStringAsFixed(0)}%",
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class PieChartWidget2 extends StatelessWidget {
  final double apporovedCount;
  final double pendingCount;
  PieChartWidget2({required this.apporovedCount, required this.pendingCount});
  @override
  Widget build(BuildContext context) {
    double tot = apporovedCount + pendingCount;
    double approvedPercentage = (apporovedCount / tot) * 100;
    double pendingPercentage = (pendingCount / tot) * 100;

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: pieThree,
            value: approvedPercentage,
            title: "${approvedPercentage.toStringAsFixed(0)}%",
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          PieChartSectionData(
            color: pieFour,
            value: pendingPercentage,
            title: "${pendingPercentage.toStringAsFixed(0)}%",
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartHeight = constraints.maxHeight * 0.7;
        double chartWidth = constraints.maxWidth * 0.9;

        return Center(
          child: SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  border: const Border(
                    left: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text(
                      'Count',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    axisNameSize: 20,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(),
                            style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text(
                      'Equipment Types',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    axisNameSize: 20,
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1:
                            return const Text("PW",
                                style: TextStyle(fontSize: 12));
                          case 2:
                            return const Text("AW",
                                style: TextStyle(fontSize: 12));
                          case 3:
                            return const Text("FWP",
                                style: TextStyle(fontSize: 12));
                          case 4:
                            return const Text("Wk",
                                style: TextStyle(fontSize: 12));
                          case 5:
                            return const Text("Cr",
                                style: TextStyle(fontSize: 12));
                          case 6:
                            return const Text("Cane",
                                style: TextStyle(fontSize: 12));
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: 10, color: Colors.blue)],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [BarChartRodData(toY: 5, color: Colors.green)],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [BarChartRodData(toY: 15, color: Colors.red)],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [BarChartRodData(toY: 12, color: Colors.orange)],
                  ),
                  BarChartGroupData(
                    x: 5,
                    barRods: [BarChartRodData(toY: 8, color: Colors.purple)],
                  ),
                  BarChartGroupData(x: 6, barRods: [
                    BarChartRodData(toY: 9, color: Colors.blueGrey)
                  ])
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
