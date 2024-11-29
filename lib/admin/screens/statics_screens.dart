import 'package:agape/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    children: const [
                      DashboardCard(
                        icon: Icons.people,
                        count: "255",
                        label: "Total Records",
                        color: Colors.green,
                      ),
                      DashboardCard(
                        icon: Icons.wheelchair_pickup,
                        count: "185",
                        label: "Total Wheelchair",
                        color: Colors.green,
                      ),
                      DashboardCard(
                        icon: Icons.group,
                        count: "5",
                        label: "Sub Admins",
                        color: Colors.green,
                      ),
                      DashboardCard(
                        icon: Icons.admin_panel_settings,
                        count: "1",
                        label: "Admin",
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ChartSection(
                    title: "Gender Distribution",
                    chartWidget: PieChartWidget1(),
                  ),
                  ChartSection(
                    title: "Size Distribution",
                    chartWidget: BarChartWidget(),
                  ),
                 ChartSection(
                    title: "Approval Status",
                    chartWidget: PieChartWidget2(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
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

class ChartSection extends StatelessWidget {
  final String title;
  final Widget chartWidget;

  const ChartSection({
    required this.title,
    required this.chartWidget,
  });

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 200,
              child: chartWidget,
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartWidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: pieOne,
            value: 56,
            title: "56%",
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          PieChartSectionData(
            color: pieTwo,
            value: 44,
            title: "44%",
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class PieChartWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: pieThree,
            value: 56,
            title: "56%",
            radius: 50,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          PieChartSectionData(
            color: pieFour,
            value: 44,
            title: "44%",
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                      'Wheelchair Types',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    axisNameSize: 20, 
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1:
                            return const Text('Children',
                                style: TextStyle(fontSize: 12));
                          case 2:
                            return const Text('Small',
                                style: TextStyle(fontSize: 12));
                          case 3:
                            return const Text('Medium',
                                style: TextStyle(fontSize: 12));
                          case 4:
                            return const Text('Large',
                                style: TextStyle(fontSize: 12));
                          case 5:
                            return const Text('XL',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}