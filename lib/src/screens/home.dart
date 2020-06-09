import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget{
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin{
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> flapAnimation;
  AnimationController flapController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {    
    super.initState();
    catController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250)
    );
    catAnimation = Tween(begin:50.0, end: 140.0)
      .animate(
        CurvedAnimation(parent: catController, curve: Curves.easeInCirc)
      );

    flapController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200)
    );

    flapAnimation = Tween(begin: pi * .57 , end: pi * .6).animate(CurvedAnimation(curve: Curves.easeInOut, parent: flapController));
    flapAnimation.addStatusListener((status) { 
      if(flapController.status == AnimationStatus.completed){
        flapController.reverse();
      }else if(flapController.status == AnimationStatus.dismissed){
        flapController.forward();
      }    
    });
    flapController.forward();

    boxController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    boxAnimation = Tween(begin: pi* 0.00, end: pi * 0.005).animate(CurvedAnimation(curve: Curves.easeInOut, parent: boxController));
    boxAnimation.addStatusListener((status) {
      if(boxController.status == AnimationStatus.completed){
        boxController.reverse();
      }else if(boxController.status == AnimationStatus.dismissed){
        boxController.forward();
      }  
    });
    boxController.forward();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(title: Text('Animation'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
            overflow: Overflow.visible,
          ),
        ),
        onTap: onTap,
      )
    );

  }  

  onTap(){
    
    if(catController.status == AnimationStatus.completed){
      catController.reverse();
      flapController.forward();
      boxController.forward();
    }else if(catController.status == AnimationStatus.dismissed){
      catController.forward();
      flapController.stop();    
      boxController.stop();  
    }

  }

  Widget buildCatAnimation(){
    
    return AnimatedBuilder(
      animation: catAnimation, 
      builder: (context, child){
        return Positioned(
          child: child,
          bottom: catAnimation.value,
          left: 0.0,
          right: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox(){
    return AnimatedBuilder(
      animation: boxAnimation,
      builder:(context, child){
        return Transform.rotate(
          child: child,
          angle: boxAnimation.value,
        );
      },
      child: Container(
        height: 200.0,
        width: 200.0,
        color: Colors.brown,
      ) 
    );
   
  }

  Widget buildLeftFlap(){
    
    return Positioned(
      left: 10.0,
      top: 5.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        child: Container(
            height: 10.0,
            width: 125.0,
            color: Colors.brown,
          ),
        builder: (context, child){
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: flapAnimation.value,
          );
        }
      )
    ); 
  }

  Widget buildRightFlap(){
    
    return Positioned(
      right: 10.0,
      top: 5.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        child: Container(
            height: 10.0,
            width: 125.0,
            color: Colors.brown,
          ),
        builder: (context, child){
          return Transform.rotate(
            child: child,
            alignment: Alignment.topRight,
            angle: -flapAnimation.value,
          );
        }
      )
    ); 
  }

}