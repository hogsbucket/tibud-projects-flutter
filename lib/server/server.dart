import 'dart:async';
import 'package:intl/intl.dart';
import 'package:tibuc_care_system/model/model.dart';
import 'package:tibuc_care_system/objectbox.g.dart';
import 'package:tibuc_care_system/utils/constant.dart';


Store? store;
Box<Member>? box;

//----------------------------------------------------------------------Open ObjectBoxStore()----------------------------------------------------------------------------------------------------
Future<dynamic> openObjectBoxStore() async {
  try {
    store = Store(getObjectBoxModel(), directory: "C:/tibud care server");
    if(store == null) return;
    box = store!.box<Member>();
    Box<AdminAccount> admin = store!.box<AdminAccount>();
    final rel = admin.getAll();
    if(rel.isEmpty)admin.put(AdminAccount());
    return;
  } catch (e) {
    return Future.error(e);
  }
}

//------------------------------------------------------------------------User Codes for Creation and Credentials-------------------------------------------------------------------------------------------

Future createNewUser(String name, String idno, String uname, String pword) async{
  Box<UserAccount> userAccount = store!.box<UserAccount>();
  final newuser = UserAccount();
  newuser.name = name.toUpperCase();
  newuser.idno = idno.toUpperCase();
  newuser.username = uname;
  newuser.password = pword;
  userAccount.put(newuser);
  allActivity('new user added named: ${name.toUpperCase()}, with idno: ${idno.toUpperCase()}, username: $uname, password: $pword', '[admin]');
}

Future<bool> checkCredentials(String uname, String pword) async {
  bool valid = false;
  Box<UserAccount> userAccount = store!.box<UserAccount>();
  final checkuser = userAccount.query(UserAccount_.username.equals(uname).and(UserAccount_.password.equals(pword))).build().find();
  allActivity('credentials being check for username: $uname and password: $pword', '[admin]');

  if(checkuser.isEmpty){
    return valid;
  }else{
    return valid = true;
  }
}

Future<int> userCheckCredentials(String uname, String pword) async {
  Box<UserAccount> userAccount = store!.box<UserAccount>();
  Box<AdminAccount> admin = store!.box<AdminAccount>();
  final rel = admin.get(1);
  final checkadmin = admin.query(AdminAccount_.username.equals(uname).and(AdminAccount_.password.equals(pword))).build().findUnique();
  
  if(checkadmin == null){
    final checkuser = userAccount.query(UserAccount_.username.equals(uname).and(UserAccount_.password.equals(pword))).build().findUnique();
    if(checkuser == null){
      return 0;
    }else{
      allActivity('user account access with account name: ${checkuser.name}', checkuser.name!);
      return 2;
    }
  }else{
    allActivity('admin account access', '[admin]');
    return 1;
  }
}

Future updateUser(UserAccount user) async {
  Box<UserAccount> userAccount = store!.box<UserAccount>();
  userAccount.put(user);
  allActivity('updated user account named:${user.name}', user.name!);
}

Future<UserAccount> getUserAccount(String uname, String pword) async {
  Box<UserAccount> userAccount = store!.box<UserAccount>();
  UserAccount finduser = userAccount.query(UserAccount_.username.equals(uname).and(UserAccount_.password.equals(pword))).build().findUnique()!;
  return finduser;
}

//------------------------------------------------------------------------Member Creation in Database-------------------------------------------------------------------------------------------

Future insertMembers(Member member, UserAccount user) async{
  List<UserAccount> userAccount = store!.box<UserAccount>().getAll();
  member.user.addAll(userAccount);
  allActivity('new member added with member name: ${member.member}', user.name!);
  box!.put(member);
}

Future<dynamic> getMember(String id, UserAccount user) async {
  final member = box!.query(Member_.idno.equals(id)).build().findUnique();
  return member;
}

Future addNewContribution(int id, double amount, String date, UserAccount user) async {
  final member = box!.get(id);
  final contribution = Contributions();
  contribution.amount = amount;
  contribution.date = date;
  member!.contributions.add(contribution);
  box!.put(member);
  allActivity('added new contribution for member: ${member.member} with amount: $amount', user.name!);
}

