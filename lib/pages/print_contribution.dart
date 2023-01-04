import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tibud_care_system/model/model.dart';
import 'package:tibud_care_system/utils/constant.dart';
import 'package:pdf/pdf.dart';

class PrintContribution extends StatefulWidget {
  PrintContribution({super.key, required this.info});
  Member info;

  @override
  State<PrintContribution> createState() => _PrintContributionState();
}

class _PrintContributionState extends State<PrintContribution>{

  
  final formKey = GlobalKey<FormState>();
  String? sub;
  String? name;
  String? jobcon;
  String claimText = 'null';
  String benefitText = 'null';
  String dateText = 'null';
  String availedText = 'null';
  double balance = 0;
  final claim = TextEditingController();
  final benefit = TextEditingController();
  final date = TextEditingController();
  final availed = TextEditingController();
  List<Contributions>? list;
  final operationHead = TextEditingController();
  final postingClerk = TextEditingController();
  bool change = false;
  double sum = 0;
  var newList = [];

  
  @override
  void initState() {
    // TODO: implement initState
    operationHead.text = ophead;
    postingClerk.text = postingclerk;
    name = widget.info.member;
    jobcon = widget.info.branch;
    list = widget.info.contributions;
    list!.sort((a,b) => a.date!.compareTo(b.date!));
    newList = List.from(list!.reversed);
    for(var x in list!){
      sum += x.amount!;
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                            height: size.height * .5,
                            width: size.width * .35,
                            child: Center(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: claim,
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: 'Claim',
                                        labelStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: benefit,
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: 'Benefit',
                                        labelStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: date,
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        prefixIcon: Icon(Icons.person),
                                        hintText: 'MM/DD/YYYY',
                                        hintStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.grey.shade400,)
                                        ),
                                        labelText: 'DOC',
                                        labelStyle: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      controller: availed,
                                      style: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                      ),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        labelText: 'Availed',
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
                              change = true;
                              Navigator.pop(context);
                              // if(formKey.currentState!.validate() && sub != null){
                                
                              // }
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
                  ophead = operationHead.text;
                  postingclerk = postingClerk.text;
                  claimText = claim.text.toUpperCase();
                  benefitText = benefit.text;
                  dateText = date.text;
                  availedText = availed.text;
                  balance = (double.parse(benefit.text) - double.parse(availed.text)).abs();
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
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 100,
                      height: 15,
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(DateFormat.yMMMd().format(DateTime.now()).toUpperCase(), style: const pw.TextStyle(fontSize: 12))
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 100,
                      height: 15,
                      child: pw.Text('Name:', style: const pw.TextStyle(fontSize: 10))
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(name!, style: const pw.TextStyle(fontSize: 10))
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 100,
                      height: 15,
                      child: pw.Text('Jobcon:', style: const pw.TextStyle(fontSize: 10))
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(jobcon!, style: const pw.TextStyle(fontSize: 10))
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 100,
                      height: 15,
                      child: pw.Text('Claim:', style: const pw.TextStyle(fontSize: 10))
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(claimText, style: const pw.TextStyle(fontSize: 10))
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 400,
                      height: 15,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('Benefits: ', style: const pw.TextStyle(fontSize: 10))
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(benefitText, style: const pw.TextStyle(fontSize: 10))
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 400,
                      height: 15,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('Date: ', style: const pw.TextStyle(fontSize: 10))
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(dateText, style: const pw.TextStyle(fontSize: 10))
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 400,
                      height: 15,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('Availed: ', style: const pw.TextStyle(fontSize: 10))
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(availedText, style: const pw.TextStyle(fontSize: 10))
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 400,
                      height: 15,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('Balance: ', style: const pw.TextStyle(fontSize: 10))
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(balance.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 10))
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 250,
                      height: 300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          for(var i = 0; i < newList.length; i++) if(i<12) pw.Text(
                            DateFormat('MM/dd/yyyy').format(DateTime.parse(newList[i].date)),
                            style: const pw.TextStyle(fontSize: 8)
                          )
                          // for ( var i in newList ) pw.Text(
                          //   DateFormat('MM/dd/yyyy').format(DateTime.parse(i.date!)),
                          //   style: const pw.TextStyle(fontSize: 8)
                          // )
                        ] 
                      )
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 300,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            for(var i = 0; i < newList.length; i++) if(i<12) pw.Text(
                              NumberFormat("###,##0.00#", "en_US").format(newList[i].amount!),
                              style: const pw.TextStyle(fontSize: 8)
                            )
                            // for ( var i in newList ) pw.Text(
                            //   NumberFormat("###,##0.00#", "en_US").format(i.amount!),
                            //   style: const pw.TextStyle(fontSize: 8)
                            // )
                          ] 
                        )
                      )
                    )
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 250,
                      height: 15,
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text('Total: ', style: const pw.TextStyle(fontSize: 10))
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        height: 15,
                        child: pw.Text(NumberFormat("###,###.00#", "en_US").format(sum), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
                      )
                    )
                  ],
                ),
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
                              'Tibud Care Clerk',
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
                        child: pw.Column(
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
                              'Operation Head',
                              style: pw.TextStyle(
                                font: font3,
                                fontSize: 12,
                              ),
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
    return pdf.save();
  }
}