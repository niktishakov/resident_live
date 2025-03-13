// Create a test widget to monitor background task execution
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resident_live/features/workmanager/workmanager.service.dart';
import 'package:resident_live/shared/shared.dart';
import 'package:share_plus/share_plus.dart';

class BackgroundTaskTestWidget extends StatefulWidget {
  @override
  State<BackgroundTaskTestWidget> createState() =>
      _BackgroundTaskTestWidgetState();
}

class _BackgroundTaskTestWidgetState extends State<BackgroundTaskTestWidget> {
  String _lastExecutionTime = 'Not executed yet';
  Timer? _checkTimer;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  Future<void> _startMonitoring() async {
    _checkTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/background_task_log.txt');
      if (await file.exists()) {
        final content = await file.readAsString();
        final lines = content.split('\n');
        if (lines.isNotEmpty) {
          setState(() {
            _lastExecutionTime = lines.last;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Last background task execution: $_lastExecutionTime'),
        ElevatedButton(
          onPressed: () async {
            final logs = AiLogger.logFile;
            await Share.shareXFiles([XFile(logs.path)]);
          },
          child: Text('Check Logs'),
        ),
        ElevatedButton(
          onPressed: () async {
            await AiLogger.logFile.writeAsString('');
            ToastService.instance.showToast(context, message: "Logs Cleared");
          },
          child: Text('CLEAR Logs'),
        ),
        ElevatedButton(
          onPressed: () async {
            await WorkmanagerService.scheduleBackgroundTask();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Background task scheduled')),
            );
          },
          child: Text('Schedule Background Task'),
        ),
        ElevatedButton(
          onPressed: () async {
            await WorkmanagerService.cancelAllTasks();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('All tasks cancelled')),
            );
          },
          child: Text('Cancel All Tasks'),
        ),
      ],
    );
  }
}