//------------------------------------------------------------------------Start Query Codes-------------------------------------------------------------------------------------------

Future<List<Member>> queryDashList(String search) async {
  var results = box!.query(Member_.member.contains(search).orAny([Member_.idno.contains(search), Member_.branch.contains(search)])).build().find();
  QueryBuilder<Member> builder = box!.query();
  builder.linkMany(Member_.contributions, Contributions_.date.contains(search));
  var results2 = builder.build().find();
  results.addAll(results2);
  if(search == ''){
    results = box!.getAll();
  }
  final ids = Set();
  results.retainWhere((x) => ids.add(x.id));
  return results;
}

Future<List<Consultation>> queryConsultList(String search) async {
  Box<Consultation> consult = store!.box<Consultation>();
  var results = consult.query(Consultation_.hospital.contains(search).orAny([Consultation_.relationship.contains(search), Consultation_.dod.contains(search), Consultation_.doc.contains(search), Consultation_.confinee.contains(search), Consultation_.classification.contains(search), Consultation_.remarks.contains(search), Consultation_.diagnosis.contains(search)])).build().find();
  QueryBuilder<Consultation> builder = consult.query();
  builder.backlinkMany(Member_.consult, Member_.member.contains(search).orAny([Member_.idno.contains(search), Member_.branch.contains(search)]));
  var results2 = builder.build().find();
  results.addAll(results2);
  if(search == ''){
    results = consult.getAll();
  }
  final ids = Set();
  results.retainWhere((x) => ids.add(x.id));
  return results;
}

Future<List<Laboratory>> queryLabList(String search) async {
  Box<Laboratory> lab = store!.box<Laboratory>();
  var results = lab.query(Laboratory_.hospital.contains(search).orAny([Laboratory_.relationship.contains(search), Laboratory_.dol.contains(search), Laboratory_.confinee.contains(search)])).build().find();
  QueryBuilder<Laboratory> builder = lab.query();
  builder.backlinkMany(Member_.lab, Member_.member.contains(search).orAny([Member_.idno.contains(search), Member_.branch.contains(search)]));
  var results2 = builder.build().find();
  results.addAll(results2);
  if(search == ''){
    results = lab.getAll();
  }
  final ids = Set();
  results.retainWhere((x) => ids.add(x.id));
  return results;
}

Future<List<Accidents>> queryAccList(String search) async {
  Box<Accidents> acc = store!.box<Accidents>();
  var results = acc.query(Accidents_.hospital.contains(search).orAny([Accidents_.dod.contains(search), Accidents_.doc.contains(search), Accidents_.classification.contains(search), Accidents_.remarks.contains(search)])).build().find();
  QueryBuilder<Accidents> builder = acc.query();
  builder.backlinkMany(Member_.accident, Member_.member.contains(search).or(Member_.idno.contains(search)));
  var results2 = builder.build().find();
  results.addAll(results2);
  if(search == ''){
    results = acc.getAll();
  }
  final ids = Set();
  results.retainWhere((x) => ids.add(x.id));
  return results;
}

Future<List<Hospitalization>> queryHosList(String search) async {
  Box<Hospitalization> hos = store!.box<Hospitalization>();
  var results = hos.query(Hospitalization_.hospital.contains(search).orAny([Hospitalization_.dod.contains(search), Hospitalization_.doa.contains(search), Hospitalization_.classification.contains(search), Hospitalization_.remarks.contains(search)])).build().find();
  QueryBuilder<Hospitalization> builder = hos.query();
  builder.backlinkMany(Member_.hospitalization, Member_.member.contains(search).or(Member_.idno.contains(search)));
  var results2 = builder.build().find();
  results.addAll(results2);
  if(search == ''){
    results = hos.getAll();
  }
  final ids = Set();
  results.retainWhere((x) => ids.add(x.id));
  return results;
}

Future<List<DAC>> queryDACList(String search) async {
  Box<DAC> dac = store!.box<DAC>();
  var results = dac.query(DAC_.classification.contains(search).orAny([DAC_.dod.contains(search)])).build().find();
  QueryBuilder<DAC> builder = dac.query();
  builder.backlinkMany(Member_.dac, Member_.member.contains(search).or(Member_.idno.contains(search)));
  var results2 = builder.build().find();
  results.addAll(results2);
  if(search == ''){
    results = dac.getAll();
  }
  final ids = Set();
  results.retainWhere((x) => ids.add(x.id));
  return results;
}

