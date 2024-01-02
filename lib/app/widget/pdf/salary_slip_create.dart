import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:bsthrm/global/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
const sep = 120.0;

Future<Uint8List> generateSalarySlip(PdfPageFormat format) async {
  final doc = pw.Document(title: 'Salary Slip', author: 'Deepjyoti Baishya');
  final profileImage = pw.MemoryImage(
    (await rootBundle.load(AssetImages.logo)).buffer.asUint8List(),
  );
  final pageTheme = await _myPageTheme(format);
  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      // margin: pw.EdgeInsets.all(6),
      build: (pw.Context context) => [
        pw.Container(
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(4),
            border: pw.Border.all(color: PdfColors.black, width: 1.5),
          ),
          // height: ,
          child: pw.Column(children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(12),
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(profileImage, height: 80, width: 80),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        height: 80,
                        child: pw.Text(
                          'dikhita retail private limited'.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text('PAY SLIP',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1.5),
                ),
                width: double.infinity,
                child: pw.Column(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      'Pay Slip For The Month Of Dec 2023',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ])),
            // pw.SizedBox(height: 10),
            _EmployeeDetailsRow(),
            // add divider
            pw.Container(
              height: 1.5,
              width: double.infinity,
              color: PdfColors.black,
            ),
            _EarningTable(),
            pw.Container(
              height: 0.5,
              width: double.infinity,
              color: PdfColors.grey,
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                'NET PAY: 20,120.63 [Round: 20121] (Rupees Twenty Thousand One Hundred Twenty One Only)',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              height: 0.5,
              width: double.infinity,
              color: PdfColors.grey,
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                'This is a computer generated document, hence no signature is required.',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Container(
              height: 1.5,
              width: double.infinity,
              color: PdfColors.black,
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                  'DIKHITA RETAILS PRIVATE LIMITED\nCIN: U72900AS2023PTC024175 &NBSP;&NBSP; PAN: AAJCD8391D &NBSP;&NBSP; TAN: SHLD06162C\nHead Office Address: 2nd Floor, Dikhita Corporate Office, Dharapur, Kamrup Metropolitan, Assam, Pin-781014',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center),
            ),
          ]),
        ),
      ],
    ),
  );
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  // final bgShape = await rootBundle.loadString(AssetImages.logogrey);
  final waterMark = pw.MemoryImage(
    (await rootBundle.load(AssetImages.logogrey)).buffer.asUint8List(),
  );

  format = format.applyMargin(
    left: 0.1 * PdfPageFormat.cm,
    top: 0.1 * PdfPageFormat.cm,
    right: 0.1 * PdfPageFormat.cm,
    bottom: 0.1 * PdfPageFormat.cm,
  );
  return pw.PageTheme(
    pageFormat: format,
    margin: const pw.EdgeInsets.all(0.5 * PdfPageFormat.cm),
    theme: pw.ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
      icons: await PdfGoogleFonts.materialIcons(),
    ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
          ignoreMargins: true,
          child: pw.Opacity(
            opacity: 0.2,
            child: pw.Center(
              child: pw.Image(
                waterMark,
                height: 400,
              ),
            ),
          ));
    },
  );
}

// class _EmployeeDetailsRow extends pw.StatelessWidget {
//   _EmployeeDetailsRow();

//   @override
//   pw.Widget build(pw.Context context) {
//     return pw.TableHelper.fromTextArray(
//       context: context,
//       // rowDecoration: pw.BoxDecoration(
//       //   border: pw.Border.all(color: PdfColors.grey, width: 0.5),
//       // ),

//       tableDirection: pw.TextDirection.ltr,
//       border: const pw.TableBorder(
//         horizontalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
//         verticalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
//       ),
//       headerCount: 0,

//       columnWidths: {
//         0: const pw.FlexColumnWidth(1),
//         1: const pw.FlexColumnWidth(1),
//         2: const pw.FlexColumnWidth(1),
//         3: const pw.FlexColumnWidth(1),
//       },
//       cellStyle: pw.TextStyle(
//         fontSize: 12,
//         fontWeight: pw.FontWeight.normal,
//       ),
//       headerStyle: pw.TextStyle(
//         fontSize: 12,
//         fontWeight: pw.FontWeight.bold,
//       ),
//       data: const <List<String>>[
//         <String>['EMPLOYEE', 'D1001', 'STATE', 'ASSAM'],
//         <String>['EMPLOYEE', 'D1001', 'STATE', 'ASSAM'],
//       ],
//     );
//   }
// }
class _EmployeeDetailsRow extends pw.StatelessWidget {
  _EmployeeDetailsRow();

