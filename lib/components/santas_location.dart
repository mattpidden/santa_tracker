import 'package:christmas/components/location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';

class SantaTracker {
  // List of coordinates for major countries
  static const _santasGroto = LatLng(80.95, 5.71);
  // Calculate Santa's location based on the current time
  LatLng calculateSantaLocation() {
    DateTime currentUtcTime = DateTime.now().toUtc();
    // The start and finish times for santa deliver in UTC
    DateTime santaStart = DateTime(currentUtcTime.year, 12, 24, 12, 0, 0);
    DateTime santaFinish = DateTime(currentUtcTime.year, 12, 25, 12, 0, 0);

    // Check if current time is within Santa's delivery window
    if (currentUtcTime.isBefore(santaStart) ||
        currentUtcTime.isAfter(santaFinish)) {
      return const LatLng(80.95,
          5.71); // Santa is not delivering gifts right now - he is at his grotto
    }

    // Calculate total time Santa has for delivering gifts in seconds
    int totalSeconds = santaFinish.difference(santaStart).inSeconds;

    // Calculate elapsed time since Santa started delivering gifts in seconds
    int elapsedSeconds = currentUtcTime.difference(santaStart).inSeconds;

    // Calculate the index of the stop Santa should be at
    int numberOfStops = countryCoordinates.length;
    int stopIndex =
        (elapsedSeconds % totalSeconds) ~/ (totalSeconds / numberOfStops);

    // Get the LatLng for the corresponding stop
    String stopName = countryCoordinates.keys.toList()[stopIndex];
    LatLng santaLocation = countryCoordinates[stopName]!;

    return santaLocation;
  }

  (String, String) getLocationNames() {
    DateTime currentUtcTime = DateTime.now().toUtc();
    // The start and finish times for santa deliver in UTC
    DateTime santaStart = DateTime(currentUtcTime.year, 12, 24, 12, 0, 0);
    DateTime santaFinish = DateTime(currentUtcTime.year, 12, 25, 12, 0, 0);

    if (currentUtcTime.isBefore(santaStart)) {
      Duration timeUntilSanta = santaStart.difference(currentUtcTime);

      if (timeUntilSanta.inDays > 1) {
        // More than 1 day away
        return (
          "North Pole",
          "Santa is leaving in ${timeUntilSanta.inDays} days"
        );
      } else if (timeUntilSanta.inHours > 1) {
        // Less than 1 day but more than 1 hour away
        return (
          "North Pole",
          "Santa is leaving in ${timeUntilSanta.inHours} hours"
        );
      } else {
        // Less than 1 hour away
        return (
          "North Pole",
          "Santa is leaving in ${timeUntilSanta.inMinutes} minutes"
        );
      }
    } else if (currentUtcTime.isAfter(santaFinish)) {
      return ("North Pole", "Santa is resting after a busy Christmas");
    }

    // Calculate total time Santa has for delivering gifts in seconds
    int totalSeconds = santaFinish.difference(santaStart).inSeconds;

    // Calculate elapsed time since Santa started delivering gifts in seconds
    int elapsedSeconds = currentUtcTime.difference(santaStart).inSeconds;

    // Calculate the index of the stop Santa should be at
    int numberOfStops = countryCoordinates.length;
    int stopIndex =
        (elapsedSeconds % totalSeconds) ~/ (totalSeconds / numberOfStops);

    // Get the LatLng for the corresponding stop
    String currentStopName = countryCoordinates.keys.toList()[stopIndex];
    String nextStopName = "North Pole";
    if (stopIndex < countryCoordinates.length) {
      nextStopName = countryCoordinates.keys.toList()[stopIndex + 1];
    }
    return (currentStopName, nextStopName);
  }

  List<map.Marker> getAllMarkers() {
    LatLng santaLocation;
    DateTime currentUtcTime = DateTime.now().toUtc();
    // The start and finish times for santa deliver in UTC
    DateTime santaStart = DateTime(currentUtcTime.year, 12, 24, 12, 0, 0);
    DateTime santaFinish = DateTime(currentUtcTime.year, 12, 25, 12, 0, 0);
    // Assuming you have an assets/tree.json file for the Lottie animation
    final Widget visitedWidget = Lottie.asset('assets/present.json',
        width: 15, height: 15, fit: BoxFit.cover, animate: false);

    // Check if current time is within Santa's delivery window otherwise just return grotto with santa at it
    if (currentUtcTime.isBefore(santaStart)) {
      return [
        map.Marker(
          width: 100,
          height: 100,
          point: const LatLng(80.95, 5.71),
          child: Lottie.asset(
            'assets/santasleigh.json',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        map.Marker(
          width: 100,
          height: 100,
          point: _santasGroto,
          child: Lottie.asset(
            'assets/tree.json',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        )
      ];
    }

    if (currentUtcTime.isAfter(santaFinish)) {
      var allMarkers = [
        map.Marker(
          width: 100,
          height: 100,
          point: const LatLng(80.95, 5.71),
          child: Lottie.asset(
            'assets/santasleigh.json',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        map.Marker(
          width: 100,
          height: 100,
          point: _santasGroto,
          child: Lottie.asset(
            'assets/tree.json',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        )
      ];
      for (int i = 0; i <= countryCoordinates.length - 1; i = i + 40) {
        LatLng location = countryCoordinates.values.toList()[i];
        allMarkers.add(
          map.Marker(
            width: 15,
            height: 15,
            point: location,
            child: visitedWidget,
          ),
        );
      }
      return allMarkers;
    } else {
      // Calculate total time Santa has for delivering gifts in seconds
      int totalSeconds = santaFinish.difference(santaStart).inSeconds;

      // Calculate elapsed time since Santa started delivering gifts in seconds
      int elapsedSeconds = currentUtcTime.difference(santaStart).inSeconds;

      // Calculate the index of the stop Santa should be at
      int numberOfStops = countryCoordinates.length;
      int stopIndex =
          (elapsedSeconds % totalSeconds) ~/ (totalSeconds / numberOfStops);

      // Get the LatLng for the corresponding stop
      String stopName = countryCoordinates.keys.toList()[stopIndex];
      santaLocation = countryCoordinates[stopName]!;

      var allMarkers = [
        map.Marker(
          width: 100,
          height: 100,
          point: santaLocation,
          child: Lottie.asset(
            'assets/santasleigh.json',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        map.Marker(
          width: 100,
          height: 100,
          point: _santasGroto,
          child: Lottie.asset(
            'assets/tree.json',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        )
      ];

      for (int i = stopIndex - 20; i <= stopIndex; i++) {
        LatLng location = countryCoordinates.values.toList()[i];
        allMarkers.add(
          map.Marker(
            width: 15,
            height: 15,
            point: location,
            child: visitedWidget,
          ),
        );
      }
      for (int i = 0; i <= stopIndex - 20; i = i + 45) {
        LatLng location = countryCoordinates.values.toList()[i];
        allMarkers.add(
          map.Marker(
            width: 15,
            height: 15,
            point: location,
            child: visitedWidget,
          ),
        );
      }

      return allMarkers;
    }
  }
}
