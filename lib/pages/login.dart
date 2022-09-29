

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tibuc_care_system/pages/loading.dart';
import 'package:tibuc_care_system/server/server.dart';
import 'package:tibuc_care_system/utils/constant.dart';
import 'package:tibuc_care_system/utils/window_buttons.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _onFirstPage = true;

  final name2 = TextEditingController();
  final idno2 = TextEditingController();
  final confirm2 = TextEditingController();
  final uname2 = TextEditingController();
  final passwrd2 = TextEditingController();
  final user = TextEditingController();

  bool result = true;

  @override
  void initState() {
    super.initState();
    openObjectBoxStore();
  }

  @override
  void dispose() {
    super.dispose();
    closeStore();
  }


  void navigate(){
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Loading(uname: username, passwrd: password,)
      ),
    );
    allActivity('user account log in', username);
    user.text = '';
  }

  void adminNavigate(){
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const LoadForAdmin()
      ),
    );
    allActivity('admin log in', '[admin]');
    user.text = '';
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  PageTransitionSwitcher(
        duration: const Duration(seconds: 2),
        reverse: !_onFirstPage,
        transitionBuilder: (Widget child, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: _onFirstPage
            ? Row(
                key: UniqueKey(),
                children: [
                  Stack(
                    children: [
                      Container(
                        width: size.width * .7,
                        height: size.height,
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
                      SizedBox(
                        width: size.width * .7,
                        height: 30,
                        child: WindowTitleBarBox(
                          child: Row(
                            children: [
                              Expanded(child: MoveWindow()),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(100.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tibud Care\nSystem',
                              style: GoogleFonts.dosis(
                                textStyle: TextStyle(fontSize: size.width * .06, color: Colors.white, letterSpacing: 5)
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Text(
                              'Tibud Care is an integrated health and insurance care program of the Cooperative\nintended to support the health care and insurance needs of the members and their qualified\ndependents. The program was formally established in year 2000 as front-liner in helping\nprovide assistance to members and their dependents in times of emergencies, accidents and death.',
                              style: GoogleFonts.dosis(
                                textStyle: TextStyle(fontSize: size.width * .012, color: Colors.white)
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                      height: size.height,
                      child: Column(
                        children: [
                          WindowTitleBarBox(
                            child: Row(
                              children: [
                                Expanded(child: MoveWindow()),
                                const Windowbuttons()
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Premium',
                            style: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: size.width * .025, color: Colors.green.shade900, letterSpacing: 5)
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 40,
                              right: 40
                            ),
                            child: SizedBox(
                              width: size.width * .3,
                              height: size.height * .09,
                              child: TextFormField(
                                onChanged: (value){
                                  username = value;
                                },
                                controller: user,
                                toolbarOptions: const ToolbarOptions(selectAll: true),
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .009, color: Colors.green.shade900)
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const PasswordForm(),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 40,
                              right: 40
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: ButtonStyle(
                                  surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                ),
                                onPressed: (){
                                  setState(() {
                                    _onFirstPage = false;
                                  });
                                }, 
                                child: Text(
                                  "Register new Account",
                                  style: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 40,
                              right: 40,
                              top: 20
                            ),
                            child: SizedBox(
                              width: size.width * .3,
                              height: size.height * .06,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    )
                                  )
                                ),
                                onPressed: () async {
                                  int credentials = await userCheckCredentials(username, password);
                                  if(credentials == 1){
                                    adminNavigate();
                                  }else if(credentials == 2){
                                    navigate();
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: 
                                          Text(
                                            'Invalid username or password',
                                            style: GoogleFonts.dosis(
                                              textStyle: TextStyle(fontSize: size.width * .02,  fontWeight: FontWeight.bold, color: Colors.red.shade900)
                                            ), 
                                          )
                                      ),
                                    );
                                    allActivity('access denied: invalid username or password', user.text);
                                  }
                                },
                                child: Text(
                                  "LOGIN",
                                  style: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .015, color: Colors.white)
                                  ),
                                ),
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 40,
                              right: 40,
                              top: 10
                            ),
                            child: Text(
                              'Tibud Care recording and storing of contributions',
                              style: GoogleFonts.dosis(
                                textStyle: TextStyle(fontSize: size.width * .008, color: Colors.green.shade900)
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  )
                ],
              )
            : Stack(
              key: UniqueKey(),
              children: [
                Container(
                  width: size.width,
                  height: size.height,
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
                SizedBox(
                  width: size.width,
                  height: 30,
                  child: WindowTitleBarBox(
                    child: Row(
                      children: [
                        Expanded(child: MoveWindow()),
                        const Windowbuttons()
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: size.width *.6,
                    height: size.height * .7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * .3,
                          height: size.height * .7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 20
                                ),
                                child: Text(
                                  "Create New User",
                                  style: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .02, fontWeight: FontWeight.bold, color: Colors.green.shade900)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                child: Text(
                                  "for Tibud Care System",
                                  style: GoogleFonts.dosis(
                                    textStyle: TextStyle(fontSize: size.width * .015, color: Colors.green.shade900)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 20
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * .12,
                                      height: 50,
                                      child: TextFormField(
                                        controller: name2,
                                        toolbarOptions: const ToolbarOptions(selectAll: true),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'Name',
                                          labelStyle: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
                                          ),
                                        ),
                                      )
                                    ),
                                    SizedBox(
                                      width: size.width * .12,
                                      height: 50,
                                      child: TextFormField(
                                        controller: idno2,
                                        toolbarOptions: const ToolbarOptions(selectAll: true),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'ID No.',
                                          labelStyle: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
                                          ),
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 20
                                ),
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    controller: uname2,
                                    toolbarOptions: const ToolbarOptions(selectAll: true),
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: 'Username',
                                      labelStyle: GoogleFonts.dosis(
                                        textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * .12,
                                      height: 50,
                                      child: TextFormField(
                                        controller: passwrd2,
                                        toolbarOptions: const ToolbarOptions(selectAll: true),
                                        obscureText: true,
                                        obscuringCharacter: '•',
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'Password',
                                          labelStyle: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
                                          ),
                                        ),
                                      )
                                    ),
                                    SizedBox(
                                      width: size.width * .12,
                                      height: 50,
                                      child: TextFormField(
                                        controller: confirm2,
                                        obscureText: true,
                                        obscuringCharacter: '•',
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'Confirm',
                                          labelStyle: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
                                          ),
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 20
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * .12,
                                      height: size.height * .06,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            _onFirstPage = true;
                                            name2.clear();
                                            idno2.clear();
                                            uname2.clear();
                                            passwrd2.clear();
                                            confirm2.clear();
                                            user.clear();
                                          });
                                        }, 
                                        child: Text(
                                          "Sign in",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .01, color: Colors.green.shade900)
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * .12,
                                      height: size.height * .06,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.green.shade900),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50.0),
                                            )
                                          )
                                        ),
                                        onPressed: () async {
                                          if(name2.text.isNotEmpty && idno2.text.isNotEmpty && uname2.text.isNotEmpty && passwrd2.text.isNotEmpty){
                                            if(passwrd2.text == confirm2.text){
                                              bool valid = await checkCredentials(uname2.text, passwrd2.text);
                                              if(!valid){
                                                createNewUser(name2.text, idno2.text, uname2.text, passwrd2.text);
                                                setState(() {
                                                  _onFirstPage = true;
                                                  name2.clear();
                                                  idno2.clear();
                                                  uname2.clear();
                                                  passwrd2.clear();
                                                  confirm2.clear();
                                                });
                                              }else{
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Colors.grey.shade300,
                                                    content: 
                                                      Text(
                                                        'USERNAME and PASSWORD already in used.',
                                                        style: GoogleFonts.dosis(
                                                          textStyle: TextStyle(fontSize: size.width * .015, color: Colors.white)
                                                        ), 
                                                      )
                                                  ),
                                                );
                                                allActivity('access denied: username and password already in used.', uname2.text);
                                              }
                                            }else{
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: 
                                                    Text(
                                                      'Password does not match',
                                                      style: GoogleFonts.dosis(
                                                        textStyle: TextStyle(fontSize: size.width * .015, color: Colors.white)
                                                      ), 
                                                    )
                                                ),
                                              );
                                              allActivity('password does not match: ${passwrd2.text} != ${confirm2.text}', uname2.text);
                                            }
                                          }
                                          
                                        },
                                        child: Text(
                                          "Register",
                                          style: GoogleFonts.dosis(
                                            textStyle: TextStyle(fontSize: size.width * .015, color: Colors.white)
                                          ),
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: size.height * .7,
                            child: Center(
                              child: SizedBox(
                                width: size.width * .2,
                                height: size.height * .3,
                                child: Image.asset('assets/TIBUD_LOGO.png', fit: BoxFit.fill,)
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                )
              ],
            )
      ),
    );
  }
}


class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key}) : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}


class _PasswordFormState extends State<PasswordForm> {
  bool lock = true;
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        left: 40,
        right: 40
      ),
      child: SizedBox(
        width: size.width * .3,
        height: size.height * .09,
        child: TextFormField(
          onChanged: (value){
            password = value;
          },
          controller: pass,
          toolbarOptions: const ToolbarOptions(selectAll: true),
          obscureText: (lock) ? true:false,
          obscuringCharacter: '•',
          decoration: InputDecoration(
            suffixIcon: IconButton(
              splashRadius: 1,
              onPressed: (){
                setState(() {
                  lock = lock?false:true;
                });
              }, 
              icon: (lock)?const Icon(Icons.visibility_off):const Icon(Icons.visibility),
            ),
            labelText: 'Password',
            labelStyle: GoogleFonts.dosis(
              textStyle: TextStyle(fontSize: size.width * .009, color: Colors.green.shade900)
            ),
          ),
        )
      ),
    );
  }
}

