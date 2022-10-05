import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:bubble_box/bubble_box.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:drag_and_drop_windows/drag_and_drop_windows.dart' as dd;
import 'package:google_fonts/google_fonts.dart';
import 'package:tibud_care_system/model/model.dart';
import 'package:tibud_care_system/server/server.dart';
import 'package:tibud_care_system/utils/constant.dart';

class Import extends StatefulWidget {
  Import({Key? key, required this.index, required this.userAccount}) : super(key: key);
  int index;
  UserAccount userAccount;

  @override
  State<Import> createState() => _ImportState();
}

class _ImportState extends State<Import> {
  String _paths = '';
  StreamSubscription? _subscription;
  final pathText = TextEditingController();
  bool hasNoData = true;
  Widget x = const CircularProgressIndicator();
  var user = UserAccount();
  
  @override
  void initState() {
    super.initState();
    user = widget.userAccount;
    _subscription ??= dd.dropEventStream.listen((paths) {
      if(mounted){
        setState(() {
          _paths = paths.join('\n');
          pathText.text = _paths;
        });   
      }
    });
  }

  void exit(){
    pathText.text = '';
    Navigator.pop(context);
  }

  // Future<void> excelRead(RequiredArgs requiredArgs) async {
  //   String date = '';
  //   final SendPort sendPort = requiredArgs.sendPort;
  //   List<String> list = requiredArgs.path!.split('\n');
  //   try{
  //     for (var e in list) {
  //       var file = e.replaceAll(RegExp(r'\\'), '\/');
  //       var bytes = File(file).readAsBytesSync();
  //       var excel = Excel.decodeBytes(bytes);
  //       for (var table in excel.tables.keys) {
  //         for (var row in excel.tables[table]!.rows) {
  //           if(row[0] != null){
  //             if(row[0]!.value.toString().toUpperCase() == 'ID NO.'){
  //               date = row[2]!.value;
  //             }else{
  //               final mem = await getMember(row[0] == null ? ' ':row[0]!.value, user);
  //               if(mem != null){
  //                 addNewContribution(mem.id, (row[2] == null || row[2]!.value is String)? 0 : row[2]!.value.toDouble(), date, user);
  //               }else{
  //                 Member member = Member();
  //                 member.idno = row[0] == null ? ' ':row[0]!.value;
  //                 member.member = row[1] == null ? ' ':row[1]!.value;
  //                 member.dateOfHire = row[3] == null ? ' ':row[3]!.value;
  //                 member.branch = row[4] == null ? ' ':row[4]!.value;
  //                 member.contributions.add(Contributions()..amount = (row[2] == null || row[2]!.value is String)? 0 : row[2]!.value.toDouble() ..date = date);
  //                 insertMembers(member, user);
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //     members = await getAllMember();
  //     sendPort.send("end");
  //   }catch(e){
  //     sendPort.send("error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if(hasNoData){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius:
            BorderRadius.all(
              Radius.circular(10.0))
        ),
        title: Text(
          'Import data from computer.',
          style: GoogleFonts.dosis(
            textStyle: const TextStyle(fontSize: 15, color: Colors.black)
          ),
        ),
        content: Builder(
          builder: (context){
            return SizedBox(
              height: 200,
              width: 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BubbleBox(
                    backgroundColor: Colors.white,
                    shape: BubbleShapeBorder(
                      border: BubbleBoxBorder(
                        color: Colors.green.shade900,
                        style: BubbleBoxBorderStyle.dashed,
                        width: 7
                      )
                    ),
                    child: Container(
                      width: 200,
                      height: 150,
                      color: _paths == ''?Colors.white:Colors.green.shade100,
                      child: _paths == ''?Icon(Icons.upload_file, size: 50,):Icon(Icons.file_open, size: 50,)
                    )
                  ),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: TextField(
                      controller: pathText,
                      toolbarOptions: const ToolbarOptions(selectAll: true),
                      scrollPadding: EdgeInsets.zero,
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green.shade900,
                            width: 2
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green.shade900,
                          )
                        ),
                        labelText: 'Path',
                        labelStyle: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: 15, color: Colors.green.shade900,)
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
        actions: [
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                "CLOSE",
                style: GoogleFonts.dosis(
                  textStyle: const TextStyle(fontSize: 20, color: Colors.white)
                ),
              ),
            )
          ),
          const SizedBox(width: 30,),
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
              ),
              onPressed: (){
                setState(() {
                  hasNoData = false;
                });
              },
              child: Text(
                "IMPORT",
                style: GoogleFonts.dosis(
                  textStyle: const TextStyle(fontSize: 20, color: Colors.white)
                ),
              ),
            )
          ),
          const SizedBox(width: 75,),
        ],
      );
    }else{
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius:
            BorderRadius.all(
              Radius.circular(10.0))
        ),
        content: Builder(
          builder: (context){
            Future.delayed(Duration(seconds: 1), () async {
              ReceivePort receivePort = ReceivePort();
              RequiredArgs requiredArgs = RequiredArgs(_paths, receivePort.sendPort);

              switch (widget.index) {
                case 0:
                  await Isolate.spawn(import1, requiredArgs);
                  break;
                case 1:
                  await Isolate.spawn(import2, requiredArgs);
                  break;
                case 2:
                  await Isolate.spawn(import3, requiredArgs);
                  break;
                case 3:
                  await Isolate.spawn(import4, requiredArgs);
                  break;
                case 4:
                  await Isolate.spawn(import5, requiredArgs);
                  break;
                case 5:
                  await Isolate.spawn(import6, requiredArgs);
                  break;
                default:await Isolate.spawn(import7, requiredArgs);
              }

              var resp = await receivePort.first;

              if(resp != 'error'){
                switch (widget.index) {
                  case 0:
                    insertManyMembers(resp, user);
                    exit();
                    break;
                  case 1:
                    insertManyConsult(resp, user);
                    exit();
                    break;
                  case 2:
                    insertManyLab(resp, user);
                    exit();
                    break;
                  case 3:
                    insertManyAcc(resp, user);
                    exit();
                    break;
                  case 4:
                    insertManyHos(resp, user);
                    exit();
                    break;
                  case 5:
                    insertManyDac(resp, user);
                    exit();
                    break;
                  default:
                    insertManyDental(resp, user);
                    exit();
                }
              }else{
                exit();
                Future.delayed(Duration.zero,() {
                  showDialog(
                    context: context,
                    builder: (context) =>
                      AlertDialog(
                        title: Text('ERROR!',style: GoogleFonts.dosis(
                          textStyle: const TextStyle(fontSize: 25, color: Colors.red, letterSpacing: 5)
                        ),),
                        content: Text('Please follow the format for importing.', style: GoogleFonts.dosis(
                          textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                        ),),
                        actions: [
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                "CLOSE",
                                style: GoogleFonts.dosis(
                                  textStyle: const TextStyle(fontSize: 20, color: Colors.white)
                                ),
                              ),
                            )
                          ),
                        ],
                      )
                  );
                });
              }
            }); 
            return SizedBox(
              height: 200,
              width: 350,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20,),
                    Text(
                      'Parsing data. Please wait....',
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(
                          fontSize: 15
                        )
                      ),
                    ),
                  ],
                )
              ),
            );
          }
        ),
      );
    }
  }
}

