## 2.0.0
* UITargetPlatform has incorporated to this package and isn't used anymore for detect web environments on the application code. TargetPlatform on TestScreenConfig must be changed to UITargetPlatform.
* Using the new package isweb_test. It defines the global variable debugIsWeb and the function isWeb. The global variable debugIsWeb is used in this package for simulating the web environment.
* Adding web support for every platform. UITargetPlatform has the new enum values webAndroid, webFuchsia, webIos, webLinux, webMacOS and webWindows.
* wrapWidget function. Wraps a widget with the wrapper configured on initializeDefaultTestScreenConfig.

## 1.1.1
* Bug: DateFormat always formatted in english.

## 1.1.0
* Add testing for web applications

## 1.0.1
* Resolve pub score warnings

## 1.0.0
* Devices definitions loaded from Firebase Test Lab
* Documentation
* Example
  
## 0.2.3
* Beta version