Future<List<Dental>> queryDentalList(String search) async {
  Box<Dental> den = store!.box<Dental>();
  var results = den.query(Dental_.classification.contains(search).orAny([Dental_.clinic.contains(search), Dental_.date.contains(search)])).build().find();
  QueryBuilder<Dental> builder = den.query();  
  builder.backlinkMany(Member_.dental, Member_.member.contains(search).or(Member_.idno.contains(search)));
  var results2 = builder.build().find();
  results.addAll(results2);
  if(search == ''){
    results = den.getAll();
  }
  final ids = Set();
  results.retainWhere((x) => ids.add(x.id));
  return results;
}

//------------------------------------------------------------------------End Query Codes-------------------------------------------------------------------------------------------

//------------------------------------------------------------------------Start Update Codes-------------------------------------------------------------------------------------------

Future updateMember(Member member, UserAccount user) async {
  box!.put(member);
  allActivity('updated member with member name: ${member.member}', user.name!);
}

Future updateConsultation(Consultation consult, UserAccount user)async{
  Box<Consultation> con = store!.box<Consultation>();
  con.put(consult);
  allActivity('updated consultation details with consultation confinee: ${consult.confinee}', user.name!);
}

Future updateLaboratory(Laboratory laboratory, UserAccount user)async{
  Box<Laboratory> lab = store!.box<Laboratory>();
  lab.put(laboratory);
  allActivity('updated laboratory details with laboratory confinee: ${laboratory.confinee}', user.name!);
}

Future updateAccident(Accidents accident, UserAccount user)async{
  Box<Accidents> acc = store!.box<Accidents>();
  acc.put(accident);
  allActivity('updated accidents detail with accident confinee: ${accident.confinee}', user.name!);
}

Future updateHospitalization(Hospitalization hospitalization, UserAccount user)async{
  Box<Hospitalization> hos = store!.box<Hospitalization>();
  hos.put(hospitalization);
  allActivity('updated hospitalization detail with hospitalization confinee: ${hospitalization.confinee}', user.name!);
}

Future updateDAC(DAC deahaid, UserAccount user)async{
  Box<DAC> dac = store!.box<DAC>();
  dac.put(deahaid);
  allActivity('updated DAC details with DAC classification: ${deahaid.classification}', user.name!);
}

Future updateDental(Dental dental, UserAccount user)async{
  Box<Dental> den = store!.box<Dental>();
  den.put(dental);
  allActivity('updated dental with dental patient: ${dental.confinee} details', user.name!);
}

//------------------------------------------------------------------------End Update Codes-------------------------------------------------------------------------------------------






//------------------------------------------------------------------Start Insert Codes to Database--------------------------------------------------------------------------
Future insertConsult(String id, Consultation consult, UserAccount user) async {
  final result = box!.query(Member_.idno.equals(id)).build().findUnique();
  if(result == null){
    return 'No Data Found';
  }else{
    result.consult.add(consult);
    box!.put(result);
    allActivity('inserted new consultation(${consult.confinee}) to database', user.name!);
  }
}

Future insertLab(String id, Laboratory lab, UserAccount user) async {
  final result = box!.query(Member_.idno.equals(id)).build().findUnique();
  if(result == null){
    return 'No Data Found';
  }else{
    result.lab.add(lab);
    box!.put(result);
    allActivity('inserted new laboratory(${lab.confinee}) to database', user.name!);
  }
}

Future insertAcc(String id, Accidents acc, UserAccount user) async {
  final result = box!.query(Member_.idno.equals(id)).build().findUnique();
  if(result == null){
    return 'No Data Found';
  }else{
    result.accident.add(acc);
    box!.put(result);
    allActivity('inserted new accident(${acc.confinee}) to database', user.name!);
  }
}

Future insertHos(String id, Hospitalization hos, UserAccount user) async {
  final result = box!.query(Member_.idno.equals(id)).build().findUnique();
  if(result == null){
    return 'No Data Found';
  }else{
    result.hospitalization.add(hos);
    box!.put(result);
    allActivity('inserted new hospitalization(${hos.confinee}) to database', user.name!);
  }
}