void import1(RequiredArgs requiredArgs){
  String date = '';
  final SendPort sendPort = requiredArgs.sendPort;
  List<String> list = requiredArgs.path!.split('\n');
  List<Member> memberlist = [];
  try{
    for (var e in list) {
      var file = e.replaceAll(RegExp(r'\\'), '\/');
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if(row[0] != null){
            if(row[0]!.value.toString().toUpperCase() == 'ID NO.'){
              date = row[2]!.value;
            }else{
              final mem = memberlist.indexWhere((element) => element.idno == row[0]!.value);
              if(mem >= 0){
                memberlist[mem].contributions.add(Contributions()..amount = (row[2] == null || row[2]!.value is String)? 0 : row[2]!.value.toDouble() ..date = date);
              }else{
                Member member = Member();
                member.idno = row[0] == null ? ' ':row[0]!.value;
                member.member = row[1] == null ? ' ':row[1]!.value;
                member.dateOfHire = row[3] == null ? ' ':row[3]!.value;
                member.branch = row[4] == null ? ' ':row[4]!.value;
                member.contributions.add(Contributions()..amount = (row[2] == null || row[2]!.value is String)? 0 : row[2]!.value.toDouble() ..date = date);
                memberlist.add(member);
              }
            }
          }
        }
      }
    }
    sendPort.send(memberlist);
  }catch(e){
    sendPort.send('error');
  }
}

