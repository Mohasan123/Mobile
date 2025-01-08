import 'package:flutter/material.dart';
import 'package:weatherfinal_proj/ex01/screens/weather_screen_ex01.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const WeatherScreenEx01(),
    );
  }
}


/*     return const WrapperScene(
    sizeCanvas: Size(350, 540),
    isLeftCornerGradient: true,
    colors: [
      ],
    children: [
      minified:eI(cloudConfig: CloudConfig(size: 250, color: Color(0x65212121), icon: IconData(63056, fontFamily: 'MaterialIcons'), widgetCloud: null, x: 20, y: 35, scaleBegin: 1, scaleEnd: 1.08, scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00), slideX: 20, slideY: 0, slideDurMill: 3000, slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),),
minified:eI(cloudConfig: CloudConfig(size: 160, color: Color(0x77212121), icon: IconData(63056, fontFamily: 'MaterialIcons'), widgetCloud: null, x: 140, y: 130, scaleBegin: 1, scaleEnd: 1.1, scaleCurve: Cubic(0.40, 0.00, 0.20, 1.00), slideX: 20, slideY: 4, slideDurMill: 2000, slideCurve: Cubic(0.40, 0.00, 0.20, 1.00)),),
],
  );Mohamed*21@@@@
           
  
   */