import 'package:intl/intl.dart';
import 'package:tibud_care_system/model/model.dart';
import 'package:tibud_care_system/server/server.dart';

Future<dynamic> newConsult(String memID, String confinee, String relationship, String hospital, String doc, String dod, String basic, String claims, String classification, String remarks, String diagnosis, UserAccount user) async {
  final consult = Consultation();
  consult.confinee = confinee.toUpperCase();
  consult.relationship = relationship.toUpperCase();
  consult.hospital = hospital.toUpperCase();
  consult.doc = doc.isNotEmpty?DateFormat.yMd('en_US').parse(doc).toString():'';
  consult.dod = dod.isNotEmpty?DateFormat.yMd('en_US').parse(dod).toString():'';
  consult.labBasic = double.parse(basic);
  consult.labClaims = double.parse(claims);
  consult.classification = classification.toUpperCase();
  consult.remarks = remarks.toUpperCase();
  consult.diagnosis = diagnosis.toUpperCase();
  var result = await insertConsult(memID, consult, user);
  if(result == 'No Data Found') return result;
}

Future<dynamic> newLaboratory(String memID, String confinee, String relationship, String hospital, String dol, String basic, String claims, UserAccount user) async {
  final lab = Laboratory();
  lab.confinee = confinee.toUpperCase();
  lab.relationship = relationship.toUpperCase();
  lab.hospital = hospital.toUpperCase();
  lab.dol = dol.isNotEmpty?DateFormat.yMd('en_US').parse(dol).toString():'';
  lab.labBasic = double.parse(basic);
  lab.labClaims = double.parse(claims);
  var result = await insertLab(memID, lab, user);
  if(result == 'No Data Found') return result;
  
}

Future<dynamic> newAccident(String memID, String confinee, String relationship, String hospital, String doc, String dod, String basic, String claims, String classification, String remarks, UserAccount user) async {
  final acc = Accidents();
  acc.confinee = confinee.toUpperCase();
  acc.relationship  = relationship.toUpperCase();
  acc.hospital = hospital.toUpperCase();
  acc.doc = doc.isNotEmpty?DateFormat.yMd('en_US').parse(doc).toString():'';
  acc.dod = dod.isNotEmpty?DateFormat.yMd('en_US').parse(dod).toString():'';
  acc.accBasic = double.parse(basic);
  acc.accClaims = double.parse(claims);
  acc.classification = classification.toUpperCase();
  acc.remarks = remarks.toUpperCase();
  var result = await insertAcc(memID, acc, user);
  if(result == 'No Data Found') return result;
}

Future<dynamic> newHospitalization(String memID, String confinee, String relationship, String hospital, String doa, String dod, String basic, String claims, String classification, String remarks, UserAccount user) async {
  final hos = Hospitalization();
  hos.confinee = confinee.toUpperCase();
  hos.relationship  = relationship.toUpperCase();
  hos.hospital = hospital.toUpperCase();
  hos.doa = doa.isNotEmpty?DateFormat.yMd('en_US').parse(doa).toString():'';
  hos.dod = dod.isNotEmpty?DateFormat.yMd('en_US').parse(dod).toString():'';
  hos.hosBasic = double.parse(basic);
  hos.hosClaims = double.parse(claims);
  hos.classification = classification.toUpperCase();
  hos.remarks = remarks.toUpperCase();
  var result = await insertHos(memID, hos, user);
  if(result == 'No Data Found') return result;
}

Future<dynamic> newDAC(String memID, String relationship, String classification, String amount, String date, UserAccount user) async {
  final dac = DAC();
  dac.relationship = relationship.toUpperCase();
  dac.classification = classification.toUpperCase();
  dac.amount = double.parse(amount);
  dac.dod = date.isNotEmpty?DateFormat.yMd('en_US').parse(date).toString():'';
  var result = await insertDAC(memID, dac, user);
  if(result == 'No Data Found') return result;
}

Future<dynamic> newDental(String memID, String confinee, String relationship, String hospital, String classification, String date, UserAccount user) async {
  final dental = Dental();
  dental.confinee = confinee.toUpperCase();
  dental.relationship = relationship.toUpperCase();
  dental.clinic = hospital.toUpperCase();
  dental.classification = classification.toUpperCase();
  dental.date = date.isNotEmpty?DateFormat.yMd('en_US').parse(date).toString():'';
  var result = await insertDental(memID, dental, user);
  if(result == 'No Data Found') return result;
}

Future<void> newBeneficiary(String memID, String name, String relationship, String age, String role, UserAccount user) async {
  final beneficiary = Direct();
  beneficiary.name = name.toUpperCase();
  beneficiary.relationship = relationship.toUpperCase();
  beneficiary.age = age.toUpperCase();
  beneficiary.role = role.toUpperCase();
  var result = await insertBeneficiary(memID, beneficiary, user);
  if(result == 'No Data Found') return result;
}