import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/utils/app_localization.dart';

class HtmlViewer extends StatefulWidget {
  const HtmlViewer({super.key, required this.htmlData});

  final String htmlData;

  @override
  State<HtmlViewer> createState() => _HtmlViewerState();
}

class _HtmlViewerState extends State<HtmlViewer> with AppBarMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        title: appStrings(context).termsAndConditions,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: HtmlWidget(widget.htmlData),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
