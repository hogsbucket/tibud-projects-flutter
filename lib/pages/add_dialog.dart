import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tibuc_care_system/model/model.dart';
import 'package:tibuc_care_system/utils/constant.dart';
import 'package:tibuc_care_system/utils/inserting_data.dart';

class AddNewData extends StatefulWidget {
  AddNewData({super.key, required this.index, required this.memberID, required this.userAccount});
  int index;
  String memberID;
  UserAccount userAccount;

  @override
  State<AddNewData> createState() => _AddNewDataState();
}

class _AddNewDataState extends State<AddNewData> {
  bool loading = false;
  final confinee = TextEditingController();
  final memID = TextEditingController();
  final relationship = TextEditingController();
  final hospital = TextEditingController();
  final doc = TextEditingController();
  final dol = TextEditingController();
  final doa = TextEditingController();
  final dod = TextEditingController();
  final basic = TextEditingController();
  final claims = TextEditingController();
  final classification = TextEditingController();
  final remarks = TextEditingController();
  final diagnosis = TextEditingController();

  final name = TextEditingController();
  final relation = TextEditingController();
  final age = TextEditingController();
  final role = TextEditingController();
  var user = UserAccount();

  int insertNum = 0;

  void exit(){
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    insertNum = 0;
    loading = false;
    user = widget.userAccount;
  }

  @override
  void dispose() {
    super.dispose();
    confinee.clear();
    memID.clear();
    relationship.clear();
    hospital.clear();
    doc.clear();
    dol.clear();
    doa.clear();
    dod.clear();
    basic.clear();
    claims.clear();
    classification.clear();
    remarks.clear();
    diagnosis.clear();
  }

