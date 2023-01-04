import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tibud_care_system/model/model.dart';
import 'package:tibud_care_system/server/server.dart';
import 'package:tibud_care_system/utils/constant.dart';
import 'package:tibud_care_system/utils/window_buttons.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;

class TotalPerPayroll extends StatefulWidget {
  TotalPerPayroll({super.key, required this.list, required this.user});
  List<String> list;
  UserAccount user;

  @override
  State<TotalPerPayroll> createState() => _TotalPerPayrollState();
}

class _TotalPerPayrollState extends State<TotalPerPayroll> {
  late PlutoGridStateManager stateManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    branch = widget.list[0];
  }

  Future<void> loading() async {
    showDialog(
      context: context,
      builder: (context){
        Future.delayed(Duration(seconds: 2), () {
          allActivity('Exported Full Data to csv', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
          Navigator.of(context).pop();
        });
        return AlertDialog(
          shape: const RoundedRectangleBorder(
          borderRadius:
            BorderRadius.all(
              Radius.circular(10.0))),
          content: Builder(
            builder: (context) {                         
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
                          'Saving data. Please wait....',
                          style: GoogleFonts.robotoMono(
                            textStyle: const TextStyle(
                              fontSize: 15
                            )
                          ),
                        )
                      ],
                  )
                ),
              );
            },
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        leadingWidth: 200,
        toolbarHeight: 30,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Tibud Care System',
            style: GoogleFonts.dosis(
              textStyle: const TextStyle(fontSize: 12, color: Colors.white, letterSpacing: 5)
            ),
          ),
        ),
        title: SizedBox(
          width: size.width,
          child: WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(child: MoveWindow()),
              ],
            ),
          ),
        ),
        actions: const [
          Windowbuttons()
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'LOGOUT',
                    splashRadius: 25,
                    onPressed: (){
                      allActivity('return back to dashboard', '[admin]', 'admin35460901904','[admin]','[admin]');
                      Navigator.pop(context);
                    }, 
                    icon: const Icon(Icons.arrow_back)
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    'Full Data per Branch',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(fontSize: size.width * .02, color: Colors.black, letterSpacing: 5)
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20
              ),
              child: Row(
                children: [
                  DropdownButton(
                    focusColor: Colors.white,
                    value: branch,
                    items: widget.list.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        branch = newValue!;
                      });
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: size.width * .09,
                    height: 30,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                      ),
                      onPressed: () async {
                        loading();
                        var exported = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager));
                        await FileSaver.instance.saveFile('$branch Data', exported, "csv");
                      },
                      child: Text(
                        "EXPORT TO CSV",
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white)
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: PlutoGrid(
                  key: UniqueKey(),
                  onLoaded: (PlutoGridOnLoadedEvent e){
                    stateManager = e.stateManager;
                  },
                  configuration: PlutoGridConfiguration(
                    style: PlutoGridStyleConfig(
                      activatedBorderColor: Colors.green.shade900,
                      activatedColor: Colors.green.shade100,
                      gridBorderColor: Colors.green.shade900,
                      rowHeight: 25,
                      columnHeight: 30,
                      columnTextStyle: GoogleFonts.zenMaruGothic(
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)
                      ),
                      cellTextStyle: GoogleFonts.zenMaruGothic(
                        textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                      ),
                    )
                  ),
                  columns: dataCol(),
                  rows: dataRow(),
                  columnGroups: dataColGroup(),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  List<PlutoColumnGroup> dataColGroup(){
    List<PlutoColumnGroup> list  = [];
    var dates = [];
    list.add(
      PlutoColumnGroup(
        title: 'Member',
        fields: ['idno', 'name'],
      ),
    );
    for (var x in members) {
      if(x.branch == branch){
        for (var e in x.contributions) {
          if(!dates.contains(e.date)){
            dates.add(e.date);
          }
        }
      }
    }
    dates.sort((a,b) => a.compareTo(b));
    for (var i = 0; i < dates.length; i++) {
      double total = 0;
      for (var x in members) {
        if(x.branch == branch){
          var k = x.contributions.where((element) => element.date == dates[i]).toList();
          if(k.isEmpty){
            total += 0;
          }else{
            total += k[0].amount!;
          }
        }
      }
      list.add(
        PlutoColumnGroup(
          title: NumberFormat('#,###,##0.00#', 'en_US').format(total).toString(),
          fields: ['dates$i'],
        )
      );
    }
    return list;
  }

  List<PlutoColumn> dataCol(){
    var dates = [];
    List<PlutoColumn> col = [
      PlutoColumn(
        title: 'ID No.',
        field: 'idno',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
        width: 150
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        frozen: PlutoColumnFrozen.start,
        width: 170
      ),
    ];
    for (var x in members) {
      if(x.branch == branch){
        for (var e in x.contributions) {
          dates.add(e.date);
        }
        final ids = Set();
        dates.retainWhere((x) => ids.add(x));
      }
    }
    dates.sort((a,b) => a.compareTo(b));
    for (var i = 0; i < dates.length; i++) {
      DateTime date = DateTime.parse(dates[i]);
      var day = DateFormat.yMMMMd().format(date);
      col.add(
        PlutoColumn(
          textAlign: PlutoColumnTextAlign.end,
          title: day,
          field: 'dates$i',
          type: PlutoColumnType.text(),
          width: 200,
          
        ),
      );
    }
    return col;
  }


  List<PlutoRow> dataRow(){
    List<PlutoRow> rows = [];
    var dates = [];
    for (var x in members) {
      if(x.branch == branch){
        for (var e in x.contributions) {
          dates.add(e.date);
        }
        final ids = Set();
        dates.retainWhere((x) => ids.add(x));
      }
    }
    dates.sort((a,b) => a.compareTo(b));
    for (var x in members) {
      if(x.branch == branch){
        rows.add(
          PlutoRow(
            cells: cells(x.idno!, x.member!, x.contributions, dates)
          ),
        );
      }
    }
    return rows;
  }
  
  Map<String, PlutoCell> cells(String id, String name, List<Contributions> con, var dates){
    Map<String, PlutoCell> cell = {
      'idno': PlutoCell(value: id),
      'name': PlutoCell(value: name),
    };
    for (var i = 0; i < dates.length; i++) {
      double value = 0.0;
      for (var e in con) {
        if(e.date == dates[i]){
          value = e.amount!;
        }
      }
      if(value == 0){
        cell.addAll(
          {'dates$i': PlutoCell(value: '-'),}
        );
      }else{
        cell.addAll(
          {'dates$i': PlutoCell(value: NumberFormat('#,###,##0.00#', 'en_US').format(value)),}
        );
      }
    }
    return cell;
  }
}