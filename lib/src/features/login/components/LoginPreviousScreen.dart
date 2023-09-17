import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neways3/src/features/prebook/widgets/PrebookScreen.dart';
import 'package:neways3/src/utils/constants.dart';
import 'LoginScreen.dart';

class LoginPreviousScreen extends StatefulWidget {
  const LoginPreviousScreen({super.key});

  @override
  State<LoginPreviousScreen> createState() => _LoginPreviousScreenState();
}

class _LoginPreviousScreenState extends State<LoginPreviousScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Neways Internation Company Ltd.'),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://img.freepik.com/free-vector/blue-fluid-background-frame_53876-99019.jpg?w=740&t=st=1689251008~exp=1689251608~hmac=6c965d38e2b687e8d028f4badbf5c486cfe6e19055ee5d07cc65e3b49515e8aa"),
              fit: BoxFit.cover,
            ),),
        child: MainWidget()

        // ElasticDrawer(
        //   mainColor: DColors.background,
        //   drawerColor: DColors.white,
        //   mainChild: MainWidget(),
        //   drawerChild: Container(
        //     alignment: Alignment.center,
        //      margin: EdgeInsets.only(top: 20),
        //      child:
        //
        //     Container(
        //       decoration:  BoxDecoration(
        //           shape: BoxShape.rectangle,
        //           border: Border.all(width: 1.0, color: DColors.primary),
        //           borderRadius: BorderRadius.circular(8)
        //       ),
        //       padding: const EdgeInsets.all(5),
        //       margin: EdgeInsets.only(left: 35),
        //       child: InkWell(
        //         onTap: (){
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => const PrebookScreen()));
        //         },
        //         child: Text("Registration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
        //       ),
        //     ),
        //   ),
        //   markPosition: .5,
        //   markWidth: 200,
        // ),
      ),
    );

  }
}


class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(0,70,0,150),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                   margin: EdgeInsets.only(left: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DPadding.half),
                    child: Image.network(
                      "https://neways3.com/wp-content/uploads/2019/05/Neways-Logo.png",
                      fit: BoxFit.cover,
                      height: 55,
                    ),
                  ),
                ),

                const HeightSpace(),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Welcome to Neways",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 110,
                        decoration:  BoxDecoration(
                            color: Colors.lightBlueAccent.withOpacity(0.2),
                            shape: BoxShape.rectangle,
                            border: Border.all(width: 1.0, color: DColors.primary),
                            borderRadius: BorderRadius.circular(8)

                        ),
                        padding: const EdgeInsets.fromLTRB(0,10,0,10),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()));
                          },
                          child: const Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,),
                        ),
                      ),
                    ),

                    Container(
                      width: 170,
                      decoration:  BoxDecoration(
                          color: Colors.lightBlueAccent.withOpacity(0.2),
                          shape: BoxShape.rectangle,
                          border: Border.all(width: 1.0, color: DColors.primary),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      padding: const EdgeInsets.fromLTRB(0,10,0,10),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const PrebookScreen()));
                        },
                        child: const Text("Interview Registration", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                      ),
                    ),
                  ],),
                )
              ],
            ),
          ),

         // Expanded(flex: 1,child: Container(),)
        ],
      ),
    );
  }
}