Future insertDAC(String id, DAC dac, UserAccount user) async {
  final result = box!.query(Member_.idno.equals(id)).build().findUnique();
  if(result == null){
    return 'No Data Found';
  }else{
    result.dac.add(dac);
    box!.put(result);
    allActivity('inserted new DAC(${dac.amount}) to database', user.name!);
  }
}

Future insertDental(String id, Dental dental, UserAccount user) async {
  final result = box!.query(Member_.idno.equals(id)).build().findUnique();
  if(result == null){
    return 'No Data Found';
  }else{
    result.dental.add(dental);
    box!.put(result);
    allActivity('inserted new Dental(${dental.confinee}) to database', user.name!);
  }
}

Future insertBeneficiary(String id, Direct beneficiary, UserAccount user) async {
  var result = box!.query(Member_.idno.equals(id)).build().findUnique();
  if(result == null){
    return 'No Data Found';
  }else{
    result.direct.add(beneficiary);
    box!.put(result);
    allActivity('inserted new beneficiary(${beneficiary.name}) to database', user.name!);
  }
}

//-------------------------------------------------------------------------End of Insert Codes to Database------------------------------------------------------------------------------------






//-------------------------------------------------------------------------Start Member info Search--------------------------------------------------------------------------------
Future memNamesConsultation(int id) async{
  QueryBuilder<Member> builder = box!.query();
  builder.linkMany(Member_.consult, Consultation_.id.equals(id));
  memNameConsult = builder.build().findUnique();
}

Future memNamesLab(int id) async{
  QueryBuilder<Member> builder = box!.query();
  builder.linkMany(Member_.lab, Laboratory_.id.equals(id));
  memNameLab = builder.build().findUnique();
}

Future memNamesAcc(int id) async{
  QueryBuilder<Member> builder = box!.query();
  builder.linkMany(Member_.accident, Accidents_.id.equals(id));
  memNameAcc = builder.build().findUnique();
}

Future memNamesHos(int id) async{
  QueryBuilder<Member> builder = box!.query();
  builder.linkMany(Member_.hospitalization, Hospitalization_.id.equals(id));
  memNameHos = builder.build().findUnique();
}

Future memNamesDAC(int id) async{
  QueryBuilder<Member> builder = box!.query();
  builder.linkMany(Member_.dac, DAC_.id.equals(id));
  memNameDAC = builder.build().findUnique();
}

Future memNamesDental(int id) async{
  QueryBuilder<Member> builder = box!.query();
  builder.linkMany(Member_.dental, Dental_.id.equals(id));
  memNameDental = builder.build().findUnique();
}

//-------------------------------------------------------------------------End Member info Search-------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------Fetch Data Start--------------------------------------------------------------------------------------------------------------

Future<void> fetchMembers() async {
  members = await getAllMember();
}

Future<void> fetchConsult() async {
  consultation = await getAllConsultation();
}

Future<void> fetchLab() async {
  laboratory = await getAllLaboratory();
}

Future<void> fetchAccidents() async {
  accidents = await getAllAccidents();
}

Future<void> fetchHospitalization() async {
  hospitalization = await getAllHospitalization();
}

Future<void> fetchDAC() async {
  dac = await getAllDAC();
}

Future<void> fetchDental() async {
  dental = await getAllDental();
}

Future<void> fetchBeneficiaries(int id)async{
  ben = await getAllBeneficiaries(id);
}


//--------------------------------------------------------------------------Fetch Data Start--------------------------------------------------------------------------------------------------------------





//-------------------------------------------------------------------------Start getAll()----------------------------------------------------------------------------------------------------------

Future<List<Member>> getAllMember() async {
  final results = box!.getAll();
  results.forEach((e) => e.contributions.sort(((a, b) => a.date!.compareTo(b.date!))));
  return results;
}

Future<List<Laboratory>> getAllLaboratory() async {
  Box<Laboratory> lab = store!.box<Laboratory>();
  final results = lab.getAll();
  return results;
}

Future<List<Consultation>> getAllConsultation() async {
  Box<Consultation> consult = store!.box<Consultation>();
  final results = consult.getAll();
  return results;
}