void import2(RequiredArgs requiredArgs){
  final SendPort sendPort = requiredArgs.sendPort;
  List<String> list = requiredArgs.path!.split('\n');
  List<Consultation> consultationList = [];
  List<String> ids = [];
  try{
    for (var e in list) {
      var file = e.replaceAll(RegExp(r'\\'), '\/');
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if(row[0] != null){
            if(row[0]!.value.toString().toUpperCase() != 'ID NO.'){
              ids.add(row[0]!.value);
              final consult = Consultation();
              consult.confinee = row[3] == null ? ' ':row[3]!.value;
              consult.relationship = row[2] == null ? ' ':row[2]!.value;
              consult.hospital = row[4] == null ? ' ':row[4]!.value;
              consult.doc = row[5] == null ? ' ':row[5]!.value;
              consult.dod = row[6] == null ? ' ':row[6]!.value;
              consult.labBasic = (row[7] == null || row[7]!.value is String)? 0 : row[7]!.value.toDouble();
              consult.labClaims = (row[8] == null || row[8]!.value is String)? 0 : row[8]!.value.toDouble();
              consult.classification = row[10] == null ? ' ':row[10]!.value;
              consult.remarks = row[11] == null ? ' ':row[11]!.value;
              consult.diagnosis = row[12] == null ? ' ':row[12]!.value;
              consultationList.add(consult);
            }
          }
        }
      }
    }
    var result = [ids, consultationList];
    sendPort.send(result);
  }catch(e){
    sendPort.send('error');
  }
}

void import3(RequiredArgs requiredArgs){
  final SendPort sendPort = requiredArgs.sendPort;
  List<String> list = requiredArgs.path!.split('\n');
  List<Laboratory> laboratoryList = [];
  List<String> ids = [];
  try{
    for (var e in list) {
      var file = e.replaceAll(RegExp(r'\\'), '\/');
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if(row[0] != null){
            if(row[0]!.value.toString().toUpperCase() != 'ID NO.'){
              ids.add(row[0]!.value);
              final lab = Laboratory();
              lab.relationship = row[2] == null ? ' ':row[2]!.value;
              lab.confinee = row[3] == null ? ' ':row[3]!.value;
              lab.hospital = row[4] == null ? ' ':row[4]!.value;
              lab.dol = row[5] == null ? ' ':row[5]!.value;
              lab.labBasic = (row[6] == null || row[6]!.value is String)? 0 : row[6]!.value.toDouble();
              lab.labClaims = (row[7] == null || row[7]!.value is String)? 0 : row[7]!.value.toDouble();
              laboratoryList.add(lab);
            }
          }
        }
      }
    }
    var result = [ids, laboratoryList];
    sendPort.send(result);
  }catch(e){
    sendPort.send('error');
  }
}

void import4(RequiredArgs requiredArgs){
  final SendPort sendPort = requiredArgs.sendPort;
  List<String> list = requiredArgs.path!.split('\n');
  List<Accidents> accidentsList = [];
  List<String> ids = [];
  try{
    for (var e in list) {
      var file = e.replaceAll(RegExp(r'\\'), '\/');
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if(row[0] != null){
            if(row[0]!.value.toString().toUpperCase() != 'ID NO.'){
              ids.add(row[0]!.value);
              final acc = Accidents();
              acc.relationship = row[2] == null ? ' ':row[2]!.value;
              acc.confinee = row[3] == null ? ' ':row[3]!.value;
              acc.hospital = row[4] == null ? ' ':row[4]!.value;
              acc.doc = row[5] == null ? ' ':row[5]!.value;
              acc.dod = row[6] == null ? ' ':row[6]!.value;
              acc.accBasic = (row[7] == null || row[7]!.value is String)? 0 : row[7]!.value.toDouble();
              acc.accClaims = (row[8] == null || row[8]!.value is String)? 0 : row[8]!.value.toDouble();
              acc.classification = row[10] == null ? ' ':row[10]!.value;
              acc.remarks = row[11] == null ? ' ':row[11]!.value;
              accidentsList.add(acc);
            }
          }
        }
      }
    }
    var result = [ids, accidentsList];
    sendPort.send(result);
  }catch(e){
    sendPort.send('error');
  }
}

