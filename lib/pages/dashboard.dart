import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;
import 'package:tibud_care_system/model/model.dart';
import 'package:tibud_care_system/pages/add_dialog.dart';
import 'package:tibud_care_system/pages/import.dart';
import 'package:tibud_care_system/pages/loading.dart';
import 'package:tibud_care_system/pages/print_original.dart';
import 'package:tibud_care_system/server/server.dart';
import 'package:tibud_care_system/utils/constant.dart';
import 'package:tibud_care_system/utils/datatable.dart';
import 'package:tibud_care_system/utils/window_buttons.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, required this.user}) : super(key: key);
  UserAccount user;
  final String? restorationId = 'main';
  
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin, RestorationMixin{

  final ScrollController scrollcontroller1 = ScrollController();
  final ScrollController scrollcontroller2 = ScrollController();
  final ScrollController scrollcontroller3 = ScrollController();
  final ScrollController scrollcontroller4 = ScrollController();
  final ScrollController scrollcontroller5 = ScrollController();

  final name = TextEditingController();
  final idno = TextEditingController();
  final uname = TextEditingController();
  final passwrd = TextEditingController();
  final resetPassword = TextEditingController();
  final confirm = TextEditingController();
  final newID = TextEditingController();
  final newMember = TextEditingController();
  final newContribution = TextEditingController();
  final newBranch = TextEditingController();
  final newContributionDate = TextEditingController();
  final newDateOfHire = TextEditingController();


  bool passwordEnabled = false;

  late PlutoGridStateManager stateManager;
  late PlutoGridStateManager stateManager1;
  late PlutoGridStateManager stateManager2;
  late PlutoGridStateManager stateManager3;
  late PlutoGridStateManager stateManager4;
  late PlutoGridStateManager stateManager5;
  late PlutoGridStateManager stateManager6;

  final operationHead = TextEditingController();
  final postingClerk = TextEditingController();
  final amount = TextEditingController();
  final subjectOfHospitalization = TextEditingController();
  final confinee = TextEditingController();
  final notInTheListHospital = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool change = false;
  bool hospitalTextField = false;
  String dropdownvalue = 'BONTUYAN MEDICAL HOSPITAL, INC.';
  var hospital = [   
    'BONTUYAN MEDICAL HOSPITAL, INC.',
    'CAINGLET MEDICAL HOSPITAL, INC.',
    'CALUMPANG LAVELIA MEDICAL CENTER, INC.',
    'DAVAO MEDIQUEST HOSPITAL, INC.',
    'DR. LORENZO B. PRINCIPE CLINIC & DRUGSTORE, INC',
    'DR. ROGELIO M. GARCIA MEMORIAL HOSPITAL',
    'GENERAL SANTOS DOCTORS\' HOSPITAL',
    'GENERAL MEDICAL HOSPITAL',
    'GONZALES MARANAN MEDICAL CENTER INCORPORATED',
    'HERAMIL HOSPITAL',
    'HOWARD HUBBARD MEMORIAL HOSPITAL',
    'J CARES OCCUPATIONAL HEALTH & MEDICAL CLINIC',
    'MALTA MEDICAL CENTER, INC.',
    'MedCORE HOSPITAL, INC.',
    'MINDANAO MEDICAL CENTER, INC.',
    'REYES EYE CLINIC',
    'RIVERA MEDICAL CENTER, INC.',
    'SOCKSARGEN COUNTY HOSPITAL',
    'SOMOSO GENERAL HOSPITAL, INC.',
    'DAVAO MEDICAL SCHOOL FOUNDATION HOSPITAL',
    'ST. ELIZABETH HOSPITAL, INC.',
    'BRENT HOSPITAL AND COLLEGES INCORPORATED',
    'POLOMOLOK DIAGNOSTIC CENTER & PHARMACY INC.',
    'MEDZONE DIAGNOSTIC CENTER',
    'ADVENTIST MEDICAL CENTER OF ILIGAN-TUPI BRANCH',
    'SOCOMEDECS HOSPITAL',
    'GAGATAM CLINIC',
    'SARANGANI BAY SPECIALIST MEDICAL CENTER',
    'ST. JOHN OF THE CROSS HOSPITAL',
    'OTHER',
  ];

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
  bool searchIcon = true;
  Future<List<String>>? future;
  int futureListLength = 0;

  final searchText = TextEditingController();
  static GlobalKey<FormState> keyDashboard = GlobalKey<FormState>();
  static GlobalKey<FormState> keyLaboratory = GlobalKey<FormState>();
  static GlobalKey<FormState> keyAccidents = GlobalKey<FormState>();
  static GlobalKey<FormState> keyHospitalization = GlobalKey<FormState>();
  static GlobalKey<FormState> keyDAC = GlobalKey<FormState>();
  static GlobalKey<FormState> keyDental = GlobalKey<FormState>();
  static GlobalKey<FormState> keyConsultation = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.forward();
    name.text = widget.user.name!;
    idno.text = widget.user.idno!;
    uname.text = widget.user.username!;
    passwrd.text = widget.user.password!;
    fetchMembers();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> filterList(String search) async {
    members = await queryDashList(search);
  }

  Future<void> filterConsultList(String search) async {
    consultation = await queryConsultList(search);
  }

  Future<void> filterLabList(String search) async {
    laboratory = await queryLabList(search);
  }

  Future<void> filterAccList(String search) async {
    accidents = await queryAccList(search);
  }

  Future<void> filterHosList(String search) async {
    hospitalization = await queryHosList(search);
  }

  Future<void> filterDACList(String search) async {
    dac = await queryDACList(search);
  }

  Future<void> filterDentalList(String search) async {
    dental= await queryDentalList(search);
  }

  Future<void> filterAllList() async {
    members = await queryDashList('');
    consultation = await queryConsultList('');
    laboratory = await queryLabList('');
    accidents = await queryAccList('');
    hospitalization = await queryHosList('');
    dac = await queryDACList('');
    dental= await queryDentalList('');
  }

  Future<void> loading() async {
    showDialog(
      context: context,
      builder: (context){
        Future.delayed(Duration(seconds: 2), () {
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

  Future<void> printLOG(String name, String to, String amountInNum, String amountInWords, String dependent) async {
    Size size = MediaQuery.of(context).size;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.vollkornBold();
    final font2 = await PdfGoogleFonts.newsreaderBold();
    final font3 = await PdfGoogleFonts.newsreaderRegular();

    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.zero,
        ),
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: double.infinity,
                height: 90,
              ),
              pw.Text(
                'LETTER OF GUARANTEE',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 20,
                  letterSpacing: 2,
                  wordSpacing: 3,
                  color: PdfColors.white
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(20),
                  child:
                   pw.RichText(
                    text: pw.TextSpan(
                      text: 'Date:   ',
                      style: pw.TextStyle(
                        font: font2,
                        fontSize: 12,
                        color: PdfColors.white
                      ),
                      children: [
                        pw.WidgetSpan(
                          child: pw.Text(
                            DateFormat.yMMMMd().format(DateTime.now()),
                            style: pw.TextStyle(
                              font: font2,
                              fontSize: 9,
                            )
                          )
                        )
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
                        color: PdfColors.white
                      ),
                      children: [
                        pw.WidgetSpan(
                          child: pw.Text(
                            to,
                            style: pw.TextStyle(
                              font: font2,
                              fontSize: 9,
                            )
                          )
                        )
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
                        color: PdfColors.white
                      ),
                      children: [
                        pw.TextSpan(
                          text: '', 
                          style: pw.TextStyle(
                            font: font2,
                            fontSize: 12,
                            color: PdfColors.white
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
                      text: '',
                      style: pw.TextStyle(
                        font: font3,
                        fontSize: 12,
                        lineSpacing: 10,
                      ),
                      children: [
                        pw.TextSpan(
                          text: 'This is to certify that   ',
                          style: pw.TextStyle(
                            font: font3,
                            fontSize: 12,
                            color: PdfColors.white
                          ),
                        ),
                        pw.WidgetSpan(
                          child: pw.Text(
                            name,
                            style: pw.TextStyle(
                              font: font2,
                              fontSize: 9,
                            )
                          )
                        ),
                        pw.TextSpan(
                          text: '   is a bonafide member of  "TIBUD CARE".\nThe Cooperative Medical Fund System of Tibud Sa Katibawasan Multi-Purpose Cooperative. He or she entitled to a limit amounting  ', 
                          style: pw.TextStyle(
                            font: font3,
                            fontSize: 12,
                            color: PdfColors.white
                          )
                        ),
                        pw.WidgetSpan(
                          child: pw.Text(
                            amountInWords,
                            style: pw.TextStyle(
                              font: font2,
                              fontSize: 9,
                            )
                          )
                        ),
                        pw.TextSpan(
                          text: '\n(P ', 
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 12,
                            color: PdfColors.white
                          )
                        ),
                        pw.WidgetSpan(
                          child: pw.Text(
                            amountInNum,
                            style: pw.TextStyle(
                              font: font2,
                              fontSize: 9,
                            )
                          )
                        ),
                        pw.TextSpan(
                          text: ' ) pesos only.', 
                          style: pw.TextStyle(
                            font: font3,
                            fontSize: 12,
                            color: PdfColors.white
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
                      text: '',
                      style: pw.TextStyle(
                        font: font3,
                        fontSize: 12,
                        lineSpacing: 10,
                      ),
                      children: [
                        pw.TextSpan(
                          text: 'As such please accommodate Mr. \/Ms. \/Mrs. ', 
                          style: pw.TextStyle(
                            font: font3,
                            fontSize: 12,
                            color: PdfColors.white
                          )
                        ),
                        pw.WidgetSpan(
                          child: pw.Text(
                            dependent,
                            style: pw.TextStyle(
                              font: font2,
                              fontSize: 9,
                            )
                          )
                        ),
                        pw.TextSpan(
                          text: ' his/her dependent for hospitalization. This is to further certify that Tibud Care of Tibud SKMPC guarantees payment of his hospitalization.', 
                          style: pw.TextStyle(
                            font: font3,
                            fontSize: 12,
                            color: PdfColors.white
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
                    '',
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
                              '',
                              style: pw.TextStyle(
                                font: font3,
                                fontSize: 12,
                              ),
                            ),
                            pw.SizedBox(height: 30),
                            pw.Text(
                              '',
                              style: pw.TextStyle(
                                font: font2,
                                fontSize: 12,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              '',
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
                              '',
                              style: pw.TextStyle(
                                font: font3,
                                fontSize: 12,
                              ),
                            ),
                            pw.SizedBox(height: 30),
                            pw.Text(
                              '',
                              style: pw.TextStyle(
                                font: font2,
                                fontSize: 12,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              '',
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
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  String fromDate = 'SELECT';
  String toDate = 'SELECT';
  int dateChecker = 0;

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2021, 7, 25));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2024),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        if(dateChecker == 1){
          fromDate = '${_selectedDate.value.month}/${_selectedDate.value.day}/${_selectedDate.value.year}';
        }else{
          toDate = '${_selectedDate.value.month}/${_selectedDate.value.day}/${_selectedDate.value.year}';
        }
      });
    }
  }

  void resetDatePicker(){
    setState(() {
      fromDate = 'SELECT';
      toDate = 'SELECT';
    },);
  }

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                textStyle: const TextStyle(fontSize: 12, color: Colors.white,  letterSpacing: 5)
              ),
            ),
          ),
          title: SizedBox(
            width: size.width,
            child: WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(child: MoveWindow()),
                  Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white,  letterSpacing: 5)
                  ),
                ),
                ],
              ),
            ),
          ),
          actions: const [
            Windowbuttons()
          ],
        ),
        body: SizedBox(
          key: UniqueKey(),
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                width: size.width,
                color: Colors.green.shade900,
                child: TabBar(
                  onTap: (value){
                    switch(value){
                      case 0: filterList('');break;
                      case 2: filterConsultList('');break;
                      case 3: filterLabList('');break;
                      case 4: filterAccList('');break;
                      case 5: filterHosList('');break;
                      case 6: filterAccList('');break;
                      case 7: filterDentalList('');break;
                      default:break;
                    }
                    searchText.text = '';
                    controller.reset();
                    controller.forward();
                    resetDatePicker();
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        'Dashboard',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white, letterSpacing: 3)
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Account',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white, letterSpacing: 3)
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Consultation',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white, letterSpacing: 3)
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Laboratory',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white, letterSpacing: 3)
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Accident',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white, letterSpacing: 3)
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Hospitalization',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white, letterSpacing: 3)
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'DAC',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white, letterSpacing: 3)
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Dental',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(fontSize: size.width * .009, color: Colors.white, letterSpacing: 3)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: size.width,
                  child: TabBarView(
                    children: [
                      //---------------------------------------------------------------------------Dashboard------------------------------------------------------------------------------------
                      SizedBox(
                        height: size.width,
                        width: double.infinity,
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 5
                                  ),
                                  child: Text(
                                    'PREMIUM',
                                    style: GoogleFonts.dosis(
                                      textStyle: TextStyle(fontSize: size.width * .03, color: Colors.black, letterSpacing: 5)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .3,
                                        height: 40,
                                        child: TextFormField(
                                          key: keyDashboard,
                                          controller: searchText,
                                          style: GoogleFonts.dosis(
                                            textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              value.isEmpty ? searchIcon = true : searchIcon = false;
                                              filterList(value.toUpperCase());    
                                            });    
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(
                                              left: 25,
                                            ),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10
                                              ),
                                              child: searchIcon ? const Icon(Icons.search, size: 15,): 
                                                IconButton(
                                                  splashRadius: 5,
                                                  onPressed: (){
                                                    setState(() {
                                                      searchText.clear();
                                                      searchIcon = true;
                                                      filterList('');
                                                    });
                                                  }, icon: const Icon(Icons.close, size: 15,)
                                                ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green.shade900,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.dosis(
                                              textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      const Spacer(),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent)
                                        ),
                                        onPressed: (){
                                          showDialog(
                                              context: context, 
                                              builder: (context){
                                                return AlertDialog(
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10.0))
                                                  ),
                                                  title: Text(
                                                    'Insert Data',
                                                    style: GoogleFonts.dosis(
                                                      textStyle: const TextStyle(fontSize: 30, color: Colors.black)
                                                    ),
                                                  ),
                                                  content: Builder(
                                                    builder: (context){
                                                      return SizedBox(
                                                        height: size.height * .4,
                                                        width: size.width * .3,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            SizedBox(
                                                              height: size.height * .08,
                                                              width: size.width * .3,
                                                              child: TextFormField(
                                                                controller: newID,
                                                                style: GoogleFonts.dosis(
                                                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                                                ),
                                                                decoration: InputDecoration(
                                                                  filled: true,
                                                                  fillColor: Colors.grey.shade200,
                                                                  labelText: 'ID NO.',
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
                                                                controller: newMember,
                                                                style: GoogleFonts.dosis(
                                                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                                                ),
                                                                decoration: InputDecoration(
                                                                  filled: true,
                                                                  fillColor: Colors.grey.shade200,
                                                                  labelText: 'NAME',
                                                                  labelStyle: GoogleFonts.dosis(
                                                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                                                  ),
                                                                ),
                                                              )
                                                            ),
                                                            SizedBox(
                                                              height: size.height * .08,
                                                              width: size.width * .3,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    height: size.height * .08,
                                                                    width: size.width * .14,
                                                                    child: TextFormField(
                                                                      controller: newContributionDate,
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
                                                                  SizedBox(
                                                                    height: size.height * .08,
                                                                    width: size.width * .14,
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
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: size.height * .08,
                                                              width: size.width * .3,
                                                              child: TextFormField(
                                                                controller: newBranch,
                                                                style: GoogleFonts.dosis(
                                                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                                                ),
                                                                decoration: InputDecoration(
                                                                  filled: true,
                                                                  fillColor: Colors.grey.shade200,
                                                                  labelText: 'BRANCH',
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
                                                                controller: newDateOfHire,
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
                                                                  labelText: 'DATE OF HIRE',
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
                                                          newID.text = '';
                                                          newMember.text = '';
                                                          newBranch.text = '';
                                                          newContribution.text = '';
                                                          newDateOfHire.text = '';
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
                                                          if(newID.text.isNotEmpty && newMember.text.isNotEmpty && newBranch.text.isNotEmpty && newContributionDate.text.isNotEmpty){
                                                            var date = newContributionDate.text.isNotEmpty?DateFormat.yMd('en_US').parse(newContributionDate.text).toString().toUpperCase():'';
                                                            setState(() {
                                                              Member member = Member();
                                                              member.idno = newID.text.toUpperCase();
                                                              member.member = newMember.text.toUpperCase();
                                                              member.branch = newBranch.text.toUpperCase();
                                                              member.dateOfHire = newDateOfHire.text.toUpperCase();
                                                              member.contributions.add(Contributions()..amount = (newContribution.text == '')? 0 : double.parse(newContribution.text) ..date = date);
                                                              insertMembers(member, widget.user);
                                                            });
                                                            Navigator.pop(context);
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
                                            ).then((_) => setState((){
                                              fetchMembers();
                                            }));
                                        }, 
                                        child: Text(
                                          'Add',
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        )
                                      ),
                                      const SizedBox(width: 10,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent)
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (context) => LoadingToTotals(user: widget.user,)
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "View full data",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent)
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (context) => PrintingOriginal()
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Generate LOG",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent)
                                        ),
                                        onPressed: () {
                                          if(stateManager.currentRow != null){
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute<void>(
                                            //     builder: (context) => Printing(name: stateManager.currentRow!.cells['name']!.value)
                                            //   ),
                                            // );
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
                                                            height: size.height * .35,
                                                            width: size.width * .35,
                                                            child: Center(
                                                              child: Form(
                                                                key: formKey,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: double.infinity,
                                                                      child: DropdownButtonHideUnderline(
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
                                                                              if(value == 'Other'){
                                                                                hospitalTextField = true;
                                                                              }else{
                                                                                hospitalTextField = false;
                                                                              }
                                                                            });
                                                                          })
                                                                        ),
                                                                      ),
                                                                    ),                          
                                                                    TextFormField(
                                                                      controller: notInTheListHospital,
                                                                      style: GoogleFonts.dosis(
                                                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        prefixIcon: const Icon(Icons.local_hospital),
                                                                        disabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                            color: Colors.green.shade900
                                                                          )
                                                                        ),
                                                                        filled: true,
                                                                        enabled: hospitalTextField,
                                                                        fillColor: Colors.grey.shade200,
                                                                        labelText: 'Hospital',
                                                                        labelStyle: GoogleFonts.dosis(
                                                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                                                        ),
                                                                      ),
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
                                                              if(formKey.currentState!.validate()){
                                                                change = true;
                                                                String to = '';
                                                                if(dropdownvalue == 'Other'){
                                                                  to = notInTheListHospital.text;
                                                                }else{
                                                                  to = dropdownvalue;
                                                                }
                                                                String amountInNum = NumberFormat('#,###,##0', 'en_US').format(int.parse(amount.text));
                                                                String amountInWords = NumberToWordsEnglish.convert(int.parse(amount.text)).toUpperCase();
                                                                String dependent = confinee.text.toUpperCase();
                                                                printLOG(stateManager.currentRow!.cells['name']!.value, to, amountInNum, amountInWords, dependent);
                                                                Navigator.pop(context);
                                                                dropdownvalue = 'BONTUYAN MEDICAL HOSPITAL, INC.';
                                                                amount.text = '';
                                                                confinee.text = '';
                                                                notInTheListHospital.text = '';
                                                              }
                                                            },
                                                            child: Text(
                                                              "Print",
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
                                            );
                                          }else{
                                            showDialog(
                                              context: context, 
                                              builder: (context){
                                                return AlertDialog(
                                                  title: Text(
                                                    'ERROR!',
                                                    style: GoogleFonts.dosis(
                                                      textStyle: const TextStyle(fontSize: 25, color: Colors.red, letterSpacing: 5)
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Please select a row from dashboard before printing.',
                                                    style: GoogleFonts.dosis(
                                                      textStyle: const TextStyle(fontSize: 20)
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                        'Close',
                                                        style: GoogleFonts.dosis(
                                                          textStyle: const TextStyle(fontSize: 20)
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                            );
                                          }
                                        },
                                        child: Text(
                                          "Print LOG",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent)
                                        ),
                                        onPressed: () async {
                                          loading();
                                          var exported = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager));
                                          await FileSaver.instance.saveFile('Premium', exported, "csv");
                                          allActivity('Exported Dashboard to csv', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                        },
                                        child: Text(
                                          "Export to CSV",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent)
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => Import(index: 0,userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchMembers();
                                          }));
                                        },
                                        child: Text(
                                          "Import",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
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
                                      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent e){
                                        String id = e.cell!.row.cells.values.first.value;
                                        Navigator.pushReplacement(
                                          context, 
                                          MaterialPageRoute<void>(
                                            builder: (context) => LoadingforInfoPage(id: id, user: widget.user)
                                          ),
                                        );
                                      },
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
                                            if (column.field == 'net' || column.field == 'con' || column.field == 'lab' || column.field == 'acc' || column.field == 'hos' || column.field == 'dac' || column.field == 'dental') {
                                              return resolver<PlutoFilterTypeGreaterThan>() as PlutoFilterType;
                                            }
                                            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                          }
                                        ),
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
                                      columns: dashCol(),
                                      rows: dashRow()
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      //--------------------------------------------------------------------------Account Tab------------------------------------------------------------------------------------
                      Stack(
                        children: [
                          Container(
                            width: size.width,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                radius: 1,
                                tileMode: TileMode.mirror,
                                colors: [
                                  Colors.green.shade600.withOpacity(.8),
                                  Colors.green.shade900
                                ]
                              )
                            ),
                          ),
                          SlideTransition(
                            position: _offsetAnimation,
                            child: FadeTransition(
                              opacity: animation,
                              child: Center(
                                child: Container(
                                  width: size.width * .4,
                                  height: size.height * .7,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Text(
                                          'User Account',
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .02, color: Colors.black, letterSpacing: 5)
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20
                                        ),
                                        child: SizedBox(
                                          height: size.height * .06,
                                          width: size.width * .3,
                                          child: TextFormField(
                                            controller: name,
                                            style: GoogleFonts.dosis(
                                              textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
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
                                              labelText: 'Name',
                                              labelStyle: GoogleFonts.dosis(
                                                textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                              ),
                                            ),
                                          )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20
                                        ),
                                        child: SizedBox(
                                          height: size.height * .06,
                                          width: size.width * .3,
                                          child: TextFormField(
                                            controller: idno,
                                            style: GoogleFonts.dosis(
                                              textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
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
                                                textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                              ),
                                            ),
                                          )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20
                                        ),
                                        child: SizedBox(
                                          height: size.height * .06,
                                          width: size.width * .3,
                                          child: TextFormField(
                                            controller: uname,
                                            style: GoogleFonts.dosis(
                                              textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
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
                                              labelText: 'Username',
                                              labelStyle: GoogleFonts.dosis(
                                                textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                              ),
                                            ),
                                          )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20
                                        ),
                                        child: SizedBox(
                                          height: size.height * .06,
                                          width: size.width * .3,
                                          child: TextFormField(
                                            controller: passwrd,
                                            enabled: passwordEnabled,
                                            style: GoogleFonts.dosis(
                                              textStyle: TextStyle(fontSize: size.width * .015, color:Colors.grey)
                                            ),
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.green.shade900,
                                                  width: 2
                                                )
                                              ),
                                              disabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2
                                                )
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.green.shade900,
                                                  width: 2
                                                )
                                              ),
                                              labelText: 'Password',
                                              labelStyle: GoogleFonts.dosis(
                                                textStyle: TextStyle(fontSize: size.width * .015, color:Colors.grey)
                                              ),
                                            ),
                                          )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20
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
                                                          'Reset Password',
                                                          style: GoogleFonts.dosis(
                                                            textStyle: const TextStyle(fontSize: 30, color: Colors.black)
                                                          ),
                                                        ),
                                                        content: Builder(
                                                          builder: (context){
                                                            return SizedBox(
                                                              height: size.height * .2,
                                                              width: size.width * .3,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  SizedBox(
                                                                    height: size.height * .06,
                                                                    width: size.width * .3,
                                                                    child: TextFormField(
                                                                      controller: resetPassword,
                                                                      style: GoogleFonts.dosis(
                                                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                            color: Colors.grey.shade500
                                                                          )
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                            color: Colors.green.shade900
                                                                          )
                                                                        ),
                                                                        labelText: 'Password',
                                                                        labelStyle: GoogleFonts.dosis(
                                                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ),
                                                                  SizedBox(
                                                                    height: size.height * .06,
                                                                    width: size.width * .3,
                                                                    child: TextFormField(
                                                                      controller: confirm,
                                                                      style: GoogleFonts.dosis(
                                                                        textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                                                      ),
                                                                      decoration: InputDecoration(
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                            color: Colors.grey.shade500
                                                                          )
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                            color: Colors.green.shade900
                                                                          )
                                                                        ),
                                                                        labelText: 'Confirm',
                                                                        labelStyle: GoogleFonts.dosis(
                                                                          textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
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
                                                              onPressed: (){
                                                                if(resetPassword.text == confirm.text){
                                                                  widget.user.password = resetPassword.text;
                                                                  updateUser(widget.user);
                                                                  passwrd.text = resetPassword.text;
                                                                  Navigator.pop(context);
                                                                }else{
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(
                                                                      content: 
                                                                        Text(
                                                                          'Passwords does not match',
                                                                          style: GoogleFonts.dosis(
                                                                            textStyle: TextStyle(fontSize: size.width * .015,  fontWeight: FontWeight.bold, color: Colors.white)
                                                                          ), 
                                                                        )
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child: Text(
                                                                "Reset",
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
                                                  ).then((_) => setState((){
                                                    resetPassword.clear();
                                                    confirm.clear();
                                                    allActivity('updated user password', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: 
                                                          Text(
                                                            'Password has been reset',
                                                            style: GoogleFonts.dosis(
                                                              textStyle: TextStyle(fontSize: size.width * .015,  fontWeight: FontWeight.bold, color: Colors.green.shade300)
                                                            ), 
                                                          )
                                                      ),
                                                    );
                                                  }));
                                                }, 
                                                child: Text(
                                                  "Reset Password",
                                                  style: GoogleFonts.dosis(
                                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * .15,
                                                height: size.height * .05,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(Colors.white),
                                                  ),
                                                  onPressed: (){
                                                    widget.user.idno = idno.text;
                                                    widget.user.name = name.text;
                                                    widget.user.username = uname.text;
                                                    updateUser(widget.user);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: 
                                                          Text(
                                                            'Updated user details',
                                                            style: GoogleFonts.dosis(
                                                              textStyle: TextStyle(fontSize: size.width * .015,  fontWeight: FontWeight.bold, color: Colors.green.shade300)
                                                            ), 
                                                          )
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "UPDATE",
                                                    style: GoogleFonts.dosis(
                                                      textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                                    ),
                                                  ),
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20
                                        ),
                                        child: SizedBox(
                                          width: size.width * .3,
                                          height: size.height * .05,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                            ),
                                            onPressed: (){
                                              Navigator.pop(context);
                                              allActivity('user account log out', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                            },
                                            child: Text(
                                              "LOG OUT",
                                              style: GoogleFonts.dosis(
                                                textStyle: TextStyle(fontSize: size.width * .015, color: Colors.white)
                                              ),
                                            ),
                                          )
                                        ),
                                      ),
                                      const Spacer(flex: 3,),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      //---------------------------------------------------------------------------Consultation---------------------------------------------------------------------------------------
                      SizedBox(
                        height: size.width,
                        width: double.infinity,
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 5
                                  ),
                                  child: Text(
                                    'Consultation',
                                    style: GoogleFonts.dosis(
                                      textStyle: TextStyle(fontSize: size.width * .03, color: Colors.black, letterSpacing: 5)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .3,
                                        height: 40,
                                        child: TextFormField(
                                          key: keyConsultation,
                                          controller: searchText,
                                          style: GoogleFonts.dosis(
                                            textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              value.isEmpty ? searchIcon = true : searchIcon = false;
                                              filterConsultList(value.toUpperCase());      
                                            });    
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(
                                              left: 25,
                                            ),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10
                                              ),
                                              child: searchIcon ? const Icon(Icons.search, size: 15,): 
                                                IconButton(
                                                  splashRadius: 5,
                                                  onPressed: (){
                                                    setState(() {
                                                      searchText.clear();
                                                      searchIcon = true;
                                                      filterConsultList('');
                                                    });
                                                  }, icon: const Icon(Icons.close, size: 15,)
                                                ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green.shade900,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.dosis(
                                              textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'FROM: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 1;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          fromDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'TO: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 2;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          toDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        ':',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () async {
                                          await filterConsultList('');
                                          setState(() {
                                            if(fromDate != 'SELECT' && toDate == 'SELECT'){
                                              consultation = consultation.where((element){
                                                if(element.doc! == ' '){return false;}else{return DateTime.parse(element.doc!).isAfter(DateFormat.yMd('en_US').parse(fromDate));}
                                              }).toList();
                                            }else if(fromDate != 'SELECT' && toDate != 'SELECT'){
                                              consultation = consultation.where((element){
                                                if(element.doc! == ' '){return false;}else{return DateTime.parse(element.doc!).isAfter(DateFormat.yMd('en_US').parse(fromDate)) && DateTime.parse(element.doc!).isBefore(DateFormat.yMd('en_US').parse(toDate));}
                                              }).toList();
                                            }else if(fromDate == 'SELECT' && toDate != 'SELECT'){
                                              consultation = consultation.where((element){
                                                if(element.doc! == ' '){return false;}else{return DateTime.parse(element.doc!).isBefore(DateFormat.yMd('en_US').parse(toDate));}
                                              }).toList();
                                            }
                                          });
                                        }, 
                                        child: Text(
                                          "Set Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            resetDatePicker();
                                            filterConsultList('');
                                          });
                                        }, 
                                        child: Text(
                                          "Reset Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),    
                                      const Spacer(),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: () async {
                                          loading();
                                          var exported = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager1));
                                          await FileSaver.instance.saveFile('Consultation', exported, "csv");
                                          allActivity('Exported Consultation to csv', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                        },
                                        child: Text(
                                          "Export to CSV",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => AddNewData(index: 1, memberID: '', userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchConsult();
                                          }));
                                        },
                                        child: Text(
                                          "Add New Data",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => Import(index: 1, userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchConsult();
                                          }));
                                        },
                                        child: Text(
                                          "Import",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
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
                                      onLoaded: (PlutoGridOnLoadedEvent e){
                                        stateManager1 = e.stateManager;
                                        e.stateManager.setShowColumnFilter(true);
                                      },              
                                      onChanged: (event){
                                        switch (event.columnIdx) {
                                          case 2:consultation[event.rowIdx!].relationship = event.value.toString().toUpperCase();break;
                                          case 3:consultation[event.rowIdx!].confinee = event.value.toString().toUpperCase();break;
                                          case 4:consultation[event.rowIdx!].hospital = event.value.toString().toUpperCase();break;
                                          case 5:consultation[event.rowIdx!].doc = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          case 6:consultation[event.rowIdx!].dod = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          case 7:consultation[event.rowIdx!].labBasic = double.parse(event.value);break;
                                          case 8:consultation[event.rowIdx!].labClaims = double.parse(event.value);break;
                                          case 10:consultation[event.rowIdx!].classification = event.value.toString().toUpperCase();break;
                                          case 11:consultation[event.rowIdx!].remarks = event.value.toString().toUpperCase();break;
                                          case 12:consultation[event.rowIdx!].diagnosis = event.value.toString().toUpperCase();break;
                                          default:
                                        }
                                        updateConsultation(consultation[event.rowIdx!], widget.user);
                                        setState(() {
                                          fetchConsult();
                                        });
                                      },
                                      configuration: PlutoGridConfiguration(
                                        columnFilter: PlutoGridColumnFilterConfig(
                                          filters: const [
                                            ...FilterHelper.defaultFilters,
                                          ],
                                          resolveDefaultColumnFilter: (column, resolver) {
                                            if (column.field == 'basic' || column.field == 'claims' || column.field == 'balance') {
                                              return resolver<PlutoFilterTypeGreaterThan>() as PlutoFilterType;
                                            }
                                            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                          }
                                        ),
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
                                      columns: [
                                        PlutoColumn(
                                          title: 'Id No.',
                                          field: 'id',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                          width: 150
                                        ),
                                        PlutoColumn(
                                          title: 'Member',
                                          field: 'member',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                        ),
                                        PlutoColumn(
                                          title: 'Relationship',
                                          field: 'relationship',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Confinee',
                                          field: 'confinee',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Hospital',
                                          field: 'hospital',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'DOC',
                                          field: 'doc',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'DOD',
                                          field: 'dod',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Basic',
                                          field: 'basic',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Claims',
                                          field: 'claims',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Balance',
                                          field: 'balance',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Classification',
                                          field: 'classification',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Remarks',
                                          field: 'remarks',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Diagnosis',
                                          field: 'diagnosis',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                      ],
                                      rows: consultRow(),
                                      columnGroups: dataColGroupConsult(),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      //-----------------------------------------------------------------------------------Laboratory-----------------------------------------------------------------------
                      SizedBox(
                        height: size.width,
                        width: double.infinity,
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 5
                                  ),
                                  child: Text(
                                    'LABORATORY',
                                    style: GoogleFonts.dosis(
                                      textStyle: TextStyle(fontSize: size.width * .03, color: Colors.black, letterSpacing: 5)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .3,
                                        height: 40,
                                        child: TextFormField(
                                          key: keyLaboratory,
                                          controller: searchText,
                                          style: GoogleFonts.dosis(
                                            textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              value.isEmpty ? searchIcon = true : searchIcon = false;
                                              filterLabList(value.toUpperCase());      
                                            });    
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(
                                              left: 25,
                                            ),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10
                                              ),
                                              child: searchIcon ? const Icon(Icons.search, size: 15,): 
                                                IconButton(
                                                  splashRadius: 5,
                                                  onPressed: (){
                                                    setState(() {
                                                      searchText.clear();
                                                      searchIcon = true;
                                                      filterLabList('');
                                                    });
                                                  }, icon: const Icon(Icons.close, size: 15,)
                                                ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green.shade900,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.dosis(
                                              textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'FROM: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 1;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          fromDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'TO: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 2;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          toDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        ':',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () async {
                                          await filterLabList('');
                                          setState(() {
                                            if(fromDate != 'SELECT' && toDate == 'SELECT'){
                                              laboratory = laboratory.where((element){
                                                if(element.dol! == ' '){return false;}else{return DateTime.parse(element.dol!).isAfter(DateFormat.yMd('en_US').parse(fromDate));}
                                              }).toList();
                                            }else if(fromDate != 'SELECT' && toDate != 'SELECT'){
                                              laboratory = laboratory.where((element){
                                                if(element.dol! == ' '){return false;}else{return DateTime.parse(element.dol!).isAfter(DateFormat.yMd('en_US').parse(fromDate)) && DateTime.parse(element.dol!).isBefore(DateFormat.yMd('en_US').parse(toDate));}
                                              }).toList();
                                            }else if(fromDate == 'SELECT' && toDate != 'SELECT'){
                                              laboratory = laboratory.where((element){
                                                return (element.dol! == ' ')? false : DateTime.parse(element.dol!).isBefore(DateFormat.yMd('en_US').parse(toDate));
                                              }).toList();
                                            }
                                          });
                                        }, 
                                        child: Text(
                                          "Set Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            resetDatePicker();
                                            filterLabList('');
                                          });
                                        }, 
                                        child: Text(
                                          "Reset Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ), 
                                      const Spacer(),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: () async {
                                          loading();
                                          var exported = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager2));
                                          await FileSaver.instance.saveFile('Laboratory', exported, "csv");
                                          allActivity('Exported Laboratory to csv', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                        },
                                        child: Text(
                                          "Export to CSV",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => AddNewData(index: 2, memberID: '',userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchLab();
                                          }));
                                        },
                                        child: Text(
                                          "Add New Data",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => Import(index: 2, userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchLab();
                                          }));
                                        },
                                        child: Text(
                                          "Import",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
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
                                      onLoaded: (PlutoGridOnLoadedEvent e){
                                        stateManager2 = e.stateManager;
                                        e.stateManager.setShowColumnFilter(true);
                                      },
                                      onChanged: (event){
                                        switch (event.columnIdx) {
                                          case 2:laboratory[event.rowIdx!].relationship = event.value.toString().toUpperCase();break;
                                          case 3:laboratory[event.rowIdx!].confinee = event.value.toString().toUpperCase();break;
                                          case 4:laboratory[event.rowIdx!].hospital = event.value.toString().toUpperCase();break;
                                          case 5:laboratory[event.rowIdx!].dol = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          case 6:laboratory[event.rowIdx!].labBasic = double.parse(event.value);break;
                                          case 7:laboratory[event.rowIdx!].labClaims = double.parse(event.value);break;
                                          default:
                                        }
                                        updateLaboratory(laboratory[event.rowIdx!],widget.user);
                                        setState(() {
                                          fetchLab();
                                        });
                                      },
                                      configuration: PlutoGridConfiguration(
                                        columnFilter: PlutoGridColumnFilterConfig(
                                          filters: const [
                                            ...FilterHelper.defaultFilters,
                                          ],
                                          resolveDefaultColumnFilter: (column, resolver) {
                                            if (column.field == 'basic' || column.field == 'claims' || column.field == 'balance') {
                                              return resolver<PlutoFilterTypeGreaterThan>() as PlutoFilterType;
                                            }
                                            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                          }
                                        ),
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
                                      columns: [
                                        PlutoColumn(
                                          title: 'Id No.',
                                          field: 'id',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                          width: 150
                                        ),
                                        PlutoColumn(
                                          title: 'Member',
                                          field: 'member',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                        ),
                                        PlutoColumn(
                                          title: 'Relationship',
                                          field: 'relationship',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Confinee',
                                          field: 'confinee',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Hospital',
                                          field: 'hospital',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'DOL',
                                          field: 'dol',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Basic',
                                          field: 'basic',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Claims',
                                          field: 'claims',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Balance',
                                          field: 'balance',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                      ],
                                      rows: labRow(),
                                      columnGroups: dataColGroupLab(),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      //-------------------------------------------------------------------------------Accident-----------------------------------------------------------------------------------
                      SizedBox(
                        height: size.width,
                        width: double.infinity,
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 5
                                  ),
                                  child: Text(
                                    'ACCIDENTS',
                                    style: GoogleFonts.dosis(
                                      textStyle: TextStyle(fontSize: size.width * .03, color: Colors.black, letterSpacing: 5)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .3,
                                        height: 40,
                                        child: TextFormField(
                                          key: keyAccidents,
                                          controller: searchText,
                                          style: GoogleFonts.dosis(
                                            textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              value.isEmpty ? searchIcon = true : searchIcon = false;
                                              filterAccList(value.toUpperCase());    
                                            });    
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(
                                              left: 25,
                                            ),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10
                                              ),
                                              child: searchIcon ? const Icon(Icons.search, size: 15,): 
                                                IconButton(
                                                  splashRadius: 5,
                                                  onPressed: (){
                                                    setState(() {
                                                      searchText.clear();
                                                      searchIcon = true;
                                                      filterAccList('');
                                                    });
                                                  }, icon: const Icon(Icons.close, size: 15,)
                                                ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green.shade900,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.dosis(
                                              textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'FROM: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 1;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          fromDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'TO: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 2;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          toDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        ':',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () async {
                                          await filterAccList('');
                                          setState(() {
                                            if(fromDate != 'SELECT' && toDate == 'SELECT'){
                                              accidents = accidents.where((element) => (element.doc! == ' ')?false:DateTime.parse(element.doc!).isAfter(DateFormat.yMd('en_US').parse(fromDate))).toList();
                                            }else if(fromDate != 'SELECT' && toDate != 'SELECT'){
                                              accidents = accidents.where((element) => (element.doc! == ' ')?false:DateTime.parse(element.doc!).isAfter(DateFormat.yMd('en_US').parse(fromDate)) && DateTime.parse(element.doc!).isBefore(DateFormat.yMd('en_US').parse(toDate))).toList();
                                            }else if(fromDate == 'SELECT' && toDate != 'SELECT'){
                                              accidents = accidents.where((element) => (element.doc! == ' ')?false:DateTime.parse(element.doc!).isBefore(DateFormat.yMd('en_US').parse(toDate))).toList();
                                            }
                                          });
                                        }, 
                                        child: Text(
                                          "Set Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            resetDatePicker();
                                            filterAccList('');
                                          });
                                        }, 
                                        child: Text(
                                          "Reset Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ), 
                                      const Spacer(),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: () async {
                                          loading();
                                          var exported = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager3));
                                          await FileSaver.instance.saveFile('Accidents', exported, "csv");
                                          allActivity('Exported Accidents to csv', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                        },
                                        child: Text(
                                          "Export to CSV",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => AddNewData(index: 3, memberID: '',userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchAccidents();
                                          }));
                                        },
                                        child: Text(
                                          "Add New Data",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => Import(index: 3, userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchAccidents();
                                          }));
                                        },
                                        child: Text(
                                          "Import",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
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
                                      onLoaded: (PlutoGridOnLoadedEvent e){
                                        stateManager3 = e.stateManager;
                                        e.stateManager.setShowColumnFilter(true);
                                      },
                                      onChanged: (event){
                                        switch (event.columnIdx) {
                                          case 2:accidents[event.rowIdx!].relationship = event.value.toString().toUpperCase();break;
                                          case 3:accidents[event.rowIdx!].confinee = event.value.toString().toUpperCase();break;
                                          case 4:accidents[event.rowIdx!].hospital = event.value.toString().toUpperCase();break;
                                          case 5:accidents[event.rowIdx!].doc = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          case 6:accidents[event.rowIdx!].dod = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          case 7:accidents[event.rowIdx!].accBasic = double.parse(event.value);break;
                                          case 8:accidents[event.rowIdx!].accClaims = double.parse(event.value);break;
                                          case 10:accidents[event.rowIdx!].classification = event.value.toString().toUpperCase();break;
                                          case 11:accidents[event.rowIdx!].remarks = event.value.toString().toUpperCase();break;
                                          default:
                                        }
                                        updateAccident(accidents[event.rowIdx!], widget.user);
                                        setState(() {
                                          fetchAccidents();
                                        });
                                      },
                                      configuration: PlutoGridConfiguration(
                                        columnFilter: PlutoGridColumnFilterConfig(
                                          filters: const [
                                            ...FilterHelper.defaultFilters,
                                          ],
                                          resolveDefaultColumnFilter: (column, resolver) {
                                            if (column.field == 'basic' || column.field == 'claims' || column.field == 'balance') {
                                              return resolver<PlutoFilterTypeGreaterThan>() as PlutoFilterType;
                                            }
                                            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                          }
                                        ),
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
                                      columns: [
                                        PlutoColumn(
                                          title: 'Id No.',
                                          field: 'id',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                          width: 150
                                        ),
                                        PlutoColumn(
                                          title: 'Member',
                                          field: 'member',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                        ),
                                        PlutoColumn(
                                          title: 'Relationship',
                                          field: 'relationship',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Confinee',
                                          field: 'confinee',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Hospital',
                                          field: 'hospital',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'DOC',
                                          field: 'doc',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'DOD',
                                          field: 'dod',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Basic',
                                          field: 'basic',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Claims',
                                          field: 'claims',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Balance',
                                          field: 'balance',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Classification',
                                          field: 'classification',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Remarks',
                                          field: 'remarks',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                      ],
                                      rows: accRow(),
                                      columnGroups: dataColGroupAcc(),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      //------------------------------------------------------------------------------Hospitalization-----------------------------------------------------------------------------
                      SizedBox(
                        height: size.width,
                        width: double.infinity,
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 5
                                  ),
                                  child: Text(
                                    'HOSPITALIZATION',
                                    style: GoogleFonts.dosis(
                                      textStyle: TextStyle(fontSize: size.width * .03, color: Colors.black, letterSpacing: 5)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .3,
                                        height: 40,
                                        child: TextFormField(
                                          key: keyHospitalization,
                                          controller: searchText,
                                          style: GoogleFonts.dosis(
                                            textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              value.isEmpty ? searchIcon = true : searchIcon = false;
                                              filterHosList(value.toUpperCase());   
                                            });    
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(
                                              left: 25,
                                            ),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10
                                              ),
                                              child: searchIcon ? const Icon(Icons.search, size: 15,): 
                                                IconButton(
                                                  splashRadius: 5,
                                                  onPressed: (){
                                                    setState(() {
                                                      searchText.clear();
                                                      searchIcon = true;
                                                      filterHosList('');
                                                    });
                                                  }, icon: const Icon(Icons.close, size: 15,)
                                                ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green.shade900,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.dosis(
                                              textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'FROM: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 1;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          fromDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'TO: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 2;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          toDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        ':',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () async {
                                          await filterHosList('');
                                          setState(() {
                                            if(fromDate != 'SELECT' && toDate == 'SELECT'){
                                              hospitalization = hospitalization.where((element) => (element.doa! == ' ')?false:DateTime.parse(element.doa!).isAfter(DateFormat.yMd('en_US').parse(fromDate))).toList();
                                            }else if(fromDate != 'SELECT' && toDate != 'SELECT'){
                                              hospitalization = hospitalization.where((element) => (element.doa! == ' ')?false:DateTime.parse(element.doa!).isAfter(DateFormat.yMd('en_US').parse(fromDate)) && DateTime.parse(element.doa!).isBefore(DateFormat.yMd('en_US').parse(toDate))).toList();
                                            }else if(fromDate == 'SELECT' && toDate != 'SELECT'){
                                              hospitalization = hospitalization.where((element) => (element.doa! == ' ')?false:DateTime.parse(element.doa!).isBefore(DateFormat.yMd('en_US').parse(toDate))).toList();
                                            }
                                          });
                                        }, 
                                        child: Text(
                                          "Set Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            resetDatePicker();
                                            filterHosList('');
                                          });
                                        }, 
                                        child: Text(
                                          "Reset Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: () async {
                                          loading();
                                          var exported = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager4));
                                          await FileSaver.instance.saveFile('Hospitalization', exported, "csv");
                                          allActivity('Exported Hospitalization to csv', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                        },
                                        child: Text(
                                          "Export to CSV",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => AddNewData(index: 4, memberID: '',userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchHospitalization();
                                          }));
                                        },
                                        child: Text(
                                          "Add New Data",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => Import(index: 4, userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchHospitalization();
                                          }));
                                        },
                                        child: Text(
                                          "Import",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
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
                                      onLoaded: (PlutoGridOnLoadedEvent e){
                                        stateManager4 = e.stateManager;
                                        e.stateManager.setShowColumnFilter(true);
                                      },
                                      onChanged: (event){
                                        switch (event.columnIdx) {
                                          case 2:hospitalization[event.rowIdx!].relationship = event.value.toString().toUpperCase();break;
                                          case 3:hospitalization[event.rowIdx!].confinee = event.value.toString().toUpperCase();break;
                                          case 4:hospitalization[event.rowIdx!].hospital = event.value.toString().toUpperCase();break;
                                          case 5:hospitalization[event.rowIdx!].doa = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          case 6:hospitalization[event.rowIdx!].dod = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          case 7:hospitalization[event.rowIdx!].hosBasic = double.parse(event.value);break;
                                          case 8:hospitalization[event.rowIdx!].hosClaims = double.parse(event.value);break;
                                          case 10:hospitalization[event.rowIdx!].classification = event.value.toString().toUpperCase();break;
                                          case 11:hospitalization[event.rowIdx!].remarks = event.value.toString().toUpperCase();break;
                                          default:
                                        }
                                        updateHospitalization(hospitalization[event.rowIdx!], widget.user);
                                        setState(() {
                                          fetchHospitalization();
                                        });
                                      },
                                      configuration: PlutoGridConfiguration(
                                        columnFilter: PlutoGridColumnFilterConfig(
                                          filters: const [
                                            ...FilterHelper.defaultFilters,
                                          ],
                                          resolveDefaultColumnFilter: (column, resolver) {
                                            if (column.field == 'basic' || column.field == 'claims' || column.field == 'balance') {
                                              return resolver<PlutoFilterTypeGreaterThan>() as PlutoFilterType;
                                            }
                                            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                          }
                                        ),
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
                                      columns: [
                                        PlutoColumn(
                                          title: 'Id No.',
                                          field: 'id',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                          width: 150
                                        ),
                                        PlutoColumn(
                                          title: 'Member',
                                          field: 'member',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                        ),
                                        PlutoColumn(
                                          title: 'Relationship',
                                          field: 'relationship',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Confinee',
                                          field: 'confinee',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Hospital',
                                          field: 'hospital',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'DOA',
                                          field: 'doa',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'DOD',
                                          field: 'dod',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Basic',
                                          field: 'basic',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Claims',
                                          field: 'claims',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Balance',
                                          field: 'balance',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'Classification',
                                          field: 'classification',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Remarks',
                                          field: 'remarks',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                      ],
                                      rows: hosRow(),
                                      columnGroups: dataColGroupHos(),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      //--------------------------------------------------------------------------------DAC--------------------------------------------------------------------------------------
                      SizedBox(
                        height: size.width,
                        width: double.infinity,
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 5
                                  ),
                                  child: Text(
                                    'DAC',
                                    style: GoogleFonts.dosis(
                                      textStyle: TextStyle(fontSize: size.width * .03, color: Colors.black, letterSpacing: 5)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .3,
                                        height: 40,
                                        child: TextFormField(
                                          key: keyDAC,
                                          controller: searchText,
                                          style: GoogleFonts.dosis(
                                            textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              value.isEmpty ? searchIcon = true : searchIcon = false;    
                                              filterDACList(value.toUpperCase());  
                                            });    
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(
                                              left: 25,
                                            ),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10
                                              ),
                                              child: searchIcon ? const Icon(Icons.search, size: 15,): 
                                                IconButton(
                                                  splashRadius: 5,
                                                  onPressed: (){
                                                    setState(() {
                                                      searchText.clear();
                                                      searchIcon = true;
                                                      filterDACList('');
                                                    });
                                                  }, icon: const Icon(Icons.close, size: 15,)
                                                ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green.shade900,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.dosis(
                                              textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'FROM: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 1;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          fromDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'TO: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 2;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          toDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        ':',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () async {
                                          await filterDACList('');
                                          setState(() {
                                            if(fromDate != 'SELECT' && toDate == 'SELECT'){
                                              dac = dac.where((element) => (element.dod! == ' ')?false:DateTime.parse(element.dod!).isAfter(DateFormat.yMd('en_US').parse(fromDate))).toList();
                                            }else if(fromDate != 'SELECT' && toDate != 'SELECT'){
                                              dac = dac.where((element) => (element.dod! == ' ')?false:DateTime.parse(element.dod!).isAfter(DateFormat.yMd('en_US').parse(fromDate)) && DateTime.parse(element.dod!).isBefore(DateFormat.yMd('en_US').parse(toDate))).toList();
                                            }else if(fromDate == 'SELECT' && toDate != 'SELECT'){
                                              dac = dac.where((element) => (element.dod! == ' ')?false:DateTime.parse(element.dod!).isBefore(DateFormat.yMd('en_US').parse(toDate))).toList();
                                            }
                                          });
                                        }, 
                                        child: Text(
                                          "Set Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            resetDatePicker();
                                            filterDACList('');
                                          });
                                        }, 
                                        child: Text(
                                          "Reset Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: () async {
                                          loading();
                                          var exported = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager5));
                                          await FileSaver.instance.saveFile('DAC', exported, "csv");
                                          allActivity('Exported DAC to csv', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                        },
                                        child: Text(
                                          "Export to CSV",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => AddNewData(index: 5, memberID: '',userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchDAC();
                                          }));
                                        },
                                        child: Text(
                                          "Add New Data",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => Import(index: 5, userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchDAC();
                                          }));
                                        },
                                        child: Text(
                                          "Import",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
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
                                      onLoaded: (PlutoGridOnLoadedEvent e){
                                        stateManager5 = e.stateManager;
                                        e.stateManager.setShowColumnFilter(true);
                                      },
                                      onChanged: (event){
                                        switch (event.columnIdx) {
                                          case 2:dac[event.rowIdx!].relationship = event.value.toString().toUpperCase();break;
                                          case 3:dac[event.rowIdx!].classification = event.value.toString().toUpperCase();break;
                                          case 4:dac[event.rowIdx!].amount = double.parse(event.value);break;
                                          case 5:dac[event.rowIdx!].dod = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          default:
                                        }
                                        updateDAC(dac[event.rowIdx!],widget.user);
                                        setState(() {
                                          fetchDAC();
                                        });
                                      },
                                      configuration: PlutoGridConfiguration(
                                        columnFilter: PlutoGridColumnFilterConfig(
                                          filters: const [
                                            ...FilterHelper.defaultFilters,
                                          ],
                                          resolveDefaultColumnFilter: (column, resolver) {
                                            if (column.field == 'amount') {
                                              return resolver<PlutoFilterTypeGreaterThan>() as PlutoFilterType;
                                            }
                                            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                          }
                                        ),
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
                                      columns: [
                                        PlutoColumn(
                                          title: 'Id No.',
                                          field: 'id',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                          width: 150
                                        ),
                                        PlutoColumn(
                                          title: 'Name',
                                          field: 'name',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                        ),
                                        PlutoColumn(
                                          title: 'Relationship',
                                          field: 'relationship',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Classification',
                                          field: 'classification',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Amount',
                                          field: 'amount',
                                          type: PlutoColumnType.number(
                                            format: '###,##0.00'
                                          ),
                                          textAlign: PlutoColumnTextAlign.end,
                                        ),
                                        PlutoColumn(
                                          title: 'DOD',
                                          field: 'dod',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                      ],
                                      rows: dacRow(),
                                      columnGroups: dataColGroupDac(),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                      //--------------------------------------------------------------------------------Dental----------------------------------------------------------------------------------
                      SizedBox(
                        height: size.width,
                        width: double.infinity,
                        child: SlideTransition(
                          position: _offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 5
                                  ),
                                  child: Text(
                                    'DENTAL',
                                    style: GoogleFonts.dosis(
                                      textStyle: TextStyle(fontSize: size.width * .03, color: Colors.black, letterSpacing: 5)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 40,
                                    right: 40,
                                    top: 30
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .3,
                                        height: 40,
                                        child: TextFormField(
                                          key: keyDental,
                                          controller: searchText,
                                          style: GoogleFonts.dosis(
                                            textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                          ),
                                          onChanged: (value){
                                            setState(() {
                                              value.isEmpty ? searchIcon = true : searchIcon = false;   
                                              filterDentalList(value.toUpperCase());   
                                            });    
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(
                                              left: 25,
                                            ),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10
                                              ),
                                              child: searchIcon ? const Icon(Icons.search, size: 15,): 
                                                IconButton(
                                                  splashRadius: 5,
                                                  onPressed: (){
                                                    setState(() {
                                                      searchText.clear();
                                                      searchIcon = true;
                                                      filterDentalList('');
                                                    });
                                                  }, icon: const Icon(Icons.close, size: 15,)
                                                ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.green.shade900,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 2
                                              ),
                                              borderRadius: BorderRadius.circular(50.0),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.dosis(
                                              textStyle: const TextStyle(fontSize: 15, color: Colors.black)
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'FROM: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 1;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          fromDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        'TO: ',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: (){
                                          dateChecker = 2;
                                          _restorableDatePickerRouteFuture.present();
                                        }, 
                                        child: Text(
                                          toDate,
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Text(
                                        ':',
                                        style: GoogleFonts.dosis(
                                          textStyle: TextStyle(fontSize: size.width * .007, color: Colors.black)
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () async {
                                          await filterDentalList('');
                                          setState(() {
                                            if(fromDate != 'SELECT' && toDate == 'SELECT'){
                                              dental = dental.where((element) => (element.date! == ' ')?false:DateTime.parse(element.date!).isAfter(DateFormat.yMd('en_US').parse(fromDate))).toList();
                                            }else if(fromDate != 'SELECT' && toDate != 'SELECT'){
                                              dental = dental.where((element) => (element.date! == ' ')?false:DateTime.parse(element.date!).isAfter(DateFormat.yMd('en_US').parse(fromDate)) && DateTime.parse(element.date!).isBefore(DateFormat.yMd('en_US').parse(toDate))).toList();
                                            }else if(fromDate == 'SELECT' && toDate != 'SELECT'){
                                              dental = dental.where((element) => (element.date! == ' ')?false:DateTime.parse(element.date!).isBefore(DateFormat.yMd('en_US').parse(toDate))).toList();
                                            }
                                          });
                                        }, 
                                        child: Text(
                                          "Set Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            resetDatePicker();
                                            filterDentalList('');
                                          });
                                        }, 
                                        child: Text(
                                          "Reset Range",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .007, color: Colors.white)
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: () async {
                                          loading();
                                          var exported = const Utf8Encoder().convert(pluto_grid_export.PlutoGridExport.exportCSV(stateManager6));
                                          await FileSaver.instance.saveFile('Dental', exported, "csv");
                                          allActivity('Exported Dental to csv', widget.user.username!, widget.user.password!, widget.user.name!, widget.user.idno!);
                                        },
                                        child: Text(
                                          "Export to CSV",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => AddNewData(index: 6, memberID: '',userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchDental();
                                          }));
                                        },
                                        child: Text(
                                          "Add New Data",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20,),
                                      TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          showDialog(
                                            context: context, 
                                            builder: (context) => Import(index: 6, userAccount: widget.user,)
                                          ).then((_) => setState((){
                                            fetchDental();
                                          }));
                                        },
                                        child: Text(
                                          "Import",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                          ),
                                        ),
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
                                      onLoaded: (PlutoGridOnLoadedEvent e){
                                        stateManager6 = e.stateManager;
                                        e.stateManager.setShowColumnFilter(true);
                                      },
                                      onChanged: (event){
                                        switch (event.columnIdx) {
                                          case 2:dental[event.rowIdx!].relationship = event.value.toString().toUpperCase();break;
                                          case 3:dental[event.rowIdx!].confinee = event.value.toString().toUpperCase();break;
                                          case 4:dental[event.rowIdx!].clinic = event.value.toString().toUpperCase();break;
                                          case 5:dental[event.rowIdx!].classification = event.value.toString().toUpperCase();break;
                                          case 6:dental[event.rowIdx!].date = DateFormat.yMd('en_US').parse(event.value).toString();break;
                                          default:
                                        }
                                        updateDental(dental[event.rowIdx!],widget.user);
                                        setState(() {
                                          fetchDental();
                                        });
                                      },
                                      configuration: PlutoGridConfiguration(
                                        columnFilter: PlutoGridColumnFilterConfig(
                                          filters: const [
                                            ...FilterHelper.defaultFilters,
                                          ],
                                          resolveDefaultColumnFilter: (column, resolver) {
                                            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                                          }
                                        ),
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
                                      columns: [
                                        PlutoColumn(
                                          title: 'Id No.',
                                          field: 'id',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                          width: 150
                                        ),
                                        PlutoColumn(
                                          title: 'Member',
                                          field: 'member',
                                          type: PlutoColumnType.text(),
                                          frozen: PlutoColumnFrozen.start,
                                        ),
                                        PlutoColumn(
                                          title: 'Relationship',
                                          field: 'relationship',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Patient',
                                          field: 'patient',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Clinic',
                                          field: 'clinic',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Classification',
                                          field: 'classification',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                        PlutoColumn(
                                          title: 'Date',
                                          field: 'date',
                                          type: PlutoColumnType.text(),
                                          textAlign: PlutoColumnTextAlign.center,
                                        ),
                                      ],
                                      rows: dentalRow(),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              )
            ],
          )
        ),
      ),
    );
  }
}