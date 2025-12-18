import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mashrou3/app/navigation/route_arguments.dart';
import 'package:mashrou3/app/navigation/routes.dart';
import 'package:mashrou3/app/ui/custom_widget/app_bar_mixin.dart';
import 'package:mashrou3/app/ui/screens/finance_request/component/finance_request_card.dart';
import 'package:mashrou3/app/ui/screens/finance_request/cubit/finance_request_cubit.dart';
import 'package:mashrou3/app/ui/screens/finance_request/model/finance_request_list_response.dart';
import 'package:mashrou3/config/resources/app_values.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';
import 'package:mashrou3/utils/extensions.dart';
import 'package:mashrou3/utils/ui_components.dart';

class FinanceRequestScreen extends StatefulWidget {
  const FinanceRequestScreen({super.key});

  @override
  State<FinanceRequestScreen> createState() => _FinanceRequestScreenState();
}

class _FinanceRequestScreenState extends State<FinanceRequestScreen> with AppBarMixin {
  final PagingController<int, FinanceRequest> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (context.mounted) {
        FinanceRequestCubit cubit = context.read<FinanceRequestCubit>();
        _pagingController.addPageRequestListener((pageKey) {
          cubit.getList(pageKey: pageKey);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FinanceRequestCubit cubit = context.read<FinanceRequestCubit>();
    return BlocConsumer<FinanceRequestCubit, FinanceRequestState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
              appBar: buildAppBar(
                context: context,
                requireLeading: true,
                title: appStrings(context).financeRequest,
              ),
              // body:
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: _buildLazyLoadList(
                    cubit,
                  ))
                ],
              ));
        });
  }

  /// pagination list
  Widget _buildLazyLoadList(FinanceRequestCubit cubit) {
    return PagedListView<int, FinanceRequest>.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      separatorBuilder: (BuildContext context, int index) {
        return 12.verticalSpace;
      },
      pagingController: _pagingController,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<FinanceRequest>(
        firstPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: UIComponent.getBankListSkeleton(),
          );
        },
        itemBuilder: (context, item, index) {
          return FinanceRequestCard(
            data: item,
            onDetailTap: () {
              cubit.isVendor
                  ? context.pushNamed(Routes.kFinanceRequestDetailsScreen, pathParameters: {RouteArguments.requestId: item.sId ?? "0"})
                  : item.financeType == "vendor"
                      ? context.pushNamed(Routes.kVendorDetailScreen,
                          extra: item.vendorId ?? "", queryParameters: {RouteArguments.isFromFinanceReq: "true"})
                      : context.pushNamed(Routes.kPropertyDetailScreen, pathParameters: {
                          RouteArguments.propertyId: item.propertyId?.sId ?? "0",
                          RouteArguments.propertyLat: (0.00).toString(),
                          RouteArguments.propertyLng: (0.00).toString(),
                        }).then((value) {
                          if (value != null && value == true) {}
                        });
            },
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return SizedBox(
            height: AppValues.screenHeight * 0.8,
            child: Center(
              child: UIComponent.noDataWidgetWithInfo(
                title: appStrings(context).emptyFinanceRequestsList,
                info: appStrings(context).emptyFinanceRequestsListInfo,
                context: context,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build bloc listener widget.
  Future<void> buildBlocListener(BuildContext context, FinanceRequestState state) async {
    if (state is FinanceRequestListSuccess) {
      if (state.isLastPage) {
        _pagingController.appendLastPage(state.financeRequestList);
      } else {
        _pagingController.appendPage(state.financeRequestList, state.currentKey + 1);
      }
    }
    if (state is NoFinanceRequestListFoundState) {
      _pagingController.appendLastPage([]);
    }
    if (state is FinanceRequestListRefresh) {
      _pagingController.refresh();
    } else if (state is FinanceRequestListError) {
      _pagingController.appendLastPage([]);
      Utils.showErrorMessage(
          context: context,
          message: state.errorMessage.contains('No internet') ? appStrings(context).noInternetConnection : state.errorMessage);
    }
  }
}
