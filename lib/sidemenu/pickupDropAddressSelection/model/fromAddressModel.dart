
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class FromAddressLatLong {

FromAddressLatLong({
  required this.address,
   this.position,
});
  String address;
  LatLng? position;
  
}

