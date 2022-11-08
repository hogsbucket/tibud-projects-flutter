
import 'dart:isolate';

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
List<String> disabledBranch = [];
List<String> allBranch = [];

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
var dates = [];

String branch = '';
bool addChecker = false;
String ophead = 'Mary Grace T. Sebua';
String postingclerk = 'Jenny P. Palacios';

class RequiredArgs {
  late final SendPort sendPort;
  late String? path;

  RequiredArgs(this.path, this.sendPort);
}