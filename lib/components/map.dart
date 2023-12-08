import 'dart:async';
import 'package:christmas/components/santas_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as map;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class AnimatedMapControllerPage extends StatefulWidget {
  static const String route = '/map_controller_animated';

  const AnimatedMapControllerPage({super.key});

  @override
  AnimatedMapControllerPageState createState() =>
      AnimatedMapControllerPageState();
}

class AnimatedMapControllerPageState extends State<AnimatedMapControllerPage>
    with TickerProviderStateMixin {
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  var _santa = SantaTracker().calculateSantaLocation();
  var _markers = SantaTracker().getAllMarkers();
  List<map.Marker> tappedMarker = [];
  var currentStop = SantaTracker().getLocationNames().$1;
  var nextStop = SantaTracker().getLocationNames().$2;
  var presentsDelivered = SantaTracker().getLocationNames().$3;
  bool trackingOn = false;

  final mapController = map.MapController();

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void checkStantaLocation() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          if (mapController.camera.center != _santa) {
            trackingOn = false;
          }
          _santa = SantaTracker().calculateSantaLocation();
          _markers = SantaTracker().getAllMarkers();
          currentStop = SantaTracker().getLocationNames().$1;
          nextStop = SantaTracker().getLocationNames().$2;
          presentsDelivered = SantaTracker().getLocationNames().$3;

          if (trackingOn) {
            mapController.move(_santa, mapController.camera.zoom);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Call the repeatFunction when the page opens
    checkStantaLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Stack(children: [
              map.FlutterMap(
                mapController: mapController,
                options: map.MapOptions(
                    initialCenter: _santa,
                    initialZoom: 2,
                    maxZoom: 10,
                    minZoom: 2,
                    backgroundColor: Color.fromARGB(255, 172, 212, 220),
                    onTap: (tapPos, position) async {
                      // Reverse geocoding
                      // Clear previous markers
                      tappedMarker.clear();
                      var etaInfo = SantaTracker().getEtaOfLocation(position);
                      // Add a new marker with location info
                      tappedMarker.add(map.Marker(
                        width: 180,
                        height: 150,
                        point: position,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              //color: Colors.white,
                              child: Text(
                                etaInfo,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Lottie.asset(
                              'assets/snowman.json',
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ));

                      // Update the UI
                      setState(() {});
                    },
                    interactiveFlags: map.InteractiveFlag.pinchZoom |
                        map.InteractiveFlag.drag),
                children: [
                  map.TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    tileUpdateTransformer: _animatedMoveTileUpdateTransformer,
                  ),
                  map.MarkerLayer(markers: _markers + tappedMarker),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Current Stop: $currentStop",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          backgroundColor: Color.fromARGB(255, 247, 247, 247)),
                    ),
                    Text("Next Stop: $nextStop",
                        style: const TextStyle(
                            fontSize: 14,
                            backgroundColor:
                                Color.fromARGB(255, 247, 247, 247))),
                    Text(
                        "Presents Delivered: ${NumberFormat('#,##0').format(presentsDelivered * 1420357)}",
                        style: const TextStyle(
                            fontSize: 14,
                            backgroundColor:
                                Color.fromARGB(255, 247, 247, 247))),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: 55,
                    height: 55,
                    child: TextButton(
                      onPressed: () {
                        mapController.move(mapController.camera.center,
                            mapController.camera.zoom * 1.1);
                      },
                      child: const Icon(
                        Icons.zoom_in_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: 55,
                    height: 55,
                    child: TextButton(
                      onPressed: () {
                        mapController.move(mapController.camera.center,
                            mapController.camera.zoom * 0.9);
                      },
                      child: const Icon(
                        Icons.zoom_out_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    width: 55,
                    height: 55,
                    child: MaterialButton(
                      onPressed: () {
                        _animatedMapMove(_santa, 5);
                        setState(() {
                          trackingOn = true;
                        });
                      },
                      child: Lottie.asset(
                        'assets/santasleigh.json',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        animate: false,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: 55,
                    height: 55,
                    child: TextButton(
                      onPressed: () {
                        _animatedMapMove(const LatLng(30, 0.0), 2);
                        setState(() {
                          trackingOn = false;
                        });
                      },
                      child: const Icon(Icons.zoom_out_map, color: Colors.red),
                    ),
                  )
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

/// Causes tiles to be prefetched at the target location and disables pruning
/// whilst animating movement. When proper animated movement is added (see
/// #1263) we should just detect the appropriate AnimatedMove events and
/// use their target zoom/center.
final _animatedMoveTileUpdateTransformer =
    map.TileUpdateTransformer.fromHandlers(handleData: (updateEvent, sink) {
  final mapEvent = updateEvent.mapEvent;

  final id = mapEvent is map.MapEventMove ? mapEvent.id : null;
  if (id?.startsWith(AnimatedMapControllerPageState._startedId) ?? false) {
    final parts = id!.split('#')[2].split(',');
    final lat = double.parse(parts[0]);
    final lon = double.parse(parts[1]);
    final zoom = double.parse(parts[2]);

    // When animated movement starts load tiles at the target location and do
    // not prune. Disabling pruning means existing tiles will remain visible
    // whilst animating.
    sink.add(
      updateEvent.loadOnly(
        loadCenterOverride: LatLng(lat, lon),
        loadZoomOverride: zoom,
      ),
    );
  } else if (id == AnimatedMapControllerPageState._inProgressId) {
    // Do not prune or load whilst animating so that any existing tiles remain
    // visible. A smarter implementation may start pruning once we are close to
    // the target zoom/location.
  } else if (id == AnimatedMapControllerPageState._finishedId) {
    // We already prefetched the tiles when animation started so just prune.
    sink.add(updateEvent.pruneOnly());
  } else {
    sink.add(updateEvent);
  }
});
