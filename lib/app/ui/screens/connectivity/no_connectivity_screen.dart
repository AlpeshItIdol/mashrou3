import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/navigation/app_router.dart';
import 'package:mashrou3/utils/app_localization.dart';

class NoConnectivityScreen extends StatelessWidget {
  const NoConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: (){
          context.pop();
          context.pop();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.signal_wifi_off, size: 100),
              const SizedBox(height: 20),
              Text(
                appStrings(context).lblSelectVendor,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
