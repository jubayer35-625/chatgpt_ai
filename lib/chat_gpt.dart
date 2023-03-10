import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{


  late AnimationController _controller;
  late Animation<double> _animation;

  late WebViewController controller;
  late bool _loadingInProgress;
  double progess=0;
  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(
      duration:  const Duration(seconds: 5),
      vsync: this,
    )
      ..repeat(reverse: true);

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);
    _loadingInProgress = true;
    _loadData();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future _loadData() async {
    await  Future.delayed( const Duration(seconds:5));
    _dataLoaded();
  }

  void _dataLoaded() {
    setState(() {
      _loadingInProgress = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return SizedBox(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              // opacity: _animation,
             // scale:_animation,
              turns: _animation,
              child:Padding(
                padding: const EdgeInsets.all(0.0),
                child: Lottie.asset("assets/loading.json"),
              ),
            ),

             Column(
               mainAxisAlignment: MainAxisAlignment.end,
               children:   [
                 Padding(
                   padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.25),
                   child: const Text("Open AI",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700,color: Colors.green),),
                 )

               ],
             )


          ],
        ),
      );
    } else {
      return SafeArea(
        child: Column(
          children: [
            // LinearProgressIndicator(
            //   color: Colors.white,
            //   backgroundColor: Colors.blueGrey,
            //   value: progess,
            // ),
            Expanded(
              child: WebView(
                javascriptMode:JavascriptMode.unrestricted,
                initialUrl: 'https://chat.openai.com/auth/login',
                onWebViewCreated: (controller){
                  this.controller=controller;
                },
                onProgress: (progess) => setState(() => this.progess = progess/100),
              ),
            ),
          ],
        ),
      );
    }
  }
  Future<bool>  _onBackPressed() async {
    if(await controller.canGoBack()){
      controller.goBack();
      return false;
    }
    return await showDialog(context: context,     builder: (context) {
      return AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Do you want to exit the App'),
        actions: <Widget>[
          TextButton(
            child: const Text('No',style: TextStyle(color: Colors.teal),),
            onPressed: () {
              Navigator.of(context).pop(false); //Will not exit the App
            },
          ),
          TextButton(
            child: const Text('Yes',style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop(true); //Will exit the App
            },
          )
        ],
      );
    },
    ) ?? false ;
  }
}