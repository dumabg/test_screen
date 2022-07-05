import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MultiPlatformScreen extends StatefulWidget {
  const MultiPlatformScreen({Key? key}) : super(key: key);

  @override
  State<MultiPlatformScreen> createState() => _MultiPlatformScreenState();
}

class _MultiPlatformScreenState extends State<MultiPlatformScreen> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;
    return Scaffold(      
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title_multiplatform),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Text(platform.toString()),
          SizedBox(
            width: 200,
            child: platform == TargetPlatform.android ?
    Slider(
            value: _currentSliderValue,
            max: 100,
            divisions: 5,
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
    ) :
            CupertinoSlider(
                    value: _currentSliderValue,
            max: 100,
            divisions: 5,
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
            ),
          ),
        ],
      )
    );
  }
}
