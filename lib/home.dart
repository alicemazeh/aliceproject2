import 'package:flutter/material.dart';
import 'menu.dart';
class Home extends StatefulWidget {
  const Home({super.key});
  @override
  _HomeState createState() => _HomeState();}
class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: const IconThemeData(
        color: Colors.white,
      ),
        title: const Text('Eat On Wheel', style: TextStyle(color: Colors.white,fontFamily: 'PlayfairDisplay',)),
        centerTitle: true,
        backgroundColor: const Color(0xFFD3131D),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('homePhoto.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            height: 500,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'HUNGRY? \n'
                      'One click and we will bring bites and delights right to your door 🍔🛵',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton( style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      return const Color(0xFFD3131D); // Default button color
                    },
                  ),
                ),
                  onPressed: () {
                    _navigateToMenu(context);
                  },
                  child:const Text('Click here',style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _navigateToMenu(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const Menu(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end:end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}