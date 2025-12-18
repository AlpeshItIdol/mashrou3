import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:mashrou3/config/resources/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'app_bar_mixin.dart';

class CarouselFullScreen extends StatelessWidget with AppBarMixin {
  final List<String>? imageList;
  final String index;

  CarouselFullScreen({super.key, required this.imageList, required this.index});

  @override
  Widget build(BuildContext context) {
    int sliderIndex = int.parse(index);

    // Prepare EasyImageProvider for multiple images
    MultiImageProvider multiImageProvider = MultiImageProvider(
      imageList!.map((url) => NetworkImage(url)).toList(),
    );

    return Scaffold(
      appBar: buildAppBar(
        context: context,
        requireLeading: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Using photo_view package
          ///
          Expanded(
              child: PhotoViewGallery.builder(
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageList![index]),
                maxScale: PhotoViewComputedScale.covered * 2.0,
                minScale: PhotoViewComputedScale.contained,
                initialScale: PhotoViewComputedScale.contained,
              );
            },
            itemCount: imageList!.length,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.colorPrimary,
              ),
            ),
            pageController: PageController(initialPage: sliderIndex),
            // onPageChanged: onPageChanged,
          ))

          /// TODO: Using InteractiveViewer and easy_image_viewer package
          ///
          // Expanded(
          //   child: GestureDetector(
          //     onTap: () {
          //       // Show full-screen viewer on tap
          //       showImageViewerPager(
          //         context,
          //         multiImageProvider,
          //         swipeDismissible: true,
          //         doubleTapZoomable: true,
          //       );
          //     },
          //     child: PageView.builder(
          //       controller: PageController(initialPage: sliderIndex),
          //       itemCount: imageList!.length,
          //       itemBuilder: (context, pageIndex) {
          //         return Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: InteractiveViewer(
          //             panEnabled: true,
          //             scaleEnabled: true,
          //             minScale: 1.0,
          //             maxScale: 4.0,
          //             child: CachedNetworkImage(
          //               placeholder: (context, url) => SvgPicture.asset(
          //                 SVGAssets.propertyPlaceholder,
          //                 fit: BoxFit.contain,
          //               ),
          //               fit: BoxFit.contain,
          //               // Maintain aspect ratio of the image
          //               imageUrl: imageList![pageIndex],
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

/// TODO: Old working code example
///

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:easy_image_viewer/easy_image_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
// import 'package:mashrou3/app/ui/custom_widget/pinch_zoom.dart';
// import 'package:mashrou3/config/resources/app_assets.dart';
// import 'package:mashrou3/config/resources/app_values.dart';
//
// class CarouselFullScreen extends StatelessWidget with AppBarMixin {
//   final List<String>? imageList;
//   final String index;
//
//   CarouselFullScreen({super.key, required this.imageList, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     int sliderIndex = int.parse(index);
//     return Scaffold(
//       body: Column(
//         children: [
//           buildAppBar(context: context, requireLeading: true),
//           Expanded(
//             // Use Expanded to make CarouselSlider fill remaining space
//             child: CarouselSlider.builder(
//               options: CarouselOptions(
//                 height: AppValues.screenHeight,
//                 // Not strictly necessary with Expanded
//                 initialPage: sliderIndex,
//                 viewportFraction: 1.0,
//                 enlargeCenterPage: false,
//               ),
//               itemCount: imageList!.length,
//               itemBuilder: (BuildContext context, int index, int realIndex) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 68),
//                     child: PinchZoom(
//                       maxScale: 2.5,
//                       child: CachedNetworkImage(
//                         placeholder: (context, url) => SvgPicture.asset(
//                           SVGAssets.propertyPlaceholder,
//                           fit: BoxFit.contain,
//                         ),
//                         fit: BoxFit.contain,
//                         // Maintain aspect ratio of the image
//                         imageUrl: imageList![index],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