  @override
  pw.Widget build(pw.Context context) {
    return pw.Table(
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        verticalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
      ),
      tableWidth: pw.TableWidth.max,
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('EMPLOYEE',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('D1001'),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('STATE',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('ASSAM'),
            ),
          ],
        ),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('EMPLOYEE NAME',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('SANGITA SARANIA'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('BANK',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('ICICI'),
          ),
        ]),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('DATE OF JOINING',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('25-08-2023'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('A/C NO.',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('325201503067'),
          ),
        ]),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('PAN',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('LVXPS0853C'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('IFSC',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('ICIC0003252'),
          ),
        ]),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('DESIGNATION',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('Chief Financial Officer'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('PF NO.',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(''),
          ),
        ]),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('DEPARTMENT',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('DIKHITA INFOCOMM MANAGEMENT'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('PF UAN',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(''),
          ),
        ]),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('LOCATION HQ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('GUWAHATI'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('ESIC NO.',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(''),
          ),
        ]),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('CIRCLE',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('Assam'),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('WORK DAYS',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('30'),
            ),
          ],
        ),
      ],
    );
  }
}

class _EarningTable extends pw.StatelessWidget {
  _EarningTable();

  @override
  pw.Widget build(pw.Context context) {
    return pw.Table(
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
        verticalInside: pw.BorderSide(color: PdfColors.grey, width: 0.5),
      ),
      tableWidth: pw.TableWidth.max,
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(1),
      },
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('EARNINGS',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('EARNED',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('DEDUCTIONS',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Text('AMOUNT',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  )),
            ),
          ],
        ),
        // BASIC PAY 14,700.00 EMPLOYEE PF 1,764.00
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('BASIC PAY'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '14,700.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('EMPLOYEE PF'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '1,764.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
        ]),
//         HRA 7,350.00 EMPLOYEE ESI 165.38
// SPECIAL PAY 0.00 TDS 0.00
// VARIABLE PAY 0.00 PROFESSIONAL TAX 0.00
// GROSS SALARY 22,050.00 LEAVE 0.00
//  add in table
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('HRA'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '7,350.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('EMPLOYEE ESI'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '165.38',
              textAlign: pw.TextAlign.right,
            ),
          ),
        ]),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('SPECIAL PAY'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '0.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('TDS'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '0.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
        ]),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('VARIABLE PAY'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '0.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('PROFESSIONAL TAX'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '0.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
        ]),
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('GROSS SALARY'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '22,050.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('LEAVE'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '0.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
        ]),
        // TRAVELLING ALLOWANCE 0.0

        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('TRAVELLING ALLOWANCE'),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '0.00',
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(''),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '',
              textAlign: pw.TextAlign.right,
            ),
          ),
        ]),

        // GROSS EARNINGS 22,050.00 GROSS DEDUCTION 1,929.38 add in  add bold
        pw.TableRow(children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('GROSS EARNINGS',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '22,050.00',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text('GROSS DEDUCTION',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(4.0),
            child: pw.Text(
              '1,929.38',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        ]),
      ],
    );
  }
}

class _Block extends pw.StatelessWidget {
  _Block({
    required this.title,
    this.icon,
  });

  final String title;

  final pw.IconData? icon;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  width: 6,
                  height: 6,
                  margin: const pw.EdgeInsets.only(top: 5.5, left: 2, right: 5),
                  decoration: const pw.BoxDecoration(
                    color: green,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Text(title,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(fontWeight: pw.FontWeight.bold)),
                pw.Spacer(),
                if (icon != null) pw.Icon(icon!, color: lightGreen, size: 18),
              ]),
          pw.Container(
            decoration: const pw.BoxDecoration(
                border: pw.Border(left: pw.BorderSide(color: green, width: 2))),
            padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const pw.EdgeInsets.only(left: 5),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Lorem(length: 20),
                ]),
          ),
        ]);
  }
}

class _Category extends pw.StatelessWidget {
  _Category({required this.title});

  final String title;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        color: lightGreen,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      margin: const pw.EdgeInsets.only(bottom: 10, top: 20),
      padding: const pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: pw.Text(
        title,
        textScaleFactor: 1.5,
      ),
    );
  }
}

class _Percent extends pw.StatelessWidget {
  _Percent({
    required this.size,
    required this.value,
    required this.title,
  });

  final double size;

  final double value;

  final pw.Widget title;

  static const fontSize = 1.2;

  PdfColor get color => green;

  static const backgroundColor = PdfColors.grey300;

  static const strokeWidth = 5.0;

  @override
  pw.Widget build(pw.Context context) {
    final widgets = <pw.Widget>[
      pw.Container(
        width: size,
        height: size,
        child: pw.Stack(
          alignment: pw.Alignment.center,
          fit: pw.StackFit.expand,
          children: <pw.Widget>[
            pw.Center(
              child: pw.Text(
                '${(value * 100).round().toInt()}%',
                textScaleFactor: fontSize,
              ),
            ),
            pw.CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ],
        ),
      )
    ];

    widgets.add(title);

    return pw.Column(children: widgets);
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(text,
          style: const pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            color: PdfColors.blue,
          )),
    );
  }
}

class CustomData {
  const CustomData({this.name = '[your name]'});

  final String name;
}
