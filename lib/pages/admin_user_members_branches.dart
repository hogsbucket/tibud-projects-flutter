import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tibud_care_system/model/model.dart';

class Deatils extends StatefulWidget {
  Deatils({super.key, required this.index, this.list});
  int index;
  var list;

  @override
  State<Deatils> createState() => _DeatilsState();
}

class _DeatilsState extends State<Deatils> {
  List<UserAccount> user = [];
  List<Member> members = [];
  PlutoGridStateManager? stateManager;

  @override
  void initState() {
    // TODO: implement initState
    if(widget.index == 1){
      user = widget.list;
    }else{
      members = widget.list;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(widget.index == 1){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade900,
          title: Text('User Accounts'),
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: PlutoGrid(
            onLoaded: (PlutoGridOnLoadedEvent e){
              stateManager = e.stateManager;
              e.stateManager.setShowColumnFilter(true);
            },
            configuration: PlutoGridConfiguration(
              columnFilter: PlutoGridColumnFilterConfig(
                filters: const [
                  ...FilterHelper.defaultFilters,
                ],
                resolveDefaultColumnFilter: (column, resolver) {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                },
              ),
              style: PlutoGridStyleConfig(
                activatedBorderColor: Colors.green.shade900,
                activatedColor: Colors.green.shade100,
                gridBorderColor: Colors.green.shade900,
                rowHeight: 25,
                columnHeight: 30,
                columnTextStyle: GoogleFonts.dosis(
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)
                ),
                cellTextStyle: GoogleFonts.dosis(
                  textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                ),
              )
            ),
            columns: [
              PlutoColumn(
                title: 'Name',
                field: 'name',
                type: PlutoColumnType.text(),
                width: 250
              ),
              PlutoColumn(
                title: 'ID No.',
                field: 'id',
                type: PlutoColumnType.text(),
                width: 150
              ),
              PlutoColumn(
                title: 'User Account',
                field: 'user',
                type: PlutoColumnType.text(),
                width: 250              ),
              PlutoColumn(
                title: 'Password',
                field: 'password',
                type: PlutoColumnType.text(),
                frozen: PlutoColumnFrozen.start,
                width: 250
              ),
            ],
            rows: userRows(),
          ),
        ),
      );
    }else if(widget.index == 2){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade900,
          title: Text('Members'),
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: PlutoGrid(
            onLoaded: (PlutoGridOnLoadedEvent e){
              stateManager = e.stateManager;
              e.stateManager.setShowColumnFilter(true);
            },
            configuration: PlutoGridConfiguration(
              columnFilter: PlutoGridColumnFilterConfig(
                filters: const [
                  ...FilterHelper.defaultFilters,
                ],
                resolveDefaultColumnFilter: (column, resolver) {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                },
              ),
              style: PlutoGridStyleConfig(
                activatedBorderColor: Colors.green.shade900,
                activatedColor: Colors.green.shade100,
                gridBorderColor: Colors.green.shade900,
                rowHeight: 25,
                columnHeight: 30,
                columnTextStyle: GoogleFonts.dosis(
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)
                ),
                cellTextStyle: GoogleFonts.dosis(
                  textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                ),
              )
            ),
            columns: [
              PlutoColumn(
                title: 'ID No.',
                field: 'id',
                type: PlutoColumnType.text(),
                width: 250
              ),
              PlutoColumn(
                title: 'Name',
                field: 'name',
                type: PlutoColumnType.text(),
                width: 250
              ),
              PlutoColumn(
                title: 'Date of Hire',
                field: 'doh',
                type: PlutoColumnType.text(),
                width: 250             
              ),
              PlutoColumn(
                title: 'branch',
                field: 'branch',
                type: PlutoColumnType.text(),
                width: 250             
              ),
            ],
            rows: memberRows(),
          ),
        ),
      );
    }else{
      return Container();
    }
  }

  List<PlutoRow> userRows(){
    List<PlutoRow> rows = [];
    for (var index in user) {
      rows.add(
        PlutoRow(
          cells: {
            'name': PlutoCell(value: index.name),
            'id': PlutoCell(value: index.idno),
            'user': PlutoCell(value: index.username),
            'password' : PlutoCell(value: index.password),
          },
        ),
      );
    }
    return rows;
  }

  List<PlutoRow> memberRows(){
    List<PlutoRow> rows = [];
    for (var index in members) {
      rows.add(
        PlutoRow(
          cells: {
            'name': PlutoCell(value: index.member),
            'id': PlutoCell(value: index.idno),
            'doh': PlutoCell(value: index.dateOfHire),
            'branch' : PlutoCell(value: index.branch),
          },
        ),
      );
    }
    return rows;
  }

}