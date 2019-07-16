import 'package:flutter/material.dart';
import 'package:prayertime/MyPainter.dart';
import 'package:prayertime/PrayerTime.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<PrayerTime> salatTimes;
  List<double> percents;
  double sunLocation ;

  Animation<double> fastAnimation;
  AnimationController fastController;

  Animation<double> slowAnimation;
  AnimationController slowController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Test Prayer times here
    salatTimes = getSalahTimes();
    percents = calculateSunPlaces() ;
    initAnimationController();
  }

  List<double> calculateSunPlaces() {
    //calculate total minutes between sunrise and sunset
    PrayerTime fagr = salatTimes[0];
    PrayerTime sunRise = salatTimes[1];
    PrayerTime dohr = salatTimes[2];
    PrayerTime asr = salatTimes[3];
    PrayerTime sunset = salatTimes[4];
    PrayerTime maghrib = salatTimes[5];
    PrayerTime isha = salatTimes[6];

    int minutesSunriseToSunset =
        sunset.duration.inMinutes - sunRise.duration.inMinutes;

    int minutesToDohr = dohr.duration.inMinutes - sunRise.duration.inMinutes;
    int minutesToAsr = asr.duration.inMinutes - sunRise.duration.inMinutes;

    int minutesToCurrentTime =
        Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute)
                .inMinutes -
            sunRise.duration.inMinutes;

    double dohrPercent = (minutesToDohr / minutesSunriseToSunset) * 100;
    double asrPercent = (minutesToAsr / minutesSunriseToSunset) * 100;
    double currentPercent =
        (minutesToCurrentTime / minutesSunriseToSunset) * 100;

    List<double> percents = [0, dohrPercent, asrPercent, 100 , currentPercent];
    return percents;
  }

  initAnimationController() {
    fastController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    fastAnimation = Tween<double>(begin: 0.5, end: 1).animate(fastController)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          slowController.forward();
        }
      });
    fastController.forward();

    slowController =
        AnimationController(duration: const Duration(seconds: 4), vsync: this);
    slowAnimation = Tween<double>(begin: 0.0, end: 1).animate(slowController)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
  }

  List<PrayerTime> getSalahTimes() {
    PrayTime prayers = new PrayTime();

    double latitude = 32.887211;
    double longitude = 13.191338;
    double timezone = 1;

    prayers.setTimeFormat(prayers.Time24);
    prayers.setCalcMethod(prayers.Egypt);
    prayers.setAsrJuristic(prayers.Shafii);
    prayers.setAdjustHighLats(prayers.AngleBased);
//    List<int> offsets = [0, 0, 0, 0, 0, 0, 0]; // {Fajr,Sunrise,Dhuhr,Asr,Sunset,Maghrib,Isha}
//    prayers.tune(offsets);

    DateTime now = new DateTime.now();

    List<String> prayerTimes =
        prayers.getPrayerTimes(now, latitude, longitude, timezone);
    List<String> prayerNames = prayers.getTimeNames();
    List<PrayerTime> times = List();
    for (int i = 0; i < prayerTimes.length; i++) {
      times.add(PrayerTime(prayerNames[i], prayerTimes[i]));
    }
    return times;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2.6,
              color: Colors.black38,
              padding: EdgeInsets.all(10),
              child: new CustomPaint(
                  painter: new MyPainter(
                      lineColor: Colors.amber,
                      pointsColor: Colors.blueAccent,
                      pointsPercent: percents,
                      fastAnimationValue: fastAnimation.value,
                      slowAnimationValue: slowAnimation.value,
                      lineWidth: 4.0)),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fastController.dispose();
    slowController.dispose();
  }
}

class PrayerTime {
  String name;

  String time;

  int timeHours;

  int timeMinutes;

  PrayerTime(this.name, this.time) {
    List<String> timesSplit = time.split(':');
    timeMinutes = int.parse(timesSplit[1].trim());
    timeHours = int.parse(timesSplit[0].trim());
  }

  Duration get duration => Duration(hours: timeHours, minutes: timeMinutes);
}
