import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_screen/src/test_screen_config.dart';

const String androidFirebaseTestLabData =
    '''┌─────────────────────┬────────────────────┬──────────────────────────────────────────┬──────────┬─────────────┬─────────────────────────┬───────────────┐
│       MODEL_ID      │        MAKE        │                MODEL_NAME                │   FORM   │  RESOLUTION │      OS_VERSION_IDS     │      TAGS     │
├─────────────────────┼────────────────────┼──────────────────────────────────────────┼──────────┼─────────────┼─────────────────────────┼───────────────┤
│ 1610                │ Vivo               │ vivo 1610                                │ [33;1mPHYSICAL[39;0m │ 1280 x 720  │ 23                      │               │
│ AOP_sprout          │ HMD Global         │ Nokia 9                                  │ [33;1mPHYSICAL[39;0m │ 2880 x 1440 │ 28                      │               │
│ ASUS_X00T_3         │ Asus               │ ASUS_X00TD                               │ [33;1mPHYSICAL[39;0m │ 1080 x 2160 │ 27,28                   │               │
│ AmatiTvEmulator     │ Google             │ Google TV Amati                          │ [32mEMULATOR[39;0m │ 1080 x 1920 │ 29                      │ beta=29       │
│ AndroidTablet270dpi │ Generic            │ Generic 720x1600 Android tablet @ 270dpi │ [34;1mVIRTUAL [39;0m │ 1600 x 720  │ 30                      │               │
│ F01L                │ FUJITSU            │ F-01L                                    │ [33;1mPHYSICAL[39;0m │ 1280 x 720  │ 27                      │               │
│ FRT                 │ HMD Global         │ Nokia 1                                  │ [33;1mPHYSICAL[39;0m │  854 x 480  │ 27                      │               │
│ G8142               │ Sony               │ G8142                                    │ [33;1mPHYSICAL[39;0m │ 1080 x 1920 │ 25                      │               │
│ G8342               │ Sony               │ G8342                                    │ [33;1mPHYSICAL[39;0m │ 1080 x 1920 │ 26                      │               │
│ G8441               │ Sony               │ G8441                                    │ [33;1mPHYSICAL[39;0m │  720 x 1280 │ 26                      │               │
│ GoogleTvEmulator    │ Google             │ Google TV                                │ [32mEMULATOR[39;0m │  720 x 1280 │ 30                      │ beta=30       │
│ H8216               │ Sony               │ H8216                                    │ [33;1mPHYSICAL[39;0m │ 2160 x 1080 │ 28                      │               │
│ H8314               │ Sony               │ H8314                                    │ [33;1mPHYSICAL[39;0m │ 1080 x 2160 │ 26                      │               │
│ H9493               │ Sony               │ H9493                                    │ [33;1mPHYSICAL[39;0m │ 2880 x 1440 │ 28                      │               │
│ HWANE-LX1           │ Huawei             │ ANE-LX1                                  │ [33;1mPHYSICAL[39;0m │ 1080 x 2280 │ 28                      │               │
│ HWANE-LX2           │ Huawei             │ ANE-LX2                                  │ [33;1mPHYSICAL[39;0m │ 1080 x 2280 │ 28                      │               │
│ HWCOR               │ Huawei             │ COR-L29                                  │ [33;1mPHYSICAL[39;0m │ 1080 x 2340 │ 27                      │               │
│ HWMHA               │ Huawei             │ MHA-L29                                  │ [33;1mPHYSICAL[39;0m │ 1920 x 1080 │ 24                      │               │
│ Nexus10             │ Samsung            │ Nexus 10                                 │ [34;1mVIRTUAL [39;0m │ 2560 x 1600 │ 19,21,22                │               │
│ Nexus4              │ LG                 │ Nexus 4                                  │ [34;1mVIRTUAL [39;0m │ 1280 x 768  │ 19,21,22                │               │
│ Nexus5              │ LG                 │ Nexus 5                                  │ [34;1mVIRTUAL [39;0m │ 1920 x 1080 │ 19,21,22,23             │               │
│ Nexus5X             │ LG                 │ Nexus 5X                                 │ [34;1mVIRTUAL [39;0m │ 1920 x 1080 │ 23,24,25,26             │               │
│ Nexus6              │ Motorola           │ Nexus 6                                  │ [34;1mVIRTUAL [39;0m │ 2560 x 1440 │ 21,22,23,24,25          │               │
│ Nexus6P             │ Google             │ Nexus 6P                                 │ [34;1mVIRTUAL [39;0m │ 2560 x 1440 │ 23,24,25,26,27          │               │
│ Nexus7              │ Asus               │ Nexus 7 (2012)                           │ [34;1mVIRTUAL [39;0m │ 1280 x 800  │ 19,21,22                │               │
│ Nexus7_clone_16_9   │ Generic            │ Nexus7 clone, DVD 16:9 aspect ratio      │ [34;1mVIRTUAL [39;0m │ 1280 x 720  │ 23,24,25,26             │ beta          │
│ Nexus9              │ HTC                │ Nexus 9                                  │ [34;1mVIRTUAL [39;0m │ 2048 x 1536 │ 21,22,23,24,25          │               │
│ NexusLowRes         │ Generic            │ Low-resolution MDPI phone                │ [34;1mVIRTUAL [39;0m │  640 x 360  │ 23,24,25,26,27,28,29,30 │               │
│ OnePlus5T           │ OnePlus            │ ONEPLUS A5010                            │ [33;1mPHYSICAL[39;0m │ 1080 x 2160 │ 28                      │               │
│ Pixel2              │ Google             │ Pixel 2                                  │ [34;1mVIRTUAL [39;0m │ 1920 x 1080 │ 26,27,28,29,30          │               │
│ Pixel3              │ Google             │ Pixel 3                                  │ [34;1mVIRTUAL [39;0m │ 2160 x 1080 │ 30                      │               │
│ SC-02K              │ Samsung            │ SC-02K                                   │ [33;1mPHYSICAL[39;0m │ 2220 x 1080 │ 28                      │               │
│ SH-01L              │ SHARP              │ SH-01L                                   │ [33;1mPHYSICAL[39;0m │ 2160 x 1080 │ 28                      │               │
│ SH-03K              │ SHARP              │ SH-03K                                   │ [33;1mPHYSICAL[39;0m │ 3040 x 1440 │ 28                      │               │
│ TC77                │ Zebra Technologies │ TC77                                     │ [33;1mPHYSICAL[39;0m │ 1280 x 720  │ 27                      │               │
│ a10                 │ Samsung            │ SM-A105FN                                │ [33;1mPHYSICAL[39;0m │  720 x 1520 │ 29                      │               │
│ b2q                 │ Samsung            │ SM-F711U1                                │ [33;1mPHYSICAL[39;0m │  260 x 512  │ 30                      │               │
│ blueline            │ Google             │ Pixel 3                                  │ [33;1mPHYSICAL[39;0m │ 2160 x 1080 │ 28                      │               │
│ cactus              │ Xiaomi             │ Redmi 6A                                 │ [33;1mPHYSICAL[39;0m │ 1440 x 720  │ 27                      │               │
│ cruiserlteatt       │ Samsung            │ SM-G892A                                 │ [33;1mPHYSICAL[39;0m │ 1080 x 2220 │ 26                      │               │
│ dreamlte            │ Samsung            │ SM-G950F                                 │ [33;1mPHYSICAL[39;0m │ 1080 x 2220 │ 28                      │               │
│ f2q                 │ Samsung            │ SM-F916U1                                │ [33;1mPHYSICAL[39;0m │ 2208 x 1768 │ 30                      │               │
│ flo                 │ Asus               │ Nexus 7                                  │ [33;1mPHYSICAL[39;0m │ 1200 x 1920 │ 19                      │               │
│ grandppltedx        │ Samsung            │ SM-G532G                                 │ [33;1mPHYSICAL[39;0m │  540 x 960  │ 23                      │               │
│ griffin             │ Motorola           │ XT1650                                   │ [33;1mPHYSICAL[39;0m │ 1440 x 2560 │ 24                      │               │
│ gts3lltevzw         │ Samsung            │ SM-T827V                                 │ [33;1mPHYSICAL[39;0m │ 1536 x 2048 │ 28                      │               │
│ gts4lltevzw         │ Samsung            │ SM-T837V                                 │ [33;1mPHYSICAL[39;0m │ 2560 x 1600 │ 28                      │               │
│ gts4lvwifi          │ Samsung            │ SM-T720                                  │ [33;1mPHYSICAL[39;0m │ 1600 x 2560 │ 28                      │               │
│ hammerhead          │ LG                 │ Nexus 5                                  │ [33;1mPHYSICAL[39;0m │ 1920 x 1080 │ 23                      │               │
│ harpia              │ Motorola           │ Moto G Play                              │ [33;1mPHYSICAL[39;0m │ 1280 x 720  │ 23                      │               │
│ heroqlteaio         │ Samsung            │ SAMSUNG-SM-G930AZ                        │ [33;1mPHYSICAL[39;0m │ 1080 x 1920 │ 26                      │               │
│ htc_ocmdugl         │ HTC                │ HTC U11 plus                             │ [33;1mPHYSICAL[39;0m │ 1440 x 2880 │ 26                      │ [31;1mdeprecated=26[39;0m │
│ htc_pmeuhl          │ HTC                │ HTC 10                                   │ [33;1mPHYSICAL[39;0m │ 1440 x 2560 │ 26                      │               │
│ hwALE-H             │ Huawei             │ ALE-L23                                  │ [33;1mPHYSICAL[39;0m │ 1280 x 720  │ 21                      │               │
│ j7popltevzw         │ Samsung            │ SM-J727V                                 │ [33;1mPHYSICAL[39;0m │ 1280 x 720  │ 27                      │               │
│ joan                │ LG                 │ LG-H932                                  │ [33;1mPHYSICAL[39;0m │ 1440 x 2880 │ 26                      │               │
│ judypn              │ LG                 │ LM-V405                                  │ [33;1mPHYSICAL[39;0m │ 3120 x 1440 │ 28                      │               │
│ lt02wifi            │ Samsung            │ SM-T210                                  │ [33;1mPHYSICAL[39;0m │  600 x 1024 │ 19                      │               │
│ lv0                 │ LG                 │ LG-AS110                                 │ [33;1mPHYSICAL[39;0m │  854 x 480  │ 23                      │               │
│ oriole              │ Google             │ Pixel 6                                  │ [33;1mPHYSICAL[39;0m │ 2400 x 1080 │ 31                      │               │
│ pettyl              │ Motorola           │ moto e5 play                             │ [33;1mPHYSICAL[39;0m │  960 x 480  │ 27                      │               │
│ phoenix_sprout      │ LG                 │ LM-Q910                                  │ [33;1mPHYSICAL[39;0m │ 3120 x 1440 │ 28                      │               │
│ q2q                 │ Samsung            │ SM-F926U1                                │ [33;1mPHYSICAL[39;0m │ 2208 x 1768 │ 30                      │               │
│ redfin              │ Google             │ Pixel 5e                                 │ [33;1mPHYSICAL[39;0m │ 2340 x 1080 │ 30                      │ [32mdefault      [39;0m │
│ sailfish            │ Google             │ Pixel                                    │ [33;1mPHYSICAL[39;0m │  640 x 480  │ 25                      │               │
│ starqlteue          │ Samsung            │ SM-G960U1                                │ [33;1mPHYSICAL[39;0m │ 1080 x 2220 │ 26                      │               │
│ walleye             │ Google             │ Pixel 2                                  │ [33;1mPHYSICAL[39;0m │ 1920 x 1080 │ 27                      │               │
│ x1q                 │ Samsung            │ SM-G981U1                                │ [33;1mPHYSICAL[39;0m │ 3200 x 1440 │ 29                      │               │
└─────────────────────┴────────────────────┴──────────────────────────────────────────┴──────────┴─────────────┴─────────────────────────┴───────────────┘''';

