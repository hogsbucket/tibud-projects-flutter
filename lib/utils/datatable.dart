import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tibud_care_system/model/model.dart';
import 'package:tibud_care_system/server/server.dart';
import 'package:tibud_care_system/utils/constant.dart';

List<PlutoColumn> dashCol(){
  List<PlutoColumn> col = [
    PlutoColumn(
      title: 'ID NO.',
      field: 'id',
      type: PlutoColumnType.text(),
      frozen: PlutoColumnFrozen.start,
      width: 150
    ),
    PlutoColumn(
      title: 'NAME',
      field: 'name',
      type: PlutoColumnType.text(),
      frozen: PlutoColumnFrozen.start,
      width: 200
    ),
    PlutoColumn(
      title: 'NET TOTAL',
      field: 'net',
      type: PlutoColumnType.text(),
      width: 150
    ),
    PlutoColumn(
      title: 'No. months without contribution',
      field: 'num',
      type: PlutoColumnType.text(),
      width: 250
    ),
    PlutoColumn(
      title: 'Last Contribution',
      field: 'last',
      type: PlutoColumnType.text(),
      width: 200
    ),
    PlutoColumn(
      title: 'DATE OF  HIRE',
      field: 'doh',
      type: PlutoColumnType.text(),
      width: 200
    ),
    PlutoColumn(
      title: 'BRANCH',
      field: 'branch',
      type: PlutoColumnType.text(),
      width: 200
    ),
  ];

  return col;
}

