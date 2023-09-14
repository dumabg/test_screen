import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_screen_sample/screens/multi_platform/multi_platform_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

    @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        actions: [IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MultiPlatformScreen())),)],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.message,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            if (_counter == 3) 
              const Icon(Icons.check, color: Colors.green, size: 42,)
          ],
        ),
      ),      
      floatingActionButton: _counter < 3 ? FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ) : null, 
    );
  }
}
