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
                      legendItems: const [
                        {'color': pieOne, 'label': 'Male', 'value': 56},
                        {'color': pieTwo, 'label': 'Female', 'value': 44},
                      ]),
                  ChartSection(
                    title: "Size Distribution",
                    chartWidget: BarChartWidget(),
                    legendItems: const [
                      {'color': Colors.blue, 'label': 'Pedatric Wheelchair', 'value': 10},
                      {'color': Color.fromARGB(255, 2, 5, 2), 'label': 'American Wheelchair',  'value': 5},
                      {'color': Colors.red, 'label': '(FWP) WheelChair', 'value': 15},
                      {'color': Colors.orange, 'label': 'Walker', 'value': 12},
                      {'color': Colors.purple, 'label': 'Crutches', 'value': 8},
                      {'color': Colors.blueGrey, 'label': 'Cane', 'value': 9}
                    ],
                  ),
                  ChartSection(
                    title: "Approval Status",
                    chartWidget: PieChartWidget2(),
                    legendItems: const [
                      {'color': pieThree, 'label': 'Approved',  'value': 56},
                      {'color': pieFour, 'label': 'Pending',  'value': 44},
                    ],
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
              "(${indicator['value']}%)",
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
                            return const Text("Pedatric",
                                style: TextStyle(fontSize: 12));
                          case 2:
                            return const Text("American",
                                style: TextStyle(fontSize: 12));
                          case 3:
                            return const Text("FWP",
                                style: TextStyle(fontSize: 12));
                          case 4:
                            return const Text("Walker",
                                style: TextStyle(fontSize: 12));
                          case 5:
                            return const Text("Crutches",
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
                  BarChartGroupData(x: 6,
                  barRods: [BarChartRodData(toY: 9, color: Colors.blueGrey)])
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