List<PlutoRow> beneficiaryList(){
  List<PlutoRow> rows = [];
  for (var index in ben) {
    rows.add(
      PlutoRow(
        cells: {
          'name': PlutoCell(value: index.name),
          'relationship': PlutoCell(value: index.relationship),
          'age': PlutoCell(value: index.age),
          'role': PlutoCell(value: index.role),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> memberConsultRow(int id){
  List<PlutoRow> rows = [];
  getMemConsult(id);
  for (var index in memConsult) {
    rows.add(
      PlutoRow(
        cells: {
          'confinee': PlutoCell(value: index.confinee),
          'relationship': PlutoCell(value: index.relationship),
          'hospital': PlutoCell(value: index.hospital),
          'doc': PlutoCell(value: index.doc),
          'dod': PlutoCell(value: index.dod),
          'basic': PlutoCell(value: index.labBasic),
          'claims': PlutoCell(value: index.labClaims),
          'balance': PlutoCell(value: (index.labBasic! - index.labClaims!)),
          'classification': PlutoCell(value: index.classification),
          'remarks': PlutoCell(value: index.remarks),
          'diagnosis': PlutoCell(value: index.diagnosis),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> memberLabRow(int id){
  List<PlutoRow> rows = [];
  getMemLab(id);
  for (var index in memLab) {
    rows.add(
      PlutoRow(
        cells: {
          'confinee': PlutoCell(value: index.confinee),
          'relationship': PlutoCell(value: index.relationship),
          'hospital': PlutoCell(value: index.hospital),
          'dol': PlutoCell(value: index.dol),
          'basic': PlutoCell(value: index.labBasic),
          'claims': PlutoCell(value: index.labClaims),
          'balance': PlutoCell(value: (index.labBasic! - index.labClaims!)),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> memberHosRow(int id){
  List<PlutoRow> rows = [];
  getMemHos(id);
  for (var index in memHos) {
    rows.add(
      PlutoRow(
        cells: {
          'confinee': PlutoCell(value: index.confinee),
          'relationship': PlutoCell(value: index.relationship),
          'hospital': PlutoCell(value: index.hospital),
          'doa': PlutoCell(value: index.doa),
          'dod': PlutoCell(value: index.dod),
          'basic': PlutoCell(value: index.hosBasic),
          'claims': PlutoCell(value: index.hosClaims),
          'balance': PlutoCell(value: (index.hosBasic! - index.hosClaims!)),
          'classification': PlutoCell(value: index.classification),
          'remarks': PlutoCell(value: index.remarks),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> memberAccRow(int id){
  List<PlutoRow> rows = [];
  getMemAcc(id);
  for (var index in memAcc) {
    rows.add(
      PlutoRow(
        cells: {
          'confinee': PlutoCell(value: index.confinee),
          'relationship': PlutoCell(value: index.relationship),
          'hospital': PlutoCell(value: index.hospital),
          'doc': PlutoCell(value: index.doc),
          'dod': PlutoCell(value: index.dod),
          'basic': PlutoCell(value: index.accBasic),
          'claims': PlutoCell(value: index.accClaims),
          'balance': PlutoCell(value: (index.accBasic! - index.accClaims!)),
          'classification': PlutoCell(value: index.classification),
          'remarks': PlutoCell(value: index.remarks),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> memberDACRow(int id){
  List<PlutoRow> rows = [];
  getMemDAC(id);
  for (var index in memDAC) {
    rows.add(
      PlutoRow(
        cells: {
          'relationship': PlutoCell(value: index.relationship),
          'classification': PlutoCell(value: index.classification),
          'amount': PlutoCell(value: index.amount),
          'dod': PlutoCell(value: index.dod),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> memberDentalRow(int id){
  List<PlutoRow> rows = [];
  getMemDental(id);
  for (var index in memDental) {
    rows.add(
      PlutoRow(
        cells: {
          'patient': PlutoCell(value: index.confinee),
          'relationship': PlutoCell(value: index.relationship),
          'clinic': PlutoCell(value: index.clinic),
          'classification': PlutoCell(value: index.classification),
          'date': PlutoCell(value: index.date),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> infoDashRow(Member mem){
  List<PlutoRow> rows = [];
  for (var x in mem.contributions) {
    String day;
    if(x.date != ' '){
      DateTime date = DateTime.parse(x.date!);
      day = DateFormat.yMMMMd().format(date);
    }else{
      day = x.date!;
    }
    rows.add(
      PlutoRow(
        cells:{
          'date': PlutoCell(value: day),
          'amount': PlutoCell(value: x.amount),        }
      ),
    );
  }
  return rows;
}


List<PlutoRow> dashRow(){
  List<PlutoRow> rows = [];
  for (var mem in members) {
    double total =  (mem.contributions != []) ? mem.contributions.fold(0, (sum, contribution) => sum.toDouble() + contribution.amount!) : 0;
    String day;
    DateTime date = DateTime.parse(mem.contributions[mem.contributions.length - 1].date!);
    day = DateFormat.yMMMMd().format(date);
    final difference = (DateTime.now().difference(date).inDays / 31).floor();
    rows.add(
      PlutoRow(
        cells:{
          'id': PlutoCell(value: mem.idno),
          'name': PlutoCell(value: mem.member),
          'doh': PlutoCell(value: mem.dateOfHire),
          'branch': PlutoCell(value: mem.branch),
          'net': PlutoCell(value: total.toStringAsFixed(0)),
          'num': PlutoCell(value: difference),
          'last': PlutoCell(value: day),
        }
      ),
    );
  }
  return rows;
}

// Map<String, PlutoCell> dashcells(Member mem){
//   Map<String, PlutoCell> cells = {};
//   final id = {'id': PlutoCell(value: mem.idno)};
//   final name = {'name': PlutoCell(value: mem.member)};
//   final branch = {'branch': PlutoCell(value: mem.branch)};
//   double total =  (mem.contributions != []) ? mem.contributions.fold(0, (sum, contribution) => sum.toDouble() + contribution.amount!) : 0;
//   final net = {'net': PlutoCell(value: total.toStringAsFixed(0))};
//   cells.addAll(id);
//   cells.addAll(name);
//   cells.addAll(net);
//   cells.addAll(branch);
  // for (var i = 0; i < mem.contributions.length; i++) {
  //   cells.addAll(
  //     {'date$i': PlutoCell(value: mem.contributions[i].amount!.toStringAsFixed(0))}
  //   );
  // }
//   return cells;
// }

List<PlutoRow> consultRow(){
  List<PlutoRow> rows = [];
  for (var index in consultation) {
    memNamesConsultation(index.id);
    String day;
    String day1;
    if(index.doc != ''){
      DateTime date = DateTime.parse(index.doc!);
      day = DateFormat('MM/dd/y').format(date);
    }else{
      day = index.doc!;
    }
    if(index.dod != ''){
      DateTime date = DateTime.parse(index.dod!);
      day1 = DateFormat('MM/dd/y').format(date);
    }else{
      day1 = index.dod!;
    }
    rows.add(
      PlutoRow(
        cells: {
          'id': PlutoCell(value: memNameConsult.idno),
          'member': PlutoCell(value: memNameConsult.member),
          'relationship': PlutoCell(value: index.relationship),
          'confinee': PlutoCell(value: index.confinee),
          'hospital': PlutoCell(value: index.hospital),
          'doc': PlutoCell(value: day),
          'dod': PlutoCell(value: day1),
          'basic': PlutoCell(value: index.labBasic),
          'claims': PlutoCell(value: index.labClaims),
          'balance': PlutoCell(value: (index.labBasic! - index.labClaims!)),
          'classification': PlutoCell(value: index.classification),
          'remarks': PlutoCell(value: index.remarks),
          'diagnosis': PlutoCell(value: index.diagnosis),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> labRow(){
  List<PlutoRow> rows = [];
  for (var index in laboratory) {
    memNamesLab(index.id);
    String day;
    if(index.dol != ''){
      DateTime date = DateTime.parse(index.dol!);
      day = DateFormat('MM/dd/y').format(date);
    }else{
      day = index.dol!;
    }
    rows.add(
      PlutoRow(
        cells: {
          'id': PlutoCell(value: memNameLab.idno),
          'member': PlutoCell(value: memNameLab.member),
          'relationship': PlutoCell(value: index.relationship),
          'confinee': PlutoCell(value: index.confinee),
          'hospital': PlutoCell(value: index.hospital),
          'dol': PlutoCell(value: day),
          'basic': PlutoCell(value: index.labBasic),
          'claims': PlutoCell(value: index.labClaims),
          'balance': PlutoCell(value: (index.labBasic! - index.labClaims!)),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> accRow(){
  List<PlutoRow> rows = [];
  for (var index in accidents) {
    memNamesAcc(index.id);
    String day;
    String day1;
    if(index.doc != ''){
      DateTime date = DateTime.parse(index.doc!);
      day = DateFormat('MM/dd/y').format(date);
    }else{
      day = index.doc!;
    }
    if(index.dod != ''){
      DateTime date = DateTime.parse(index.dod!);
      day1 = DateFormat('MM/dd/y').format(date);
    }else{
      day1 = index.dod!;
    }
    rows.add(
      PlutoRow(
        cells: {
          'id': PlutoCell(value: memNameAcc.idno),
          'member': PlutoCell(value: memNameAcc.member),
          'relationship': PlutoCell(value: index.relationship),
          'confinee': PlutoCell(value: index.confinee),
          'hospital': PlutoCell(value: index.hospital),
          'doc': PlutoCell(value: day),
          'dod': PlutoCell(value: day1),
          'basic': PlutoCell(value: index.accBasic),
          'claims': PlutoCell(value: index.accClaims),
          'balance': PlutoCell(value: (index.accBasic! - index.accClaims!)),
          'classification': PlutoCell(value: index.classification),
          'remarks': PlutoCell(value: index.remarks),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> hosRow(){
  List<PlutoRow> rows = [];
  for (var index in hospitalization) {
    memNamesHos(index.id);
    String day;
    String day1;
    if(index.doa != ''){
      DateTime date = DateTime.parse(index.doa!);
      day = DateFormat('MM/dd/y').format(date);
    }else{
      day = index.doa!;
    }
    if(index.dod != ''){
      DateTime date = DateTime.parse(index.dod!);
      day1 = DateFormat('MM/dd/y').format(date);
    }else{
      day1 = index.dod!;
    }
    rows.add(
      PlutoRow(
        cells: {
          'id': PlutoCell(value: memNameHos.idno),
          'member': PlutoCell(value: memNameHos.member),
          'relationship': PlutoCell(value: index.relationship),
          'confinee': PlutoCell(value: index.confinee),
          'hospital': PlutoCell(value: index.hospital),
          'doa': PlutoCell(value: day),
          'dod': PlutoCell(value: day1),
          'basic': PlutoCell(value: index.hosBasic),
          'claims': PlutoCell(value: index.hosClaims),
          'balance': PlutoCell(value: (index.hosBasic! - index.hosClaims!)),
          'classification': PlutoCell(value: index.classification),
          'remarks': PlutoCell(value: index.remarks),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> dacRow(){
  List<PlutoRow> rows = [];
  for (var index in dac) {
    memNamesDAC(index.id);
    String day;
    if(index.dod != ''){
      DateTime date = DateTime.parse(index.dod!);
      day = DateFormat('MM/dd/y').format(date);
    }else{
      day = index.dod!;
    }
    rows.add(
      PlutoRow(
        cells: {
          'id': PlutoCell(value: memNameDAC.idno),
          'name': PlutoCell(value: memNameDAC.member),
          'relationship': PlutoCell(value: index.relationship),
          'classification': PlutoCell(value: index.classification),
          'amount': PlutoCell(value: index.amount),
          'dod': PlutoCell(value: day),
        },
      ),
    );
  }
  return rows;
}

List<PlutoRow> dentalRow(){
  List<PlutoRow> rows = [];
  for (var index in dental) {
    memNamesDental(index.id);
    String day;
    if(index.date != ''){
      DateTime date = DateTime.parse(index.date!);
      day = DateFormat('MM/dd/y').format(date);
    }else{
      day = index.date!;
    }
    rows.add(
      PlutoRow(
        cells: {
          'id': PlutoCell(value: memNameDental.idno),
          'member': PlutoCell(value: memNameDental.member),
          'relationship': PlutoCell(value: index.relationship),
          'patient': PlutoCell(value: index.confinee),
          'clinic': PlutoCell(value: index.clinic),
          'classification': PlutoCell(value: index.classification),
          'date': PlutoCell(value: index.date),
        },
      ),
    );
  }
  return rows;
}

