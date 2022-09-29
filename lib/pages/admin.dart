import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tibud_care_system/server/server.dart';
import 'package:tibud_care_system/utils/constant.dart';
import 'package:tibud_care_system/utils/window_buttons.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {

  final controller = TextEditingController();
  bool searchIcon = true;
  late PlutoGridStateManager stateManager;
  static GlobalKey<FormState> key = GlobalKey<FormState>();

  Future<void> filterList(String search) async {
    activities = await queryActivityList(search);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        leadingWidth: 150,
        toolbarHeight: 30,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Tibud Care System',
            style: GoogleFonts.dosis(
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)
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
      body: Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: size.width,
                height: 50,
                child: ListTile(
                  title: Text(
                    'ADMINISTRATOR',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(fontSize: size.width * .025, color: Colors.black, letterSpacing: 5)
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: 'LOGOUT',
                    splashRadius: 25,
                    onPressed: (){
                      allActivity('admin logout', '[admin]');
                      Navigator.pop(context);
                    }, 
                    icon: const Icon(Icons.logout)
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: SizedBox(
                  width: size.width,
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
                        title: 'All ACTIVITY',
                        field: 'activity',
                        type: PlutoColumnType.text(),
                        width: size.width * .65
                      ),
                      PlutoColumn(
                        title: 'USER ACCOUNT',
                        field: 'user',
                        type: PlutoColumnType.text(),
                        width: 170
                      ),
                      PlutoColumn(
                        title: 'DATE AND TIME',
                        field: 'datetime',
                        type: PlutoColumnType.text(),
                        width: 200
                      ),
                    ],
                    rows: rows(),
                  ),
                )
              )
            ],
          ),
        ],
      ),
    );
  }

  List<PlutoRow> rows(){
    List<PlutoRow> rows = [];
    for (var index in activities.reversed) {
      rows.add(
        PlutoRow(
          cells: {
            'activity': PlutoCell(value: index.activity),
            'user': PlutoCell(value: index.userAccount),
            'datetime': PlutoCell(value: DateFormat.yMEd().add_jms().format(index.date!)),
          },
        ),
      );
    }
    return rows;
  }
}