import 'package:battery_level/services/battery_level_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryLevelScreen extends StatefulWidget {
  const BatteryLevelScreen({Key? key}) : super(key: key);

  @override
  State<BatteryLevelScreen> createState() => _BatteryLevelScreenState();
}

class _BatteryLevelScreenState extends State<BatteryLevelScreen> {
  final _batteryLevelNotifier = ValueNotifier<BatteryLevelResponse?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Level'),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _getBatteryLevelButton(),
          const SizedBox(height: 50),
          const Spacer(flex: 2),
          ValueListenableBuilder<BatteryLevelResponse?>(
            valueListenable: _batteryLevelNotifier,
            builder: (_, response, child) {
              return _batteryLevelIndicator(response);
            },
          ),
          const Spacer(
            flex: 3,
          )
        ],
      ),
    );
  }

  Widget _getBatteryLevelButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final response = await BatteryLevelService.getBatteryLevel();
          _batteryLevelNotifier.value = response;
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: const Size(300, 50),
        ),
        child: const Text('Check Battery Level'),
      ),
    );
  }

  Widget _batteryLevelIndicator(BatteryLevelResponse? response) {
    const borderColor = Colors.black54;
    final level = response?.value ?? 0;
    return Center(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _batteryProgressBar(level),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          '$level%',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(-1, 0),
                child: Container(
                  height: 20,
                  width: 13,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ],
          ),
          if (response?.error != null) ...[
            const SizedBox(height: 10),
            Text(
              response!.error!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget _batteryProgressBar(int level) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final levelWidth = constraint.maxWidth * level / 100;

        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            height: constraint.maxHeight,
            width: levelWidth,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _getLevelColor(level),
            ),
          ),
        );
      },
    );
  }

  Color _getLevelColor(int level) {
    if (level <= 20) {
      return Colors.red;
    }
    if (level <= 50) {
      return Colors.orange.withOpacity(.8);
    }

    return Colors.green.withOpacity(.8);
  }
}
