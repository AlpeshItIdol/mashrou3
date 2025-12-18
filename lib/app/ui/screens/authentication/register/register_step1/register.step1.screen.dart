import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/authentication/component/stacked_image_widget.dart';
import 'package:mashrou3/utils/extensions.dart';

import '../../../../../../config/resources/app_assets.dart';
import '../../../../../../config/resources/app_strings.dart';
import '../../../../../../config/utils.dart';
import '../../../../../../utils/app_localization.dart';
import '../../../../../navigation/routes.dart';
import 'cubit/register_step1_cubit.dart';

class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen>
    with AppBarMixin {
  @override
  void initState() {
    context.read<RegisterStep1Cubit>().getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RegisterStep1Cubit cubit = context.read<RegisterStep1Cubit>();
    return BlocConsumer<RegisterStep1Cubit, RegisterStep1State>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            appBar: buildAppBar(context: context, appBarHeight: 58),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                appStrings(context).lblStartYourJourneyAs,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              2.verticalSpace,
                              Text(
                                appStrings(context).textHowDoYouWantToSignUp ??
                                    "",
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        12.verticalSpace,

                        /// Visitor widget
                        ///
                        VisitorOwnerWidget(
                          title: appStrings(context).textVisitor,
                          subTitle:
                              appStrings(context).textVisitorDetails,
                          image: AppAssets.visitorImg ?? "",
                          isRightSide:
                              TextDirection.rtl == Directionality.of(context)
                                  ? true
                                  : false,
                          onTap: () async {
                            await cubit.appPreferences
                                .setUserRole(AppStrings.visitor);
                            context.pushNamed(Routes.kRegisterStep2Screen);
                          },
                        ),
                        12.verticalSpace,

                        /// Vendor widget
                        ///

                        VisitorOwnerWidget(
                          isRightSide:
                              TextDirection.rtl == Directionality.of(context)
                                  ? false
                                  : true,
                          title: appStrings(context).textVendor,
                          subTitle:
                              appStrings(context).textVendorDetails,
                          image: AppAssets.vendorImg,
                          onTap: () async {
                            await cubit.appPreferences
                                .setUserRole(AppStrings.vendor);
                            // context.pushNamed(Routes.kCompleteProfileScreen);
                            context.pushNamed(Routes.kRegisterStep2Screen);
                          },
                        ),
                        12.verticalSpace,

                        /// Real Estate Owner field
                        ///

                        VisitorOwnerWidget(
                          title: appStrings(context).textRealEstateOwner,
                          subTitle:
                              appStrings(context).textRealEstateOwnerDetails,
                          image: AppAssets.ownerImg,
                          isRightSide:
                              TextDirection.rtl == Directionality.of(context)
                                  ? true
                                  : false,
                          onTap: () async {
                            await cubit.appPreferences
                                .setUserRole(AppStrings.owner);
                            // context.pushNamed(Routes.kCompleteProfileScreen);
                            context.pushNamed(Routes.kRegisterStep2Screen);
                          },
                        ),
                        12.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Build bloc listener widget.
  void buildBlocListener(BuildContext context, RegisterStep1State state) {
    if (state is RegisterStep1Loading) {
      // OverlayLoadingProgress.start(context);
    } else if (state is RegisterStep1Success) {
    } else if (state is RegisterStep1Error) {
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet')
              ? appStrings(context).noInternetConnection
              : state.errorMessage);
    }
  }
}
