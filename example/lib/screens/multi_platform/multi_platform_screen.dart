import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ui_target_platform/ui_target_platform.dart';

class MultiPlatformScreen extends StatefulWidget {
  const MultiPlatformScreen({Key? key}) : super(key: key);

  @override
  State<MultiPlatformScreen> createState() => _MultiPlatformScreenState();
}

class _MultiPlatformScreenState extends State<MultiPlatformScreen> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    final platform =
        UITargetPlatform.fromTargetPlatform(Theme.of(context).platform);
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.title_multiplatform),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(platform.toString()),
            SizedBox(width: 200, child: _slider(platform)),
          ],
        ));
  }

  StatefulWidget _slider(UITargetPlatform platform) {
    switch (platform) {
      case UITargetPlatform.iOS:
        return _cupertinoSlider();
      case UITargetPlatform.web:
        return _webSlider();
      default:
        return _defaultSlider();
    }
  }

  Slider _defaultSlider() {
    return Slider(
      value: _currentSliderValue,
      max: 100,
      divisions: 5,
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  Slider _webSlider() {
    return Slider(
      value: _currentSliderValue,
      max: 100,
      divisions: 5,
      inactiveColor: Colors.orange,
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  CupertinoSlider _cupertinoSlider() {
    return CupertinoSlider(
      value: _currentSliderValue,
      max: 100,
      divisions: 5,
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}
