## 3.2.2
* TestScreenConfig loadTestFont improved, loads from file or rootBundle.
* TestScreen testFailure improved.

## 3.2.1
* Bug: Font loader doesn't load MaterialIcons font.
  
## 3.2.0
* Added onMatchesGoldenFinder to testScreen and testScreenUI.

## 3.1.0
* Support for fonts when the project is a library.
* Bug: Async error when the widget has a Future.delayed.

## 3.0.0
* Upgrade to Flutter 3.
* New testscreen extension for Visual Studio Code.
* Added excludeTablets constructor param in AndroidFirebaseTestLab and IosFirebaseTestLab. Allow to exclude devices with with greater than height. True by default.
* Updated documentation.

## 2.0.1
* Bug: If goldenDir on testScreenUI has subdirectories, the result golden file was created in an incorrect subdirectories structure.

## 2.0.0
* UITargetPlatform has incorporated to this package and isn't used anymore for detect web environments on the application code. TargetPlatform on TestScreenConfig must be changed to UITargetPlatform.
* Using the new package isweb_test. It defines the global variable debugIsWeb and the function isWeb. The global variable debugIsWeb is used in this package for simulating the web environment.
* Adding web support for every platform. UITargetPlatform has the new enum values webAndroid, webFuchsia, webIos, webLinux, webMacOS and webWindows.
* wrapWidget function. Wraps a widget with the wrapper configured on initializeDefaultTestScreenConfig.

## 1.1.1
* Bug: DateFormat always formatted in english.

## 1.1.0
* Add testing for web applications.

## 1.0.1
* Resolve pub score warnings.

## 1.0.0
* Devices definitions loaded from Firebase Test Lab.
* Documentation.
* Example.
  
## 0.2.3
* Beta version.
