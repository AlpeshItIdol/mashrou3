import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:mashrou3/config/resources/app_values.dart';

class GoogleMapCardWidget extends StatefulWidget {
  final LatLng locationLatLng;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const GoogleMapCardWidget({
    super.key,
    required this.locationLatLng,
    required this.buttonText,
    this.onButtonPressed,
  });

  @override
  State<GoogleMapCardWidget> createState() => _GoogleMapCardWidgetState();
}

class _GoogleMapCardWidgetState extends State<GoogleMapCardWidget> {
  BitmapDescriptor? customIcon;

  @override
  void initState() {
    _setCustomMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Map
          SizedBox(
            height: AppValues.screenHeight / 3,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.locationLatLng,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: widget.locationLatLng,
                  icon: customIcon ??
                      BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure,
                      ),
                ),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.white.withOpacity(0.7),
              height: 60,
              child: Center(
                child: TextButton(
                  onPressed: widget.onButtonPressed,
                  child: Text(
                    widget.buttonText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.colorPrimary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setCustomMarker() async {
    customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(36, 36)),
      'assets/icons/ic_location_pin_icon.png',
    );
    setState(() {});
  }
}
