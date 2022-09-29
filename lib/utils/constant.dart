
import 'package:tibud_care_system/model/model.dart';

String username = '';
String password = '';

List<Member> members = [];
List<Laboratory> laboratory = [];
List<Consultation> consultation = [];
List<Accidents> accidents = [];
List<Hospitalization> hospitalization = [];
List<DAC> dac = [];
List<Dental> dental = [];
List<Direct> ben = [];
List<ActivityRecords> activities = [];

UserAccount? user;
var memNameConsult;
var memNameLab;
var memNameAcc;
var memNameHos;
var memNameDAC;
var memNameDental;
var memConsult;
var memLab;
var memHos;
var memAcc;
var memDAC;
var memDental;

var beneficaryName;
var beneficiaryRelation;
var beneficiaryAge;
var beneficiaryRole;

bool addChecker = false;

// Future<void> excelLabRead(String path) async {
//   List<String> list = path.split('\n');
//   for (var e in list) {
//     var file = e.replaceAll(RegExp(r'\\'), '\/');
//     var bytes = File(file).readAsBytesSync();
//     var excel = Excel.decodeBytes(bytes);
//     for (var table in excel.tables.keys) {
//       for (var row in excel.tables[table]!.rows) {
//         if(row.isNotEmpty){
//           if(row[0] != null && row[0]!.value.toString().toUpperCase() != 'ID NO.'){
//             final lab = Laboratory();
//             lab.confinee = (row[3] == null)?' ':row[3]!.value;
//             lab.dol = (row[5] == null)?' ':row[5]!.value;
//             lab.hospital = (row[4] == null)?' ':row[4]!.value;
//             lab.relationship = (row[2] == null)?' ':row[2]!.value;
//             lab.labBasic = (row[6] == null || row[6]!.value is String || row[6]!.isFormula)? 0 : row[6]!.value.toDouble();
//             lab.labClaims = (row[7] == null || row[7]!.value is String || row[7]!.isFormula)? 0 : row[7]!.value.toDouble();
//             insertLab(row[0]!.value, lab);
//           }
//         }  
//       }
//     }
//   }
//   laboratory = await getAllLaboratory();
// }

// Future<void> excelAccRead(String path) async {
//   List<String> list = path.split('\n');
//   for (var e in list) {
//     var file = e.replaceAll(RegExp(r'\\'), '\/');
//     var bytes = File(file).readAsBytesSync();
//     var excel = Excel.decodeBytes(bytes);
//     for (var table in excel.tables.keys) {
//       for (var row in excel.tables[table]!.rows) {
//         if(row[0] != null){
//           if(row[0] != null && row[0]!.value.toString().toUpperCase() != 'ID NO.'){
//             final acc =  Accidents();
//             acc.confinee = (row[3] == null)?' ':row[3]!.value;
//             acc.relationship = (row[2] == null)?' ':row[2]!.value;
//             acc.hospital = (row[4] == null)?' ':row[4]!.value;
//             acc.doc = (row[5] == null)?' ':row[5]!.value;
//             acc.dod = (row[6] == null)?' ':row[6]!.value;
//             acc.accBasic = (row[7] == null || row[7]!.value is String || row[7]!.isFormula)? 0 : row[7]!.value.toDouble();
//             acc.accClaims = (row[8] == null || row[8]!.value is String || row[8]!.isFormula)? 0 : row[8]!.value.toDouble();
//             acc.classification = (row[10] == null)?' ':row[10]!.value;
//             acc.remarks = (row[11] == null)?' ':row[3]!.value;
//             insertAcc(row[0]!.value, acc);
//           }
//         }  
//       }
//     }
//   }
//   accidents = await getAllAccidents();


// }

  // List names = [];
  // members.forEach((u){
  //   if (names.contains(u.member)) print("duplicate ${u.member}");
  //   else names.add(u.member);
  // });