Future<List<Accidents>> getAllAccidents() async {
  Box<Accidents> acc = store!.box<Accidents>();
  final results = acc.getAll();
  return results;
}

Future<List<Hospitalization>> getAllHospitalization() async {
  Box<Hospitalization> hos = store!.box<Hospitalization>();
  final results = hos.getAll();
  return results;
}

Future<List<DAC>> getAllDAC() async {
  Box<DAC> dac = store!.box<DAC>();
  final results = dac.getAll();
  return results;
}

Future<List<Dental>> getAllDental() async {
  Box<Dental> dental = store!.box<Dental>();
  final results = dental.getAll();
  return results;
}

Future<List<Direct>> getAllBeneficiaries(int id) async {
  final results = box!.get(id);
  return results!.direct;
}

//-------------------------------------------------------------------------getMember() Codes----------------------------------------------------------------------------------------------------------

Future<void> getMemConsult(int id) async {
  Box<Consultation> consult = store!.box<Consultation>();
  QueryBuilder<Consultation> builder = consult.query();
  builder.backlinkMany(Member_.consult, Member_.id.equals(id));
  memConsult = builder.build().find();
}

Future<void> getMemLab(int id) async {
  Box<Laboratory> lab = store!.box<Laboratory>();
  QueryBuilder<Laboratory> builder = lab.query();
  builder.backlinkMany(Member_.lab, Member_.id.equals(id));
  memLab = builder.build().find();
}

Future<void> getMemHos(int id) async {
  Box<Hospitalization> hos = store!.box<Hospitalization>();
  QueryBuilder<Hospitalization> builder = hos.query();
  builder.backlinkMany(Member_.hospitalization, Member_.id.equals(id));
  memHos = builder.build().find();
}

Future<void> getMemAcc(int id) async {
  Box<Accidents> acc = store!.box<Accidents>();
  QueryBuilder<Accidents> builder = acc.query();
  builder.backlinkMany(Member_.accident, Member_.id.equals(id));
  memAcc = builder.build().find();
}

Future<void> getMemDAC(int id) async {
  Box<DAC> dac = store!.box<DAC>();
  QueryBuilder<DAC> builder = dac.query();
  builder.backlinkMany(Member_.dac, Member_.id.equals(id));
  memDAC = builder.build().find();
}

Future<void> getMemDental(int id) async {
  Box<Dental> dental = store!.box<Dental>();
  QueryBuilder<Dental> builder = dental.query();
  builder.backlinkMany(Member_.dental, Member_.id.equals(id));
  memDental = builder.build().find();
}

//-------------------------------------------------------------------------Delete from Database------------------------------------------------------------------------------------------------------
Future<void> removeFromDatabase(String name, int id, UserAccount user) async {
  Box<Direct> direct = store!.box<Direct>();
  QueryBuilder<Direct> builder = direct.query(Direct_.name.equals(name));
  builder.link(Direct_.member, Member_.id.equals(id));
  Direct result = builder.build().findUnique()!;
  direct.remove(result.id);
  allActivity('removed beneficiary name: ${result.name}', user.name!);
}

//-------------------------------------------------------------------------Record All Activity--------------------------------------------------------------------------------------------------------
Future<void> allActivity(String activity, String name) async {
  Box<AdminAccount> admin = store!.box<AdminAccount>();
  final result = admin.get(1);
  result!.activities.add(
    ActivityRecords()..activity = activity ..userAccount = name ..date = DateTime.now()
  );
  admin.put(result);
}

Future<List<ActivityRecords>> getAllActivity() async {
  Box<AdminAccount> admin = store!.box<AdminAccount>();
  final result = admin.get(1);
  return result!.activities;
}

Future<List<ActivityRecords>> queryActivityList(String search) async {
  Box<ActivityRecords> activity = store!.box<ActivityRecords>();
  final result = activity.query(ActivityRecords_.activity.contains(search)).build().find();
  return result;
}

//--------------------------------------------------------------------------Close ObjectBox Store-----------------------------------------------------------------------------------------------------
void closeStore(){
  allActivity('application closed database store', '[admin]');
  store!.close();
}