void import5(RequiredArgs requiredArgs){
  final SendPort sendPort = requiredArgs.sendPort;
  List<String> list = requiredArgs.path!.split('\n');
  List<Hospitalization> hospitalizationList = [];
  List<String> ids = [];
  try{
    for (var e in list) {
      var file = e.replaceAll(RegExp(r'\\'), '\/');
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if(row[0] != null){
            if(row[0]!.value.toString().toUpperCase() != 'ID NO.'){
              ids.add(row[0]!.value);
              final hos = Hospitalization();
              hos.relationship = row[2] == null ? ' ':row[2]!.value;
              hos.confinee = row[3] == null ? ' ':row[3]!.value;
              hos.hospital = row[4] == null ? ' ':row[4]!.value;
              hos.doa = row[5] == null ? ' ':row[5]!.value;
              hos.dod = row[6] == null ? ' ':row[6]!.value;
              hos.hosBasic = (row[7] == null || row[7]!.value is String)? 0 : row[7]!.value.toDouble();
              hos.hosClaims = (row[8] == null || row[8]!.value is String)? 0 : row[8]!.value.toDouble();
              hos.classification = row[10] == null ? ' ':row[10]!.value;
              hos.remarks = row[11] == null ? ' ':row[11]!.value;
              hospitalizationList.add(hos);
            }
          }
        }
      }
    }
    var result = [ids, hospitalizationList];
    sendPort.send(result);
  }catch(e){
    sendPort.send('error');
  }
}

void import6(RequiredArgs requiredArgs){
  final SendPort sendPort = requiredArgs.sendPort;
  List<String> list = requiredArgs.path!.split('\n');
  List<DAC> dacList = [];
  List<String> ids = [];
  try{
    for (var e in list) {
      var file = e.replaceAll(RegExp(r'\\'), '\/');
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if(row[0] != null){
            if(row[0]!.value.toString().toUpperCase() != 'ID NO.'){
              ids.add(row[0]!.value);
              final dac = DAC();
              dac.relationship = row[2] == null ? ' ':row[2]!.value;
              dac.classification = row[3] == null ? ' ':row[3]!.value;
              dac.amount = (row[4] == null || row[4]!.value is String)? 0 : row[4]!.value.toDouble();
              dac.dod = row[5] == null ? ' ':row[5]!.value;
              dacList.add(dac);
            }
          }
        }
      }
    }
    var result = [ids, dacList];
    sendPort.send(result);
  }catch(e){
    sendPort.send('error');
  }
}

void import7(RequiredArgs requiredArgs){
  final SendPort sendPort = requiredArgs.sendPort;
  List<String> list = requiredArgs.path!.split('\n');
  List<Dental> dentalList = [];
  List<String> ids = [];
  try{
    for (var e in list) {
      var file = e.replaceAll(RegExp(r'\\'), '\/');
      var bytes = File(file).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          if(row[0] != null){
            if(row[0]!.value.toString().toUpperCase() != 'ID NO.'){
              ids.add(row[0]!.value);
              final dental = Dental();
              dental.relationship = row[2] == null ? ' ':row[2]!.value;
              dental.confinee = row[3] == null ? ' ':row[3]!.value;
              dental.clinic = row[4] == null ? ' ':row[4]!.value;
              dental.classification = row[5] == null ? ' ':row[5]!.value;
              dental.date = row[6] == null ? ' ':row[6]!.value;
              dentalList.add(dental);
            }
          }
        }
      }
    }
    var result = [ids, dentalList];
    sendPort.send(result);
  }catch(e){
    sendPort.send('error');
  }
}