void main() {
  List<String> lines = androidFirebaseTestLabData.split('\n');

  group('Android devices from Firebase Test Lab', () {
    test('All', () {
      List<TestScreenDevice> devices = androidDevicesFromFirebaseTestLab(lines);
      expect(devices.length, 37);
      TestScreenDevice device = devices[0];
      expect(device.name, 'Vivo vivo 1610 (1610)');
      expect(device.size, const Size(1280, 720));
      device = devices[3];
      expect(device.name,
          'Generic Generic 720x1600 Android tablet @ 270dpi (AndroidTablet270dpi)');
      expect(device.size, const Size(1600, 720));
      device = devices[36];
      expect(device.name, 'Samsung SM-G981U1 (x1q)');
      expect(device.size, const Size(3200, 1440));
    });
    test('With emulator form', () {
      List<TestScreenDevice> devices =
          androidDevicesFromFirebaseTestLab(lines, includeEmulatorForm: true);
      expect(devices.length, 37);
      TestScreenDevice device = devices[0];
      expect(device.name, 'Vivo vivo 1610 (1610)');
      expect(device.size, const Size(1280, 720));
      device = devices[3];
      expect(device.name, 'Google Google TV Amati (AmatiTvEmulator)');
      expect(device.size, const Size(1080, 1920));
      device = devices[36];
      expect(device.name, 'Samsung SM-G981U1 (x1q)');
      expect(device.size, const Size(3200, 1440));
    });
    test('Excluding models', () {
      List<TestScreenDevice> devices = androidDevicesFromFirebaseTestLab(lines,
          excludeModels: ['1610', 'G8142']);
      expect(devices.length, 37);
      TestScreenDevice device = devices[0];
      expect(device.name, 'HMD Global Nokia 9 (AOP_sprout)');
      expect(device.size, const Size(2880, 1440));
      device = devices[5];
      expect(device.name, 'Sony G8342 (G8342)');
      expect(device.size, const Size(1080, 1920));
    });
  });
}
