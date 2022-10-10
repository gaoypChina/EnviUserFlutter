import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:envi/enum/BookingTiming.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/sidemenu/searchDriver/model/driverListModel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../appConfig/appConfig.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/carCategoriesWidget.dart';
import '../../uiwidget/fromtowidget.dart';
import '../../uiwidget/mapPageWidgets/mapDirectionWidget.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
import '../../web_service/ApiCollection.dart';
import '../home/homePage.dart';
import 'model/vehiclePriceClasses.dart';

class BookScheduleTrip extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

  const BookScheduleTrip({Key? key, this.toAddress, this.fromAddress})
      : super(key: key);

  @override
  State<BookScheduleTrip> createState() => BookScheduleTripState();
}

class BookScheduleTripState extends State<BookScheduleTrip> {
  LatLng? latlong = null;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  //String placeName = '';
  String? isoId;
  bool isverify = false;
  late vehiclePriceClassesModel SelectedVehicle;
  //String SelectedgoLiveDate = "";
  late DateTime mindatime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    mindatime = DateTime.now()
        .add(Duration(hours: AppConfig().getadvance_booking_time_limit()));
    print(AppConfig().getadvance_booking_time_limit());
    //SelectedgoLiveDate = tem.toString();
    _controller2.text = DateFormat('HH:mm').format(mindatime);
    _controller1.text = mindatime.toString();
  }

  final TextEditingController _controller1 =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _controller2 = TextEditingController(text: '');
  void getSelectvehicle(vehiclePriceClassesModel object) {
    SelectedVehicle = object;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        body: Stack( children: [
      MapDirectionWidget(
        fromAddress: widget.fromAddress,
        toAddress: widget.toAddress,
      ),
      AppBarInsideWidget(title: FutureBookingTitel),
      Positioned(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // start at end/bottom of column
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FromToWidget(
                fromAddress: widget.fromAddress,
                toAddress: widget.toAddress,
                distance: "5 Km",
                tripType: BookingTiming.later,
              ),
              CarCategoriesWidget(
                fromAddress: widget.fromAddress,
                toAddress: widget.toAddress,
                callback: getSelectvehicle,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  side: const BorderSide(
                    color: AppColor.border,
                  ),
                ),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'd MMM, yyyy',
                          controller: _controller1,
                          //initialValue: SelectedgoLiveDate,
                          firstDate: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              DateTime.now().hour),
                          lastDate: DateTime(2100),
                          icon: const Icon(Icons.event),
                          dateLabelText: pickupdate,
                          selectableDayPredicate: (date) {
                            if (date.weekday == 6 || date.weekday == 7) {
                              return false;
                            }
                            return true;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 55,
                        width: 1,
                        color: AppColor.border,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DateTimePicker(
                          type: DateTimePickerType.time,
                          dateMask: 'HH:mm',
                          controller: _controller2,
                          firstDate: DateTime(
                            DateTime.now().hour,
                            DateTime.now().minute,
                          ),

                          lastDate: DateTime(2100),
                          icon: const Icon(Icons.access_time),
                          timeLabelText: pickuptime,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  height: 40,
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      if(SelectedVehicle.type !=""){
                        DateTime dt = DateTime.parse(_controller1.text.toString());
                        print("${DateFormat('yyyy-MM-dd').format(dt)} ${_controller2.text.toString()}");
                        var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                        var inputDate = inputFormat.parse("${DateFormat('yyyy-MM-dd').format(dt)} ${_controller2.text.toString()}");
                        if((mindatime.difference(inputDate).inMinutes)<= 0){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>

                              _buildPopupDialog(context,DateFormat('d MMM, yyyy HH:mm').format(inputDate)),

                        );}else{
                          print("time not right ${mindatime.difference(inputDate).inMinutes}");
                          showToast("Please select a time slot, no earlier than ${DateFormat('d MMM, yyyy HH:mm').format(dt)} from now.");
                       }
                      }
                      else{

                      showToast("Please select car");
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.greyblack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: bookingConfirmation,
                      colorval: AppColor.white,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          ),

      ),
    ]));
  }

  Widget _buildPopupDialog(BuildContext context,String schedualTime) {

    return AlertDialog(
      content: Container(
          height: 555,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "You are booking",
                style: TextStyle(
                    color: AppColor.butgreen,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
                side: const BorderSide(
                  color: AppColor.border,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  children: [
                     robotoTextWidget(
                        textval: SelectedVehicle.type.toString(),
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w200),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/passengers-icon.png',
                                height: 15, width: 15, fit: BoxFit.cover),
                            const SizedBox(
                              width: 5,
                            ),
                             robotoTextWidget(
                                textval:
                                "${SelectedVehicle.passengerCapacity} People",
                                colorval: AppColor.black,
                                sizeval: 14,
                                fontWeight: FontWeight.w200)
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Image.asset('assets/images/weight-icon.png',
                                height: 15, width: 15, fit: BoxFit.cover),
                            const SizedBox(
                              width: 5,
                            ),
                             robotoTextWidget(
                                textval:
                                SelectedVehicle.bootSpace.toString(),
                                colorval: AppColor.black,
                                sizeval: 14,
                                fontWeight: FontWeight.w200)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Schedual At",
              style: TextStyle(
                  color: AppColor.butgreen,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            const SizedBox(
              height: 5,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
                side: const BorderSide(
                  color: AppColor.border,
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const robotoTextWidget(
                        textval: "Time",
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w200),
                    const SizedBox(
                      height: 5,
                    ),
                    robotoTextWidget(
                        textval: schedualTime.toString(),
                        colorval: AppColor.black,
                        sizeval: 12,
                        fontWeight: FontWeight.w200),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
                side: const BorderSide(
                  color: AppColor.border,
                ),
              ),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          robotoTextWidget(
                              textval: "₹${SelectedVehicle.total_fare.toString()}",
                              colorval: AppColor.black,
                              sizeval: 16,
                              fontWeight: FontWeight.w800),
                          robotoTextWidget(
                              textval: ApproxFare,
                              colorval: AppColor.black,
                              sizeval: 12,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 55,
                      width: 1,
                      color: AppColor.border,
                    ),
                    const SizedBox(width: 10),
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            robotoTextWidget(
                                textval:
                                    '${SelectedVehicle.distance} KM',
                                colorval: AppColor.black,
                                sizeval: 16,
                                fontWeight: FontWeight.w800),
                            const robotoTextWidget(
                                textval: "Pickup Distance",
                                colorval: AppColor.black,
                                sizeval: 12,
                                fontWeight: FontWeight.w400),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
             Text(
              Fromaddress,
              style: TextStyle(
                  color: AppColor.butgreen,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            const SizedBox(
              height: 5,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
                side: const BorderSide(
                  color: AppColor.border,
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     robotoTextWidget(
                        textval: placeName,
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w200),
                    const SizedBox(
                      height: 5,
                    ),
                    robotoTextWidget(
                        textval: widget.fromAddress!.address.toString(),
                        colorval: AppColor.black,
                        sizeval: 12,
                        fontWeight: FontWeight.w200),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(height: 10),
             Text(
              Toaddress,
              style: TextStyle(
                  color: AppColor.butgreen,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            const SizedBox(
              height: 5,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
                side: const BorderSide(
                  color: AppColor.border,
                ),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     robotoTextWidget(
                        textval: placeName,
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w200),
                    const SizedBox(
                      height: 5,
                    ),
                    robotoTextWidget(
                        textval: widget.toAddress!.address.toString(),
                        colorval: AppColor.black,
                        sizeval: 12,
                        fontWeight: FontWeight.w200),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 40,
                    width: 120,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: cancel,
                        colorval: AppColor.greyblack,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                Container(
                    height: 40,
                    width: 120,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                         confirmBooking();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: confirm,
                        colorval: AppColor.white,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            )
          ])),
    );
  }
  Future<void> confirmBooking() async {
    DateTime dt = DateTime.parse(_controller1.text.toString());
    print("${DateFormat('yyyy-MM-dd').format(dt)} ${_controller2.text.toString()}");
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse("${DateFormat('yyyy-MM-dd').format(dt)} ${_controller2.text.toString()}"); // <-- dd/MM 24H format
print(inputDate);
    var outputFormat =  DateFormat("yyyy-MM-ddTHH:mm:ss");
    var outputDate = outputFormat.format(inputDate);
print(outputDate);
    final response = await ApiCollection.AddnewSchedualeTrip(
        widget.fromAddress,
        widget.toAddress,
      outputDate,
        SelectedVehicle.total_fare,
        SelectedVehicle.distance,
       );

    if (response != null) {
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {

    Navigator.of(context)
        .pushAndRemoveUntil(
    MaterialPageRoute(
    builder: (BuildContext context) =>
    HomePage(title: "",)),
    (Route<dynamic> route) => true);

      }
      showToast((jsonDecode(response.body)['msg'].toString()));
    }
  }
}
//https://rrtutors.com/tutorials/Show-Current-Location-On-Maps-Flutter-Fetch-Current-Location-Address
//https://stackoverflow.com/questions/52591556/custom-markers-with-flutter-google-maps-plugin
