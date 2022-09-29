import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tibud_care_system/model/model.dart';
import 'package:tibud_care_system/pages/admin.dart';
import 'package:tibud_care_system/pages/dashboard.dart';
import 'package:tibud_care_system/pages/member_information.dart';
import 'package:tibud_care_system/server/server.dart';
import 'package:tibud_care_system/utils/constant.dart';

class LoadForAdmin extends StatefulWidget {
  const LoadForAdmin({super.key});

  @override
  State<LoadForAdmin> createState() => _LoadForAdminState();
}

class _LoadForAdminState extends State<LoadForAdmin> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      activities = await getAllActivity();
      navigate();
    });
  }

  void navigate(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const AdminUser()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20,),
            Text(
              'Accessing Administrator Account...',
              style: GoogleFonts.dosis(
                textStyle: TextStyle(
                  fontSize: size.width * .015
                )
              ),
            )
          ],
        )
      ),
    );
  }
}


class Loading extends StatefulWidget {
  Loading({Key? key, required this.uname, required this.passwrd}) : super(key: key);
  String uname;
  String passwrd;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      UserAccount user = await getUserAccount(widget.uname, widget.passwrd);
      members = await getAllMember();
      laboratory = await getAllLaboratory();
      accidents = await getAllAccidents();
      consultation = await getAllConsultation();
      hospitalization = await getAllHospitalization();
      dac = await getAllDAC();
      dental = await getAllDental();
      navigate(user);
    });
  }

  void navigate(UserAccount user){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Dashboard(user: user,)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20,),
            Text(
              'Retrieving data. Please wait....',
              style: GoogleFonts.dosis(
                textStyle: TextStyle(
                  fontSize: size.width * .015
                )
              ),
            )
          ],
        )
      ),
    );
  }
}

class LoadingforInfoPage extends StatefulWidget {
  LoadingforInfoPage({super.key, required this.id, required this.user});
  String id;
  UserAccount user;

  @override
  State<LoadingforInfoPage> createState() => _LoadingforInfoPageState();
}

class _LoadingforInfoPageState extends State<LoadingforInfoPage> {

  Member member = Member();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      member = await getMember(widget.id, widget.user);
      navigate();
    });
  }

  void navigate(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Information(info: member, user: widget.user)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20,),
            Text(
              'Retrieving data. Please wait....',
              style: GoogleFonts.dosis(
                textStyle: TextStyle(
                  fontSize: size.width * .015
                )
              ),
            )
          ],
        )
      ),
    );
  }
}