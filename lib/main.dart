import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _appUsageList = [];

  @override
  void initState() {
    super.initState();
    _trackAppUsage();
  }
  void _trackAppUsage() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(hours: 1)); // Track usage for the last 1 hour

    List result =
    await UsageStats.queryUsageStats(startDate.millisecondsSinceEpoch as DateTime, endDate.millisecondsSinceEpoch as DateTime);

    setState(() {
      _appUsageList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Tracker'),
      ),
      body: ListView.builder(
        itemCount: _appUsageList.length,
        itemBuilder: (context, index) {
          final appUsageInfo = _appUsageList[index];
          return ListTile(
            leading: const Icon(Icons.apps),
            title: Text(appUsageInfo.packageName),
            subtitle: Text('Usage time: ${appUsageInfo.usage.inMinutes} minutes'),
          );
        },
      ),
    );
  }
}
