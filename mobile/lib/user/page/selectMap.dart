import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectMapLocate extends StatefulWidget {
  const SelectMapLocate({super.key});

  @override
  State<SelectMapLocate> createState() => _SelectMapLocateState();
}

class _SelectMapLocateState extends State<SelectMapLocate> {
  final String apiKey = 'AIzaSyAsMbXKCUZGZTVfBpYNtu2k6lvbTm5PhFU';
  Prediction? _selectedPrediction;
  List place = [];
  String placeName = '';
  String address = '';
  double lat = 0;
  double lng = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GooglePlaceAutoCompleteTextField(
                textEditingController: TextEditingController(),
                googleAPIKey: apiKey,
                inputDecoration: InputDecoration(
                  hintText: 'Search for a place',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                debounceTime: 800,
                countries: ['TH'], // Restrict to Thailand
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  setState(() {
                    _selectedPrediction = prediction;
                  });
                },
                itemClick: (Prediction prediction) {
                  setState(() {
                    _selectedPrediction = prediction;
                  });
                },
              ),
              SizedBox(height: 16),
              if (_selectedPrediction != null)
                FutureBuilder<Map<String, dynamic>>(
                  future: _getPlaceDetails(_selectedPrediction!.placeId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final placeDetails = snapshot.data!;
                      _updateGlobalData(placeDetails);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Place Name: ${placeDetails['name']}'),
                          Text('Address: ${placeDetails['formatted_address']}'),
                          Text(
                              'Latitude: ${placeDetails['geometry']['location']['lat']}'),
                          Text(
                              'Longitude: ${placeDetails['geometry']['location']['lng']}'),
                        ],
                      );
                    } else {
                      return Text('No details available');
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _getPlaceDetails(String placeId) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      throw Exception('Failed to load place details');
    }
  }

  void _updateGlobalData(Map<String, dynamic> placeDetails) {
    placeName = placeDetails['name'];
    address = placeDetails['formatted_address'];
    lat = placeDetails['geometry']['location']['lat'];
    lng = placeDetails['geometry']['location']['lng'];
    print(placeName);
    print(address);
    print(lat);
    print(lng);
  }
}
