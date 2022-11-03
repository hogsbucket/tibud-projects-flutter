import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

class Printing extends StatefulWidget {
  Printing({super.key, required this.name});
  String name;

  @override
  State<Printing> createState() => _PrintingState();
}

class _PrintingState extends State<Printing> {
  String amountInWords = '_____________________________________________________________';
  String dependent = '________________________________________________';
  String amountInNum = '________________';
  String subject = '________________________________________________';
  String to = '________________________________________________';
  String ophead = 'Mary Grace T. Sebua';
  String postingclerk = 'Jenny P. Palacios';
  final operationHead = TextEditingController();
  final postingClerk = TextEditingController();
  final amount = TextEditingController();
  final subjectOfHospitalization = TextEditingController();
  final confinee = TextEditingController();
  final notInTheListHospital = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool change = false;
  bool show = true;
  String? sub;
  var hospital = [   
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 11',
    'Item 21',
    'Item 31',
    'Item 41',
    'Item 12',
    'Item 22',
    'Item 32',
    'Item 42',
    'Item 13',
    'Item 23',
    'Item 33',
    'Item 43',
    'Other',
  ];
  String dropdownvalue = 'Item 1';

  @override
  void initState() {
    // TODO: implement initState
    operationHead.text = ophead;
    postingClerk.text = postingclerk;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    amount.dispose();
    subjectOfHospitalization.dispose();
    confinee.dispose();
    notInTheListHospital.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Colors.green.shade900,
          elevation: 0,
          leadingWidth: 30,
          leading: IconButton(
            splashRadius: 10,
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.arrow_back, size: 15,)
          ),
          title: Text(
            'Return',
            style: GoogleFonts.dosis(
              textStyle: TextStyle(fontSize: 15, color: Colors.white,)
            ),
          ),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Edit',
          backgroundColor: Colors.green.shade900,
          onPressed: (){
            showDialog(
              context: context, 
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                          BorderRadius.all(
                            Radius.circular(10.0))
                      ),
                      title: Text(
                        'Edit Details',
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(fontSize: 30, color: Colors.black)
                        ),
                      ),
                      content: Builder(
                        builder: (context){
                          return SizedBox(
                            height: size.height * .75,
                            width: size.width * .35,
                            child: Center(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: DropdownButton(
                                        value: dropdownvalue,
                                        icon: const Icon(Icons.keyboard_arrow_down),
                                        menuMaxHeight: 300,
                                        items: hospital.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(), 
                                        onChanged: ((String? value) {
                                          setState(() {
                                            dropdownvalue = value!;
                                          });
                                        })
                                      ),
                                    ),                            
                                    TextFormField(
                                      controller: notInTheListHospital,
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.money),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: 'Hospital',
                                        labelStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        RadioListTile(
                                            title: Text("Out Patient"),
                                            value: "Out", 
                                            groupValue: sub, 
                                            onChanged: (value){
                                              setState(() {
                                                  sub = value.toString();
                                              });
                                            },
                                        ),
                                        RadioListTile(
                                            title: Text("In Patient"),
                                            value: "In", 
                                            groupValue: sub, 
                                            onChanged: (value){
                                              setState(() {
                                                  sub = value.toString();
                                              });
                                            },
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      controller: amount,
                                      keyboardType: TextInputType.number,
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      validator: (value) {
                                        final n = num.tryParse(value!);
                                        if (value.isEmpty) {
                                          return 'Can\'t be empty';
                                        }else if(n == null){
                                          return 'Invalid input';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.money),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: 'Amount',
                                        labelStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: confinee,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Can\'t be empty';
                                        }
                                        return null;
                                      },
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: 'Confinee',
                                        labelStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: operationHead,
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: 'Operation Head',
                                        labelStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                        ),
                                      ),
                                    ),
                                    CheckboxListTile(
                                      value: show,
                                      title: Text('Show Signature'),
                                      controlAffinity: ListTileControlAffinity.leading, 
                                      onChanged: (value) => setState(() => show = value!)
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: postingClerk,
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: 'Posting Clerk',
                                        labelStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          );
                        }
                      ),
                      actions: [
                        SizedBox(
                          width: size.width * .1,
                          height: 40,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: (){
                              change = false;
                              Navigator.pop(context);
                            },
                            child: Text(
                              "CLOSE",
                              style: GoogleFonts.dosis(
                                textStyle: TextStyle(fontSize: 20, color: Colors.green.shade900)
                              ),
                            ),
                          )
                        ),
                        const SizedBox(width: 30,),
                        SizedBox(
                          width: size.width * .1,
                          height: 40,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                            ),
                            onPressed: () {
                              if(formKey.currentState!.validate() && sub != null){
                                change = true;
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Edit",
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(fontSize: 20, color: Colors.white)
                              ),
                            ),
                          )
                        ),
                        const SizedBox(width: 75,),
                      ],
                    );
                  }
                );
              }
            ).then((value){
              if(change){
                setState(() {
                  if(dropdownvalue == 'Other'){
                    to = notInTheListHospital.text;
                  }else{
                    to = dropdownvalue;
                  }
                  subject = 'Hospitalization - $sub Patient Case Only';
                  amountInNum = NumberFormat('#,###,##0', 'en_US').format(int.parse(amount.text));
                  amountInWords = NumberToWordsEnglish.convert(int.parse(amount.text)).toUpperCase();
                  ophead = operationHead.text;
                  postingclerk = postingClerk.text;
                  dependent = confinee.text.toUpperCase();
                });
              }
            });
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    Size size = MediaQuery.of(context).size;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.vollkornBold();
    final font2 = await PdfGoogleFonts.newsreaderBold();
    final font3 = await PdfGoogleFonts.newsreaderRegular();
    final header = await imageFromAssetBundle('assets/letterhead-top.png');
    final footer = await imageFromAssetBundle('assets/letterhead-bottom.png');
    final signature = await imageFromAssetBundle('assets/signature.png');

    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.zero,
        ),
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                height: 90,
                child: pw.Image(header, fit: pw.BoxFit.fill)
              ),
              pw.Text(
                'LETTER OF GUARANTEE',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 20,
                  letterSpacing: 2,
                  wordSpacing: 3,
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(20),
                  child:
                   pw.RichText(
                    text: pw.TextSpan(
                      text: 'Date: ',
                      style: pw.TextStyle(
                        font: font2,
                        fontSize: 12,
                      ),
                      children: [
                        pw.TextSpan(
                          text: DateFormat.yMMMMd().format(DateTime.now()), 
                          style: pw.TextStyle(
                            font: font2,
                            fontSize: 12,
                            decoration: pw.TextDecoration.underline,
                          )
                        ),
                      ],
                    ),
                  )
                )
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(20),
                  child: 
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'To                     :         ',
                      style: pw.TextStyle(
                        font: font2,
                        fontSize: 12,
                      ),
                      children: [
                        pw.TextSpan(
                          text: to, 
                          style: pw.TextStyle(
                            font: font2,
                            fontSize: 12,
                            decoration: pw.TextDecoration.underline,
                          )
                        ),
                      ],
                    ),
                  )
                )
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Padding(
                  padding: pw.EdgeInsets.only(left: 20),
                  child: 
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'Subject          :         ',
                      style: pw.TextStyle(
                        font: font2,
                        fontSize: 12,
                      ),
                      children: [
                        pw.TextSpan(
                          text: subject, 
                          style: pw.TextStyle(
                            font: font2,
                            fontSize: 12,
                            decoration: pw.TextDecoration.underline,
                          )
                        ),
                      ],
                    ),
                  )
                )
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Padding(
                  padding: pw.EdgeInsets.only(left: 20, top: 50, bottom: 20, right: 20),
                  child: pw.RichText(
                    text: pw.TextSpan(
                      text: 'This is to certify that   ',
                      style: pw.TextStyle(
                        font: font3,
                        fontSize: 12,
                        lineSpacing: 10,
                        wordSpacing: 2
                      ),
                      children: [
                        pw.TextSpan(
                          text: '${widget.name}', 
                          style: pw.TextStyle(
                            font: font2,
                            fontSize: 12,
                            decoration: pw.TextDecoration.underline,
                          )
                        ),
                        pw.TextSpan(
                          text: '   is a bonafide member of  "TIBUD CARE".\nThe Cooperative Medical Fund System of Tibud Sa Katibawasan Multi-Purpose Cooperative\nHe or she entitled to a limit amounting  ', 
                          style: pw.TextStyle(
                            font: font3,
                            fontSize: 12,
                          )
                        ),
                        pw.TextSpan(
                          text: amountInWords, 
                          style: pw.TextStyle(
                            font: font2,
                            fontSize: 12,
                            decoration: pw.TextDecoration.underline,
                          )
                        ),
                        pw.TextSpan(
                          text: '\n(P ', 
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 12,
                          )
                        ),
                        pw.TextSpan(
                          text: amountInNum, 
                          style: pw.TextStyle(
                            font: font2,
                            fontSize: 12,
                            decoration: pw.TextDecoration.underline,
                          )
                        ),
                        pw.TextSpan(
                          text: ' ) pesos only.', 
                          style: pw.TextStyle(
                            font: font3,
                            fontSize: 12,
                          )
                        ),
                      ],
                    ),
                  )
                )
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Padding(
                  padding: pw.EdgeInsets.only(left: 20, top: 10, bottom: 20, right: 20),
                  child: 
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'As such please accommodate Mr. \/Ms. \/Mrs. ',
                      style: pw.TextStyle(
                        font: font3,
                        fontSize: 12,
                        lineSpacing: 10,
                        wordSpacing: 2
                      ),
                      children: [
                        pw.TextSpan(
                          text: dependent, 
                          style: pw.TextStyle(
                            font: font2,
                            fontSize: 12,
                            decoration: pw.TextDecoration.underline,
                          )
                        ),
                        pw.TextSpan(
                          text: ' his/her dependent for hospitalization. This is to further certify that Tibud Care of Tibud SKMPC guarantees payment of his hospitalization.', 
                          style: pw.TextStyle(
                            font: font3,
                            fontSize: 12,
                          )
                        ),
                      ],
                    ),
                  )
                )
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Padding(
                  padding: pw.EdgeInsets.only(left: 20, top: 10, bottom: 40, right: 20),
                  child: pw.Text(
                    'Thank you and God bless.',
                    style: pw.TextStyle(
                      font: font3,
                      fontSize: 12,
                      lineSpacing: 10
                    ),
                  ),
                )
              ),
              pw.Row(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 20),
                    child: pw.Container(
                      width: 300,
                      height: size.height * .15,
                      child: pw.Align(
                        alignment: pw.Alignment.topLeft,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Prepared by:',
                              style: pw.TextStyle(
                                font: font3,
                                fontSize: 12,
                              ),
                            ),
                            pw.SizedBox(height: 30),
                            pw.Text(
                              postingclerk,
                              style: pw.TextStyle(
                                font: font2,
                                fontSize: 12,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              'Posting Clerk',
                              style: pw.TextStyle(
                                font: font3,
                                fontSize: 12,
                              ),
                            ),
                          ]
                        )
                      )
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: size.height * .15,
                      child: pw.Align(
                        alignment: pw.Alignment.topLeft,
                        child: pw.Stack(
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Noted by:',
                                  style: pw.TextStyle(
                                    font: font3,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.SizedBox(height: 30),
                                pw.Text(
                                  ophead,
                                  style: pw.TextStyle(
                                    font: font2,
                                    fontSize: 12,
                                  ),
                                ),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  'Operations Head',
                                  style: pw.TextStyle(
                                    font: font3,
                                    fontSize: 12,
                                  ),
                                ),
                              ]
                            ),
                            if(show)pw.Container(
                              width: 100,
                              height: 50,
                              child: pw.Image(signature, fit: pw.BoxFit.cover)
                            ),
                          ]
                        )
                      )
                    )
                  )
                ],
              ),
              pw.Spacer(),
              pw.SizedBox(
                width: double.infinity,
                height: 90,
                child: pw.Image(footer, fit: pw.BoxFit.cover)
              ),
            ],
          );
        },
      ),
    );
    if(change){
      final file = File('C:/tibud care server/TCA-LOG/${widget.name}-LOG-${DateFormat.yMMMd().format(DateTime.now())}.pdf');
      await file.writeAsBytes(await pdf.save());
    }
    return pdf.save();
  }
}