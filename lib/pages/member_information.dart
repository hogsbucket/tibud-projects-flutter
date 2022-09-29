import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tibuc_care_system/model/model.dart';
import 'package:tibuc_care_system/pages/add_dialog.dart';
import 'package:tibuc_care_system/pages/loading.dart';
import 'package:tibuc_care_system/server/server.dart';
import 'package:tibuc_care_system/utils/constant.dart';
import 'package:tibuc_care_system/utils/datatable.dart';
import 'package:tibuc_care_system/utils/window_buttons.dart';

class Information extends StatefulWidget {
  Information({super.key, required this.info, required this.user});
  Member info;
  UserAccount user;

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> with TickerProviderStateMixin {
  Member member = Member();
  static GlobalKey<FormState> keyDashboard1 = GlobalKey<FormState>();
  static GlobalKey<FormState> keyLaboratory1 = GlobalKey<FormState>();
  static GlobalKey<FormState> keyAccidents1 = GlobalKey<FormState>();
  static GlobalKey<FormState> keyHospitalization1 = GlobalKey<FormState>();
  static GlobalKey<FormState> keyDAC1 = GlobalKey<FormState>();
  static GlobalKey<FormState> keyDental1 = GlobalKey<FormState>();
  static GlobalKey<FormState> keyConsultation1 = GlobalKey<FormState>();
  static GlobalKey<FormState> keyBeneficiary = GlobalKey<FormState>();

  late PlutoGridStateManager stateManagerBeneficiary;
  late PlutoGridStateManager stateManager;

  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeIn,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.05),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.easeIn,
  ));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.forward();
    member = widget.info;
    name.text = member.member!;
    idno.text = member.idno!;
    branch.text = member.branch!;
    doh.text = member.dateOfHire!;
    total = (member.contributions != []) ? member.contributions.fold(0, (sum, contribution) => sum.toDouble() + contribution.amount!) : 0;
    ben = member.direct;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final name = TextEditingController();
  final idno = TextEditingController();
  final branch = TextEditingController();
  final doh = TextEditingController();
  final newContribution = TextEditingController();
  final newDate = TextEditingController();
  double total = 0;

  void closeDialog(){
    Navigator.pop(context);
  }

  void errorMsg(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: 
          Text(
            'Invalid DATE or AMOUNT. Please try again',
            style: GoogleFonts.dosis(
              textStyle: TextStyle(fontSize: 15, color: Colors.white)
            ), 
          )
      ),
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
      body: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Member Information',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(fontSize: size.width * .02, color: Colors.black, letterSpacing: 5)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5
                      ),
                      child: SizedBox(
                        height: size.height * .08,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: name,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .013, color: Colors.black)
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
                                width: 2
                              )
                            ),
                            labelText: 'NAME',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5
                      ),
                      child: SizedBox(
                        height: size.height * .08,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: idno,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.black)
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
                                width: 2
                              )
                            ),
                            labelText: 'ID No.',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5
                      ),
                      child: SizedBox(
                        height: size.height * .08,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: branch,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.black)
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
                                width: 2
                              )
                            ),
                            labelText: 'BRANCH',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5
                      ),
                      child: SizedBox(
                        height: size.height * .08,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: doh,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.black)
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
                                width: 2
                              )
                            ),
                            labelText: 'DATE OF HIRE',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10
                      ),
                      child: Text(
                        'NET TOTAL: ${total.toStringAsFixed(2)}',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .015, color: Colors.black, letterSpacing: 5)
                        ),
                      ),
                    ),
                    Text(
                      'Beneficiaries',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(fontSize: size.width * .01, color: Colors.black, letterSpacing: 5)
                      ),
                    ),
                    SizedBox(
                      width: size.width * .3,
                      height: size.height * .25,
                      child: PlutoGrid(
                        key: keyBeneficiary,
                        onLoaded: (event) => stateManagerBeneficiary = event.stateManager,
                        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent e){
                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                    BorderRadius.all(
                                      Radius.circular(10.0))
                                ),
                                title: Text(
                                  'Remove Beneficiary',
                                  style: GoogleFonts.dosis(
                                    textStyle: const TextStyle(fontSize: 30, color: Colors.black)
                                  ),
                                ),
                                content: Builder(
                                  builder: (context){
                                    return SizedBox(
                                      height: size.height * .15,
                                      width: size.width * .1,
                                      child: Center(
                                        child: Text(
                                          'Do you wish to remove this beneficiary?',
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.black)
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
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "CLOSE",
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: 20, color: Colors.red.shade900)
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
                                        backgroundColor: MaterialStateProperty.all(Colors.red.shade900),
                                      ),
                                      onPressed: () {
                                        removeFromDatabase(e.cell!.row.cells.values.first.value, member.id, widget.user);
                                        fetchBeneficiaries(member.id);
                                        stateManagerBeneficiary.removeCurrentRow();
                                        closeDialog();
                                      },
                                      child: Text(
                                        "REMOVE",
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
                        },
                        configuration: PlutoGridConfiguration(
                          style: PlutoGridStyleConfig(
                            activatedBorderColor: Colors.green.shade900,
                            activatedColor: Colors.green.shade100,
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
                          ),
                          PlutoColumn(
                            title: 'Relationship',
                            field: 'relationship',
                            type: PlutoColumnType.text(),
                          ),
                          PlutoColumn(
                            title: 'Age',
                            field: 'age',
                            type: PlutoColumnType.text(),
                            width: 100
                          ),
                          PlutoColumn(
                            title: 'Role',
                            field: 'role',
                            type: PlutoColumnType.text(),
                          ),
                        ],
                        rows: beneficiaryList()
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: ButtonStyle(
                          surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context, 
                            builder: (context) => AddNewData(index: 7, memberID: member.idno!, userAccount: widget.user,)
                          );
                          final int lastIndex = stateManagerBeneficiary.refRows.originalList.length;
                          if(beneficaryName != null && beneficiaryRelation != null && beneficiaryAge != null && beneficiaryRole != null){
                            stateManagerBeneficiary.insertRows(
                              lastIndex, 
                              [
                                PlutoRow(
                                  cells: {
                                    'name': PlutoCell(value: beneficaryName.toString().toUpperCase()),
                                    'relationship': PlutoCell(value: beneficiaryRelation.toString().toUpperCase()),
                                    'age': PlutoCell(value: beneficiaryAge.toString().toUpperCase()),
                                    'role': PlutoCell(value: beneficiaryRole.toString().toUpperCase()),
                                  },
                                ),
                              ]
                            );
                            beneficaryName = '';
                            beneficiaryRelation = '';
                            beneficiaryAge = '';
                            beneficiaryRole = '';
                          }
                        }, 
                        child: Text(
                          "+ Add New Beneficiary",
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: ButtonStyle(
                          surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context, 
                            builder: (context){
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                    BorderRadius.all(
                                      Radius.circular(10.0))
                                ),
                                title: Text(
                                  'Insert Contribution',
                                  style: GoogleFonts.dosis(
                                    textStyle: const TextStyle(fontSize: 30, color: Colors.black)
                                  ),
                                ),
                                content: Builder(
                                  builder: (context){
                                    return SizedBox(
                                      height: size.height * .2,
                                      width: size.width * .2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            height: size.height * .08,
                                            width: size.width * .3,
                                            child: TextFormField(
                                              controller: newContribution,
                                              style: GoogleFonts.dosis(
                                                textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey.shade200,
                                                labelText: 'CONTRIBUTION',
                                                labelStyle: GoogleFonts.dosis(
                                                  textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                                ),
                                              ),
                                            )
                                          ),         
                                          SizedBox(
                                            height: size.height * .08,
                                            width: size.width * .3,
                                            child: TextFormField(
                                              controller: newDate,
                                              style: GoogleFonts.dosis(
                                                textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                              ),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey.shade200,
                                                hintText: 'MM/DD/YYYY',
                                                hintStyle: GoogleFonts.dosis(
                                                  textStyle: TextStyle(fontSize: size.width * .009, color: Colors.grey.shade400,)
                                                ),
                                                labelText: 'DATE OF CONTRIBUTION',
                                                labelStyle: GoogleFonts.dosis(
                                                  textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                                ),
                                              ),
                                            )
                                          ),
                                        ],
                                      ),
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
                                        newContribution.text = '';
                                        newDate.text = '';
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "CLOSE",
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: 20, color: Colors.green.shade900,)
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
                                        backgroundColor: MaterialStateProperty.all(Colors.green.shade900,),
                                      ),
                                      onPressed: (){
                                        if(newContribution.text.isNotEmpty && newDate.text.isNotEmpty){
                                          try{
                                            var date = newDate.text.isNotEmpty?DateFormat.yMd('en_US').parse(newDate.text).toString().toUpperCase():'';
                                            setState(() {
                                              member.contributions.add(Contributions()..amount = (newContribution.text == '')? 0 : double.parse(newContribution.text) ..date = date);
                                              updateMember(member, widget.user);
                                              final int lastIndex = stateManagerBeneficiary.refRows.originalList.length;
                                              DateTime date1 = DateFormat.yMd('en_US').parse(newDate.text);
                                              var day = DateFormat.yMMMMd().format(date1).toString();
                                              stateManager.insertRows(
                                                lastIndex, 
                                                [
                                                  PlutoRow(
                                                    cells: {
                                                      'date': PlutoCell(value: day.toUpperCase()),
                                                      'amount': PlutoCell(value: newContribution.text.toUpperCase()),
                                                    },
                                                  ),
                                                ]
                                              );
                                            });
                                            newContribution.text = '';
                                            newDate.text = '';
                                            Navigator.pop(context);
                                          }catch(e){
                                            errorMsg();
                                          }
                                        }else{
                                          errorMsg();
                                        }
                                      },
                                      child: Text(
                                        "Add",
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
                        }, 
                        child: Text(
                          "+ Add New Contribution",
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: SizedBox(
                        height: size.height * .1,
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              onPressed: (){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => Loading(uname: widget.user.username!, passwrd: widget.user.password!)
                                  ),
                                );
                              }, 
                              child: Text(
                                "Return to Dashboard",
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * .15,
                              height: size.height * .05,
                              child: ElevatedButton(
                                statesController: MaterialStatesController(),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green.shade900,),
                                ),
                                onPressed: (){
                                  member.member = name.text.toUpperCase();
                                  member.idno = idno.text.toUpperCase();
                                  member.branch = branch.text.toUpperCase();
                                  member.dateOfHire = doh.text.toUpperCase();
                                  updateMember(member, widget.user);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (context) => Loading(uname: widget.user.username!, passwrd: widget.user.password!)
                                    ),
                                  );
                                },
                                child: Text(
                                  "SAVE",
                                  style: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .015, color: Colors.white)
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 30,
                    right: 20
                  ),
                  child: DefaultTabController(
                    length: 7,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(
                              child: Text(
                                'Contribution',
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .009, color: Colors.black)
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Consultation',
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .009, color: Colors.black)
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Laboratory',
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .009, color: Colors.black)
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Hospitalization',
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .009, color: Colors.black)
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Accidents',
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .009, color: Colors.black)
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Death Aid Assistants',
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .009, color: Colors.black)
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Dental',
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .009, color: Colors.black)
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              //----Premium----
                              SizedBox(
                                width: double.infinity,
                                height: size.height * .12,
                                child: PlutoGrid(
                                  key: keyDashboard1,
                                  onLoaded: (event) => stateManager = event.stateManager,
                                  configuration: PlutoGridConfiguration(
                                    style: PlutoGridStyleConfig(
                                      activatedBorderColor: Colors.green.shade900,
                                      activatedColor: Colors.green.shade100,
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
                                      title: 'Date',
                                      field: 'date',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Amount',
                                      field: 'amount',
                                      type: PlutoColumnType.text(),
                                    ),
                                  ],
                                  rows: infoDashRow(member)
                                ),
                              ),
                              //----Consultation----
                              SizedBox(
                                width: double.infinity,
                                height: size.height * .12,
                                child: PlutoGrid(
                                  key: keyConsultation1,
                                  configuration: PlutoGridConfiguration(
                                    style: PlutoGridStyleConfig(
                                      activatedBorderColor: Colors.green.shade900,
                                      activatedColor: Colors.green.shade100,
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
                                      title: 'Confinee',
                                      field: 'confinee',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Relationship',
                                      field: 'relationship',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Hospital',
                                      field: 'hospital',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'DOC',
                                      field: 'doc',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'DOD',
                                      field: 'dod',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Basic',
                                      field: 'basic',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Claims',
                                      field: 'claims',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Balance',
                                      field: 'balance',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Classification',
                                      field: 'classification',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Remarks',
                                      field: 'remarks',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Diagnosis',
                                      field: 'diagnosis',
                                      type: PlutoColumnType.text(),
                                    ),
                                  ],
                                  rows: memberConsultRow(member.id)
                                ),
                              ),
                              //----Laboratory----
                              SizedBox(
                                width: double.infinity,
                                height: size.height * .12,
                                child: PlutoGrid(
                                  key: keyLaboratory1,
                                  configuration: PlutoGridConfiguration(
                                    style: PlutoGridStyleConfig(
                                      activatedBorderColor: Colors.green.shade900,
                                      activatedColor: Colors.green.shade100,
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
                                      title: 'Confinee',
                                      field: 'confinee',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Relationship',
                                      field: 'relationship',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Hospital',
                                      field: 'hospital',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'DOL',
                                      field: 'dol',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Basic',
                                      field: 'basic',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Claims',
                                      field: 'claims',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Balance',
                                      field: 'balance',
                                      type: PlutoColumnType.text(),
                                    ),
                                  ],
                                  rows: memberLabRow(member.id)
                                ),
                              ),
                              //----Hospitalization----
                              SizedBox(
                                width: double.infinity,
                                height: size.height * .12,
                                child: PlutoGrid(
                                  key: keyHospitalization1,
                                  configuration: PlutoGridConfiguration(
                                    style: PlutoGridStyleConfig(
                                      activatedBorderColor: Colors.green.shade900,
                                      activatedColor: Colors.green.shade100,
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
                                      title: 'Confinee',
                                      field: 'confinee',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Relationship',
                                      field: 'relationship',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Hospital',
                                      field: 'hospital',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'DOA',
                                      field: 'doa',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'DOD',
                                      field: 'dod',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Basic',
                                      field: 'basic',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Claims',
                                      field: 'claims',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Balance',
                                      field: 'balance',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Classification',
                                      field: 'classification',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Remarks',
                                      field: 'remarks',
                                      type: PlutoColumnType.text(),
                                    ),
                                  ],
                                  rows: memberHosRow(member.id)
                                ),
                              ),
                              //----Acciddents----
                              SizedBox(
                                width: double.infinity,
                                height: size.height * .12,
                                child: PlutoGrid(
                                  key: keyAccidents1,
                                  configuration: PlutoGridConfiguration(
                                    style: PlutoGridStyleConfig(
                                      activatedBorderColor: Colors.green.shade900,
                                      activatedColor: Colors.green.shade100,
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
                                      title: 'Confinee',
                                      field: 'confinee',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Relationship',
                                      field: 'relationship',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Hospital',
                                      field: 'hospital',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'DOC',
                                      field: 'doc',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'DOD',
                                      field: 'dod',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Basic',
                                      field: 'basic',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Claims',
                                      field: 'claims',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Balance',
                                      field: 'balance',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Classification',
                                      field: 'classification',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Remarks',
                                      field: 'remarks',
                                      type: PlutoColumnType.text(),
                                    ),
                                  ],
                                  rows: memberAccRow(member.id)
                                ),
                              ),
                              //----DAC----
                              SizedBox(
                                width: double.infinity,
                                height: size.height * .12,
                                child: PlutoGrid(
                                  key: keyDAC1,
                                  configuration: PlutoGridConfiguration(
                                    style: PlutoGridStyleConfig(
                                      activatedBorderColor: Colors.green.shade900,
                                      activatedColor: Colors.green.shade100,
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
                                      title: 'Relationship',
                                      field: 'relationship',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Classification',
                                      field: 'classification',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Amount',
                                      field: 'amount',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'DOD',
                                      field: 'dod',
                                      type: PlutoColumnType.text(),
                                    ),
                                  ],
                                  rows: memberDACRow(member.id)
                                ),
                              ),
                              //----Dental----
                              SizedBox(
                                width: double.infinity,
                                height: size.height * .12,
                                child: PlutoGrid(
                                  key: keyDental1,
                                  configuration: PlutoGridConfiguration(
                                    style: PlutoGridStyleConfig(
                                      activatedBorderColor: Colors.green.shade900,
                                      activatedColor: Colors.green.shade100,
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
                                      title: 'Patient',
                                      field: 'patient',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Relationship',
                                      field: 'relationship',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Clinic',
                                      field: 'clinic',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Classification',
                                      field: 'classification',
                                      type: PlutoColumnType.text(),
                                    ),
                                    PlutoColumn(
                                      title: 'Date',
                                      field: 'date',
                                      type: PlutoColumnType.text(),
                                    ),
                                  ],
                                  rows: memberDentalRow(member.id)
                                ),
                              ),
                  
                            ],
                          )
                        )
                      ],
                    ),
                  )
                )
              )
            ],
          ),
        ),
      )
    );
  }
}