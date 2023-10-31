import 'dart:async';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image/image.dart';

class PrintTest {
  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text("Kasheer",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(
        "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: +919591708470',
        styles: const PosStyles(align: PosAlign.center));

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text("26-11-2020 15:22:45",
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text(
        'Note: Goods once sold will not be taken back or exchanged.',
        styles: const PosStyles(align: PosAlign.center, bold: false));

    // Print image:
    final ByteData data = await rootBundle.load('assets/black_white.png');
    final Uint8List imgBytes = data.buffer.asUint8List();
    final Image image = decodeImage(imgBytes)!;
    // bytes += generator.image(image);
    // Print image using an alternative (obsolette) command
    bytes += generator.imageRaster(image);

    // // Print barcode
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));

    bytes += generator.cut();
    return bytes;
  }
}
