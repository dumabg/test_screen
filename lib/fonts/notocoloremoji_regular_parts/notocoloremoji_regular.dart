import 'dart:typed_data';
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


Uint8List fontNotocoloremojiRegular() {
    return concatenateUint8Lists([
        fontNotocoloremojiRegularPart00(),
        fontNotocoloremojiRegularPart01(),
        fontNotocoloremojiRegularPart02(),
        fontNotocoloremojiRegularPart03(),
        fontNotocoloremojiRegularPart04(),
        fontNotocoloremojiRegularPart05(),
        fontNotocoloremojiRegularPart06(),
        fontNotocoloremojiRegularPart07(),
        fontNotocoloremojiRegularPart08(),
        fontNotocoloremojiRegularPart09(),
        fontNotocoloremojiRegularPart10(),
        fontNotocoloremojiRegularPart11(),
        fontNotocoloremojiRegularPart12(),
        fontNotocoloremojiRegularPart13(),
        fontNotocoloremojiRegularPart14(),
        fontNotocoloremojiRegularPart15(),
        fontNotocoloremojiRegularPart16(),
        fontNotocoloremojiRegularPart17(),
        fontNotocoloremojiRegularPart18(),
        fontNotocoloremojiRegularPart19(),
        fontNotocoloremojiRegularPart20(),
        fontNotocoloremojiRegularPart21(),
        fontNotocoloremojiRegularPart22(),
        fontNotocoloremojiRegularPart23(),
        fontNotocoloremojiRegularPart24(),
        fontNotocoloremojiRegularPart25(),
        fontNotocoloremojiRegularPart26(),
        fontNotocoloremojiRegularPart27(),
        fontNotocoloremojiRegularPart28(),
        fontNotocoloremojiRegularPart29(),
        fontNotocoloremojiRegularPart30(),
        fontNotocoloremojiRegularPart31(),
        fontNotocoloremojiRegularPart32(),
        fontNotocoloremojiRegularPart33(),
        fontNotocoloremojiRegularPart34(),
        fontNotocoloremojiRegularPart35(),
        fontNotocoloremojiRegularPart36(),
        fontNotocoloremojiRegularPart37(),
        fontNotocoloremojiRegularPart38(),
        fontNotocoloremojiRegularPart39(),
        fontNotocoloremojiRegularPart40(),
        fontNotocoloremojiRegularPart41(),
        fontNotocoloremojiRegularPart42(),
        fontNotocoloremojiRegularPart43(),
        fontNotocoloremojiRegularPart44(),
        fontNotocoloremojiRegularPart45(),
        fontNotocoloremojiRegularPart46(),
        fontNotocoloremojiRegularPart47(),
    ]);
}
