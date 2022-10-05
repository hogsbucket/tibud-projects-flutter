import 'package:objectbox/objectbox.dart';

@Entity()
class AdminAccount{
  int id = 0;
  String username = 'admin';
  String password = 'tibud35460901904';

  final activities = ToMany<ActivityRecords>();
}

@Entity()
class ActivityRecords{
  int id = 0;
  String? activity;
  String? userAccount;
  String? password;
  String? name;
  String? idno;
  DateTime? date;
}

@Entity()
class UserAccount{
  int id = 0;
  String? name;
  String? idno;
  String? username;
  String? password;

  @Backlink()
  final members = ToMany<Member>();
}

@Entity()
class Member{
  int id = 0;

  String? idno;
  String? member;
  String? branch;
  String? dateOfHire;

  final user = ToMany<UserAccount>();
  final contributions = ToMany<Contributions>();
  final lab = ToMany<Laboratory>();
  final accident = ToMany<Accidents>();
  final hospitalization = ToMany<Hospitalization>();
  final dac = ToMany<DAC>();
  final dental = ToMany<Dental>();
  final consult = ToMany<Consultation>();

  @Backlink()
  final direct = ToMany<Direct>();
}

@Entity()
class Contributions{
  int id = 0;
  double? amount;
  String? date;
}

@Entity()
class Direct{
  int id = 0;
  String? name;
  String? relationship;
  String? age;
  String? role;

  final member = ToOne<Member>();
}

@Entity()
class Consultation{
  int id = 0;
  double? labBasic;
  double? labClaims;
  String? doc;
  String? dod;
  String? hospital;
  String? confinee;
  String? relationship;
  String? classification;
  String? remarks;
  String? diagnosis;

  @Backlink()
  final consultMembers = ToMany<Member>();
}

@Entity()
class Laboratory{
  int id = 0;
  double? labBasic;
  double? labClaims;
  String? dol;
  String? hospital;
  String? confinee;
  String? relationship;

  @Backlink()
  final labMembers = ToMany<Member>();
}

@Entity()
class Accidents{
  int id = 0;
  double? accBasic;
  double? accClaims;
  String? doc;
  String? dod;
  String? hospital;
  String? classification;
  String? remarks;
  String? confinee;
  String? relationship;

  @Backlink()
  final accMembers = ToMany<Member>();
}

@Entity()
class Hospitalization{
  int id = 0;
  double? hosBasic;
  double? hosClaims;
  String? hospital;
  String? doa;
  String? dod;
  String? classification;
  String? remarks;
  String? confinee;
  String? relationship;

  @Backlink()
  final hosMembers = ToMany<Member>();
}

@Entity()
class DAC{
  int id = 0;
  double? amount;
  String? dod;
  String? classification;
  String? relationship;

  @Backlink()
  final dacMembers = ToMany<Member>();
}

@Entity()
class Dental{
  int id = 0;
  String? clinic;
  String? classification;
  String? date;
  String? confinee;
  String? relationship;

  @Backlink()
  final denMembers = ToMany<Member>();
}