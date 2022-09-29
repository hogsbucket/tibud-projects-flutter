import 'dart:async';
import 'dart:io';

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
  

  Future<void> excelRead(String path) async {
    String date = '';
    List<String> list = path.split('\n');
    
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
              final mem = await getMember(row[0] == null ? ' ':row[0]!.value, user);
              if(mem != null){
                addNewContribution(mem.id, (row[2] == null || row[2]!.value is String)? 0 : row[2]!.value.toDouble(), date, user);
              }else{
                Member member = Member();
                member.idno = row[0] == null ? ' ':row[0]!.value;
                member.member = row[1] == null ? ' ':row[1]!.value;
                member.dateOfHire = row[3] == null ? ' ':row[3]!.value;
                member.branch = row[4] == null ? ' ':row[4]!.value;
                member.contributions.add(Contributions()..amount = (row[2] == null || row[2]!.value is String)? 0 : row[2]!.value.toDouble() ..date = date);
                allActivity('added new contribution for member: ${member.member} with amount: ${(row[2] == null || row[2]!.value is String)? 0 : row[2]!.value.toDouble()}', user.name!);
                insertMembers(member, user);
              }
            }
          }
        }
      }
    }
    members = await getAllMember();
  }

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
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  )
                )
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
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  )
                )
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
              await excelRead(_paths);
              exit();
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


