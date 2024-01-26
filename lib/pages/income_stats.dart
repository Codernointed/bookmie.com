import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalesStatsPage extends StatefulWidget {
  final String accessToken;

  const SalesStatsPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _SalesStatsPageState createState() => _SalesStatsPageState();
}

class _SalesStatsPageState extends State<SalesStatsPage> {
  List<String> years = [];
  List<double> amounts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://ethenatx.pythonanywhere.com/management/sales-stats/',
        ),
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        data.forEach((key, value) {
          years.insert(0, key); // Insert at the beginning to reverse the order
          amounts.add(value.toDouble());
        });
        print(response.body);
        setState(() {}); // Update the UI with the fetched data
      } else {
        // Handle error cases
        print('Failed to fetch data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Sales Stats',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF59B15),
            fontSize: 21,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF59B15)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            margin: EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 16,
                      getTitlesWidget: (value, titleMeta) {
                        // Add the `titleMeta` argument
                        return Text(years[value
                            .toInt()]); // Use only the `value` for the year
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(width: 1.0),
                    bottom: BorderSide(width: 1.0),
                  ),
                ),
                minX: 0,
                maxX: years.length.toDouble() - 1,
                minY: 0,
                maxY: amounts.isNotEmpty
                    ? amounts
                            .reduce((curr, next) => curr > next ? curr : next) +
                        20000
                    : 20000,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      years.length,
                      (index) => FlSpot(index.toDouble(), amounts[index]),
                    ),
                    isCurved: true,
                    color: Color(0xFFF59B15),
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: true),
                    preventCurveOverShooting: true,
                    barWidth: 5,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Key Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          _buildSummarySection(),
          SizedBox(height: 20),
          Text(
            'Additional Sales Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: years.length,
              itemBuilder: (context, index) {
                final year = years[index];
                final amount = amounts[index];
                return ListTile(
                  title: Text('Year: $year'),
                  subtitle: Text('Amount: GH₵${amount.toString()}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    double totalAmount = amounts.fold(0, (sum, data) => sum + data);
    double averageAmount = totalAmount / amounts.length;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 25),
      child: Column(
        children: [
          _buildSummaryItem('Total Sales', 'GH₵ ${totalAmount.toString()}'),
          _buildSummaryItem(
              'Average Sales', 'GH₵ ${averageAmount.toStringAsFixed(2)}'),
          // Add more summary items as needed
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }
}
