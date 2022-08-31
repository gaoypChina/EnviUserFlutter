import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../theme/theme.dart';

class DriverDetailWidget extends StatefulWidget {
  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _DriverDetailWidgetState();
}

class _DriverDetailWidgetState extends State<DriverDetailWidget> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      
      margin: EdgeInsets.all(10),
      height: 170,
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      print("Tapped a Container");
                    },
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network("https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
                              fit: BoxFit.fill,height: 46,
                              width: 46,)
                          ),
                          const SizedBox(
                            width: 10,
                          ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                robotoTextWidget(
                  textval: "Anamika Chavan",
                  colorval: AppColor.grey,
                  sizeval: 16,
                  fontWeight: FontWeight.w200,
                ),
                robotoTextWidget(
                  textval: "7 Minutes Away",
                  colorval: AppColor.black,
                  sizeval: 18,
                  fontWeight: FontWeight.w200,
                ),
              ])

                        ],
                      ),
                    )),
                Stack(alignment: Alignment.centerRight, children: <Widget>[
                  const SizedBox(
                    height: 2,
                    child: Divider(
                      color: AppColor.grey,
                      height: 2,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,

                    decoration: BoxDecoration(
                      color: AppColor.lightwhite,
                      border: Border.all(
                          color: AppColor.grey, // Set border color
                          width: 1.0), // Set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // Set rounded corner radius
                    ),
                    child:  MaterialButton(
                      minWidth: 20,
                      height: 20,
                      onPressed: () {
                       // _launchPhoneURL(tripData.customer.phone.toString());
                      },
                      child: const Icon(
                        Icons.call_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ]),
                GestureDetector(
                    onTap: () {
                      print("Tapped a Container");
                    },
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/car-type-sedan.svg",
                            width: 52,
                            height: 24,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                robotoTextWidget(
                                  textval: "Hatchback – 3 People",
                                  colorval: AppColor.grey,
                                  sizeval: 16,
                                  fontWeight: FontWeight.w200,
                                ),
                                robotoTextWidget(
                                  textval: "KA04 AB 3545",
                                  colorval: AppColor.black,
                                  sizeval: 18,
                                  fontWeight: FontWeight.w200,
                                ),
                              ])
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}