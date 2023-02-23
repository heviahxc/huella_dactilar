import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huella_dactilar/secondPage.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometric;
  late List<BiometricType> _availableBiometrics;
  String autherized = "No autorizado";

  Future<void> _checkBiometric() async {
    bool? canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }

  Future<void> _authenticate() async{
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if(!mounted) return;
    setState(() {
      autherized = authenticated ? 'Autenticacion exitosa' : 'Fallo en la autenticacion';
      if (authenticated) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondPage()));
      }
      print(autherized);
    });
  }

  void initState() {
    _checkBiometric();
    _getAvailableBiometric();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF3C3E52),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal:24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             const Center(
                child:  Text('Login', style: TextStyle(
                  color: Colors.white,
                  fontSize:48,
                  fontWeight:FontWeight.bold
                ),),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/huella.png',
                      width: 120
                    ),
                    const SizedBox(height: 10,),
                    const Text('HuellaAuth', style: TextStyle(
                      color: Colors.white,
                      fontSize:22,
                      fontWeight:FontWeight.bold
                    )),
                    Container(
                      width: 150.0,
                      child: const Text('Autentificate usando HuellaAuth sin utilizar password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        height: 1.5
                      ),
                      ),
                      
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical:15),
                      width: double.infinity,
                      child: MaterialButton(

                          onPressed: _authenticate ,
                          elevation: 0,
                          color: Color(0xFF04A5ED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical:14, horizontal: 24),
                            child: Text('Autentificar', style: TextStyle(
                              color: Colors.white,
                            )),
                          ),
                      ),
                    )
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

