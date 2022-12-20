import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isweb_test/isweb_test.dart';

class MultiPlatformScreen extends StatefulWidget {
  const MultiPlatformScreen({Key? key}) : super(key: key);

  @override
  State<MultiPlatformScreen> createState() => _MultiPlatformScreenState();
}

class _MultiPlatformScreenState extends State<MultiPlatformScreen> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.title_multiplatform),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(width: 200, child: _slider(context)),
          ],
        ));
  }

  Widget _slider(BuildContext context) {
    if (isWeb()) {
      return _webSlider();
    } else {
      final platform = Theme.of(context).platform;
      return platform == TargetPlatform.iOS
          ? _cupertinoSlider()
          : _defaultSlider();
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