  void scaffoldMessenger(){
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: 
        Text(
          'Member ID no found in database',
          style: GoogleFonts.dosis(
            textStyle: const TextStyle(fontSize: 20,  fontWeight: FontWeight.bold, color: Colors.white)
          ), 
        )
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(loading){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius:
            BorderRadius.all(
              Radius.circular(10.0))
        ),
        content: Builder(
          builder: (context){
            Future.delayed(Duration(seconds: 1), () async {
              switch (insertNum) {
                case 1:
                  var result = await newConsult(memID.text,confinee.text,relationship.text,hospital.text,doc.text,dod.text,basic.text.isEmpty?'0':basic.text,claims.text.isEmpty?'0':claims.text,classification.text,remarks.text,diagnosis.text,user);
                  if(result == 'No Data Found'){
                    scaffoldMessenger();
                  }
                  break;
                case 2:
                  var result = await newLaboratory(memID.text,confinee.text,relationship.text,hospital.text,dol.text,basic.text.isEmpty?'0':basic.text,claims.text.isEmpty?'0':claims.text,user);
                  if(result == 'No Data Found'){
                    scaffoldMessenger();
                  }
                  break;
                case 3:
                  var result = await newAccident(memID.text, confinee.text, relationship.text, hospital.text, doc.text, dod.text, basic.text.isEmpty?'0':basic.text, claims.text.isEmpty?'0':claims.text, classification.text, remarks.text, user);
                  if(result == 'No Data Found'){
                    scaffoldMessenger();
                  }
                  break;
                case 4:
                  var result = await newHospitalization(memID.text, confinee.text, relationship.text, hospital.text, doa.text, dod.text, basic.text.isEmpty?'0':basic.text, claims.text.isEmpty?'0':claims.text, classification.text, remarks.text, user);
                  if(result == 'No Data Found'){
                    scaffoldMessenger();
                  }
                  break;
                case 5:
                  var result = await newDAC(memID.text, relationship.text, classification.text, basic.text.isEmpty?'0':basic.text, dod.text, user);
                  if(result == 'No Data Found'){
                    scaffoldMessenger();
                  }
                  break;
                case 6:
                  var result = await newDental(memID.text,confinee.text,relationship.text,hospital.text,classification.text,dod.text, user);
                  if(result == 'No Data Found'){
                    scaffoldMessenger();
                  }
                  break;
                default:
                  if(name.text.isNotEmpty && relation.text.isNotEmpty && age.text.isNotEmpty && role.text.isNotEmpty){
                    await newBeneficiary(widget.memberID, name.text, relation.text, age.text, role.text, user);
                    beneficaryName = name.text;
                    beneficiaryRelation = relation.text;
                    beneficiaryAge = age.text;
                    beneficiaryRole = role.text;
                  }
              }
              exit();
            }); 
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
                      'Please wait....',
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(
                          fontSize: 15
                        )
                      ),
                    )
                  ],
                )
              ),
            );
          }
        ),
      );
    }else{
      switch (widget.index) {
        case 1:
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius:
                BorderRadius.all(
                  Radius.circular(10.0))
            ),
            title: Text(
              'Insert New Data',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black)
              ),
            ),
            content: Builder(
              builder: (context){
                return SizedBox(
                  height: size.height * .5,
                  width: size.width * .35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: TextFormField(
                          controller: memID,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Member ID',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .23,
                              child: TextFormField(
                                controller: confinee,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Confinee',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: relationship,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Relationship',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .13,
                              child: TextFormField(
                                controller: hospital,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Hospital',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: doc,
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
                                  labelText: 'DOC',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: dod,
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
                                  labelText: 'DOD',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: basic,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Basic',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: claims,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Claims',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: classification,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Classification',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: remarks,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Remarks',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: TextFormField(
                          controller: diagnosis,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Diagnosis',
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
                    setState(() {
                      insertNum = 1;
                      loading = true;
                    });
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
        case 2:
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius:
                BorderRadius.all(
                  Radius.circular(10.0))
            ),
            title: Text(
              'Insert New Data',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black)
              ),
            ),
            content: Builder(
              builder: (context){
                return SizedBox(
                  height: size.height * .3,
                  width: size.width * .3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: memID,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Member ID',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .18,
                              child: TextFormField(
                                controller: confinee,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Confinee',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: relationship,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Relationship',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: hospital,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Hospital',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: dol,
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
                                  labelText: 'DOL',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: basic,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Basic',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: claims,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Claims',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
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
                    setState(() {
                      insertNum = 2;
                      loading = true;
                    });
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
        case 3:
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius:
                BorderRadius.all(
                  Radius.circular(10.0))
            ),
            title: Text(
              'Insert New Data',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black)
              ),
            ),
            content: Builder(
              builder: (context){
                return SizedBox(
                  height: size.height * .4,
                  width: size.width * .35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: TextFormField(
                          controller: memID,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Member ID',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .2,
                              child: TextFormField(
                                controller: confinee,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Confinee',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: relationship,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Relationship',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .13,
                              child: TextFormField(
                                controller: hospital,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Hospital',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: doc,
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
                                  labelText: 'DOC',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: dod,
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
                                  labelText: 'DOD',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: basic,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Basic',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: claims,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Claims',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: classification,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Classification',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: remarks,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Remarks',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
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
                    setState(() {
                      insertNum = 3;
                      loading = true;
                    });
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
        case 4:
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius:
                BorderRadius.all(
                  Radius.circular(10.0))
            ),
            title: Text(
              'Insert New Data',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black)
              ),
            ),
            content: Builder(
              builder: (context){
                return SizedBox(
                  height: size.height * .4,
                  width: size.width * .35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: TextFormField(
                          controller: memID,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Member ID',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .23,
                              child: TextFormField(
                                controller: confinee,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Confinee',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: relationship,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Relationship',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .13,
                              child: TextFormField(
                                controller: hospital,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Hospital',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: doa,
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
                                  labelText: 'DOA',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: dod,
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
                                  labelText: 'DOD',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: basic,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Basic',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: claims,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Claims',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: classification,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Classification',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .16,
                              child: TextFormField(
                                controller: remarks,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Remarks',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
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
                    setState(() {
                      insertNum = 4;
                      loading = true;
                    });
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
        case 5:
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius:
                BorderRadius.all(
                  Radius.circular(10.0))
            ),
            title: Text(
              'Insert New Data',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black)
              ),
            ),
            content: Builder(
              builder: (context){
                return SizedBox(
                  height: size.height * .25,
                  width: size.width * .3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: memID,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Member ID',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: classification,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Classification',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: relationship,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Relationship',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: basic,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Amount',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: dod,
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
                                  labelText: 'DOD',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                    setState(() {
                      insertNum = 5;
                      loading = true;
                    });
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
        case 6:
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius:
                BorderRadius.all(
                  Radius.circular(10.0))
            ),
            title: Text(
              'Insert New Data',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black)
              ),
            ),
            content: Builder(
              builder: (context){
                return SizedBox(
                  height: size.height * .3,
                  width: size.width * .3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: memID,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Member ID',
                            labelStyle: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .18,
                              child: TextFormField(
                                controller: confinee,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Patient',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .1,
                              child: TextFormField(
                                controller: relationship,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Relationship',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: hospital,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Clinic',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .06,
                              width: size.width * .14,
                              child: TextFormField(
                                controller: classification,
                                style: GoogleFonts.dosis(
                                  textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  labelText: 'Classification',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900,)
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: size.height * .06,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: dod,
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
                            labelText: 'Date',
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
                    setState(() {
                      insertNum = 6;
                      loading = true;
                    });
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
        default:
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius:
                BorderRadius.all(
                  Radius.circular(10.0))
            ),
            title: Text(
              'Insert New Beneficiary',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(fontSize: 30, color: Colors.black)
              ),
            ),
            content: Builder(
              builder: (context){
                return SizedBox(
                  height: size.height * .35,
                  width: size.width * .3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: size.height * .08,
                        width: size.width * .3,
                        child: TextFormField(
                          controller: name,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Name',
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
                          controller: relation,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Relationship',
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
                          controller: age,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Age',
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
                          controller: role,
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(fontSize: size.width * .012, color: Colors.black)
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            labelText: 'Role',
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
                    setState(() {
                      insertNum = 7;
                      name.text = '';
                      relation.text = '';
                      age.text = '';
                      role.text = '';
                    });
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
                    setState(() {
                      insertNum = 7;
                      loading = true;
                    });
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
    }
  }
}