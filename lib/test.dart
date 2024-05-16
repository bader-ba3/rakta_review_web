import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReviewPage extends StatefulWidget {

  const ReviewPage({super.key});
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double _sliderValue = 1.0;
  TextEditingController opinionTextController = TextEditingController();
  bool isEnds=false;
  bool isInit = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Uri.base.queryParameters['id']==null
      ?Center(child: Text("no id"),)
      :FutureBuilder(
        future:  FirebaseFirestore.instance.collection("Reviews").doc(Uri.base.queryParameters['id']).get(),
        builder: (context,snapshot) {
          if(!isInit &&snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: Colors.black,),);
          }
          isInit=true;
          if(snapshot.data!.exists||isEnds) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 40,),
                    Container(
                        padding: EdgeInsets.all(8),
                        child: Image.asset("assets/logo-wide.png")),
                    Spacer(),
                    Text("Thank You.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                    Spacer(),
                    SizedBox(height: 40,),
                  ],
                ),
              );
            }
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            color: _getBackgroundColor(_sliderValue),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPaint(
                        size: Size(300, 300),
                        painter: FacePainter(_sliderValue),
                      ),
                      SizedBox(
                        height: 150,
                        width: 300,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: Text(
                      "Do you love this\nServices?",
                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 40, letterSpacing: 1.1),
                      textAlign: TextAlign.center,
                    )),
                    SizedBox(
                      height: 300,
                      width: 300,
                    ),
                    Container(
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width / 1.05,
                        child: Slider(
                          value: _sliderValue,
                          onChanged: (value) {
                            setState(() {
                              _sliderValue = value;
                            });
                          },
                          min: 0.0,
                          max: 1.0,
                          divisions: 50,
                          activeColor: Colors.black,
                          inactiveColor: Colors.white,
                          label: _sliderValue < 0.4
                              ? "bad"
                              : _sliderValue > 0.6
                                  ? "good"
                                  : "ok",
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      height: 150,
                      width: MediaQuery.sizeOf(context).width / 1.1,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: opinionTextController,
                        decoration: InputDecoration(hintText: "Write your opinion", border: InputBorder.none),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (opinionTextController.text.isNotEmpty) {
                          FirebaseFirestore.instance.collection("Reviews").doc(Uri.base.queryParameters['id']).set({"slider": _sliderValue.toString(), "opinion": opinionTextController.text});
                          setState(() {
                            isEnds = true;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                        height: 75,
                        width: MediaQuery.sizeOf(context).width / 1.5,
                        child: Center(
                            child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  // Widget _buildAnimatedContainer() {
  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 500),
  //     curve: Curves.easeInOut,
  //     color: _getBackgroundColor(_sliderValue),
  //     child: Center(
  //       child:
  //     ),
  //   );
  // }

  Color _getBackgroundColor(double value) {
    if (value < 0.5) {
      return Color.lerp(Color(0xffEF6A8A), Color(0xffD8CC61), value * 2)!;
    } else {
      return Color.lerp(Color(0xffD8CC61), Color(0xff82D65B), (value - 0.5) * 2)!;
    }
  }
}

class FacePainter extends CustomPainter {
  final double sliderValue;

  FacePainter(this.sliderValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.20), 20, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.20), 20, paint);
    canvas.drawCircle(Offset(lerpDouble(size.width * 0.85, size.height * 0.88, sliderValue)!, lerpDouble(size.height * 0.24, size.height * 0.23, sliderValue)!), 2, paint);
    canvas.drawCircle(Offset(lerpDouble(size.width * 0.15, size.height * 0.17, sliderValue)!, lerpDouble(size.height * 0.24, size.height * 0.23, sliderValue)!), 2, paint);

    final happyHeight = size.height * 0.20;
    final neutralHeight = size.height * 0.55;
    final sadHeight = size.height * 0.8;
    final controlPointY = sliderValue > 0.5 ? lerpDouble(happyHeight, neutralHeight, sliderValue * 2)! : lerpDouble(neutralHeight, sadHeight, (sliderValue - 0.5) * 2)!;
    final path = Path();
    path.moveTo(size.width * 0.1, neutralHeight);
    path.quadraticBezierTo(size.width * 0.5, controlPointY, size.width * 0.9, neutralHeight);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

double? lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
