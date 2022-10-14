import 'package:envi/UiWidget/navigationdrawer.dart';
import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/consumer/ScheduleListAlertConsumer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../UiWidget/appbar.dart';
import '../../UiWidget/cardbanner.dart';
import '../../appConfig/Profiledata.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../uiwidget/mapPageWidgets/mappagescreen.dart';
import '../../web_service/Constant.dart';
import '../onRide/onRideWidget.dart';
import '../payment/payment_page.dart';
import '../waitingForDriverScreen/waitingForDriverScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String name="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<firestoreLiveTripDataNotifier>(
        builder: (context, value, child) {
      //If this was not given, it was throwing error like setState is called during build . RAGHU VT
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && value.liveTripData!=null) {
         if ( value.liveTripData!.tripInfo.tripStatus == TripStatusRequest ||
              value.liveTripData!.tripInfo.tripStatus == TripStatusAlloted||
             value.liveTripData!.tripInfo.tripStatus == TripStatusArrived) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                         WaitingForDriverScreen()),
                (Route<dynamic> route) => false);
          }else if(value.liveTripData!.tripInfo.tripStatus == TripStatusOnboarding){
           Navigator.of(context).pushAndRemoveUntil(
               MaterialPageRoute(
                   builder: (BuildContext context) =>
                   const OnRideWidget()),
                   (Route<dynamic> route) => false);
         }else if (value.liveTripData!.tripInfo.tripStatus==TripStatusCompleted){
           Navigator.of(context).pushAndRemoveUntil(
               MaterialPageRoute(
                   builder: (BuildContext context) =>
                   const PaymentPage()),
                   (Route<dynamic> route) => false);
         }
      }
      });
      return Scaffold(
        drawer: NavigationDrawer(),
        body: Stack(alignment: Alignment.centerRight, children: <Widget>[
          MyMap(),
          Column(
            children: [
              AppBarWidget(),
               CardBanner(
                  title: 'Welcome $name',
                  image: 'assets/images/welcome_card_dashboard.png'),
            ],
          ),
        ]),
      );
    });
  }

  Future<void> getUserName() async {

    setState(() {
      name = Profiledata().getname();

    });
  }
}
