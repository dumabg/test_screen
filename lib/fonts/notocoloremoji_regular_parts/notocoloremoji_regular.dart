import 'font_notocoloremoji_regular_part00.dart';
import 'font_notocoloremoji_regular_part01.dart';
import 'font_notocoloremoji_regular_part02.dart';
import 'font_notocoloremoji_regular_part03.dart';
import 'font_notocoloremoji_regular_part04.dart';
import 'font_notocoloremoji_regular_part05.dart';
import 'font_notocoloremoji_regular_part06.dart';
import 'font_notocoloremoji_regular_part07.dart';
import 'font_notocoloremoji_regular_part08.dart';
import 'font_notocoloremoji_regular_part09.dart';
import 'font_notocoloremoji_regular_part10.dart';
import 'font_notocoloremoji_regular_part11.dart';
import 'font_notocoloremoji_regular_part12.dart';
import 'font_notocoloremoji_regular_part13.dart';
import 'font_notocoloremoji_regular_part14.dart';
import 'font_notocoloremoji_regular_part15.dart';
import 'font_notocoloremoji_regular_part16.dart';
import 'font_notocoloremoji_regular_part17.dart';
import 'font_notocoloremoji_regular_part18.dart';
import 'font_notocoloremoji_regular_part19.dart';
import 'font_notocoloremoji_regular_part20.dart';
import 'font_notocoloremoji_regular_part21.dart';
import 'font_notocoloremoji_regular_part22.dart';
import 'font_notocoloremoji_regular_part23.dart';
import 'font_notocoloremoji_regular_part24.dart';
import 'font_notocoloremoji_regular_part25.dart';
import 'font_notocoloremoji_regular_part26.dart';
import 'font_notocoloremoji_regular_part27.dart';
import 'font_notocoloremoji_regular_part28.dart';
import 'font_notocoloremoji_regular_part29.dart';
import 'font_notocoloremoji_regular_part30.dart';
import 'font_notocoloremoji_regular_part31.dart';
import 'font_notocoloremoji_regular_part32.dart';
import 'font_notocoloremoji_regular_part33.dart';
import 'font_notocoloremoji_regular_part34.dart';
import 'font_notocoloremoji_regular_part35.dart';
import 'font_notocoloremoji_regular_part36.dart';
import 'font_notocoloremoji_regular_part37.dart';
import 'font_notocoloremoji_regular_part38.dart';
import 'font_notocoloremoji_regular_part39.dart';
import 'font_notocoloremoji_regular_part40.dart';
import 'font_notocoloremoji_regular_part41.dart';
import 'font_notocoloremoji_regular_part42.dart';
import 'font_notocoloremoji_regular_part43.dart';
import 'font_notocoloremoji_regular_part44.dart';
import 'font_notocoloremoji_regular_part45.dart';
import 'font_notocoloremoji_regular_part46.dart';
import 'font_notocoloremoji_regular_part47.dart';
import 'dart:typed_data';

Uint8List concatenateUint8Lists(List<Uint8List> lists) {
  int totalLength = 0;
  for (final list in lists) {
    totalLength += list.length;
  }

  final result = Uint8List(totalLength);
  int offset = 0;

  for (final list in lists) {
    result.setRange(offset, offset + list.length, list);
    offset += list.length;
  }

  return result;
}


Uint8List font_notocoloremoji_regular() {
    return concatenateUint8Lists([
        font_notocoloremoji_regular_part00(),
        font_notocoloremoji_regular_part01(),
        font_notocoloremoji_regular_part02(),
        font_notocoloremoji_regular_part03(),
        font_notocoloremoji_regular_part04(),
        font_notocoloremoji_regular_part05(),
        font_notocoloremoji_regular_part06(),
        font_notocoloremoji_regular_part07(),
        font_notocoloremoji_regular_part08(),
        font_notocoloremoji_regular_part09(),
        font_notocoloremoji_regular_part10(),
        font_notocoloremoji_regular_part11(),
        font_notocoloremoji_regular_part12(),
        font_notocoloremoji_regular_part13(),
        font_notocoloremoji_regular_part14(),
        font_notocoloremoji_regular_part15(),
        font_notocoloremoji_regular_part16(),
        font_notocoloremoji_regular_part17(),
        font_notocoloremoji_regular_part18(),
        font_notocoloremoji_regular_part19(),
        font_notocoloremoji_regular_part20(),
        font_notocoloremoji_regular_part21(),
        font_notocoloremoji_regular_part22(),
        font_notocoloremoji_regular_part23(),
        font_notocoloremoji_regular_part24(),
        font_notocoloremoji_regular_part25(),
        font_notocoloremoji_regular_part26(),
        font_notocoloremoji_regular_part27(),
        font_notocoloremoji_regular_part28(),
        font_notocoloremoji_regular_part29(),
        font_notocoloremoji_regular_part30(),
        font_notocoloremoji_regular_part31(),
        font_notocoloremoji_regular_part32(),
        font_notocoloremoji_regular_part33(),
        font_notocoloremoji_regular_part34(),
        font_notocoloremoji_regular_part35(),
        font_notocoloremoji_regular_part36(),
        font_notocoloremoji_regular_part37(),
        font_notocoloremoji_regular_part38(),
        font_notocoloremoji_regular_part39(),
        font_notocoloremoji_regular_part40(),
        font_notocoloremoji_regular_part41(),
        font_notocoloremoji_regular_part42(),
        font_notocoloremoji_regular_part43(),
        font_notocoloremoji_regular_part44(),
        font_notocoloremoji_regular_part45(),
        font_notocoloremoji_regular_part46(),
        font_notocoloremoji_regular_part47(),
    ]);
}
