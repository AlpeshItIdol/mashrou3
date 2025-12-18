import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:go_router/go_router.dart';
import 'package:mashrou3/app/ui/screens/vendors/sub_screens/vendor_list_tile_item.dart';
import 'package:mashrou3/utils/extensions.dart';
import '../../../../config/resources/app_assets.dart';
import '../../../../config/resources/app_colors.dart';
import '../../../../utils/ui_components.dart';
import '../../../navigation/routes.dart';
import '../../custom_widget/toggle_widget/toggle_cubit.dart';
import '../../custom_widget/toggle_widget/toggle_row_item.dart';
import '../../screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'cubit/vendors_list_cubit.dart';
import 'model/vendors_sequence_response.dart';

class VendorsListScreen extends StatefulWidget {
  const VendorsListScreen({super.key});

  @override
  State<VendorsListScreen> createState() => _VendorsListState();
}

class _VendorsListState extends State<VendorsListScreen> {
  final TextEditingController _controller = TextEditingController();
  final PagingController<int, VendorSequenceUser> _pagingController = PagingController(firstPageKey: 1);
  late ToggleCubit _toggleCubit;

  @override
  void initState() {
    super.initState();
    _toggleCubit = ToggleCubit([], vendorItems: [], defaultIndex: 0);
    
    // Reset to "All" category when screen loads
    final vendorsCubit = context.read<VendorsListCubit>();
    vendorsCubit.resetToAllCategories();
    
    _pagingController.addPageRequestListener((pageKey) {
      context.read<VendorsListCubit>().fetchPage(page: pageKey);
    });
    
    // Fetch vendor categories
    vendorsCubit.fetchVendorCategories();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _controller.dispose();
    _toggleCubit.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        children: [
          Padding(
            padding:
            const EdgeInsetsDirectional.only(end: 12.0),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.greyE8.adaptiveColor(
                    context,
                    lightModeColor: AppColors.greyE8,
                    darkModeColor: AppColors.black2E,
                  ),
                  width: 1,
                ),
              ),
              child: UIComponent.customInkWellWidget(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                child: Center(
                  child: SvgPicture.asset(
                    TextDirection.rtl == Directionality.of(context)
                        ? SVGAssets.arrowRightIcon
                        : SVGAssets.arrowLeftIcon,
                    height: 26,
                    width: 26,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).focusColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Text('Vendor Detail'),
        ],
      ),
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [
          // Horizontal scrollable vendor categories
          BlocBuilder<VendorsListCubit, VendorsListState>(
            buildWhen: (previous, current) {
              // Only rebuild when category-related states change
              return current is VendorCategoriesLoading ||
                     current is VendorCategoriesSuccess ||
                     current is VendorCategoriesEmpty ||
                     current is VendorCategoriesError;
            },
            builder: (context, state) {
              final cubit = context.read<VendorsListCubit>();
              
              if (state is VendorCategoriesSuccess) {
                // Update toggle cubit with categories
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Always start with "All" selected (index 0)
                  _toggleCubit.updateVendorCategories(state.categories, cubit.selectedCategoryIndex);
                });
                
                return Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: BlocBuilder<ToggleCubit, int>(
                    bloc: _toggleCubit,
                    builder: (context, selectedIndex) {
                      return ToggleRowItem(
                        cubit: _toggleCubit,
                        isForVendor: true,
                        hasMorePages: state.hasMorePages,
                        onLoadMore: () {
                          cubit.loadMoreCategories();
                        },
                        onCategorySelected: (index) {
                          // index -1 means "All" was selected
                          if (index == -1) {
                            cubit.selectCategory(null, index: 0);
                            _pagingController.refresh();
                          } else if (index >= 0 && index < cubit.allCategories.length) {
                            // Get the selected category
                            final categoryId = cubit.allCategories[index].sId;
                            cubit.selectCategory(categoryId, index: index + 1);
                            // Refresh vendor list with new category
                            _pagingController.refresh();
                          }
                        },
                      );
                    },
                  ),
                );
              } else if (state is VendorCategoriesLoading) {
                return Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (state is VendorCategoriesError) {
                return Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: Text(state.errorMessage)),
                );
              } else if (cubit.categoriesLoaded && cubit.allCategories.isNotEmpty) {
                // Show last known categories if state is not category-related
                return Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: BlocBuilder<ToggleCubit, int>(
                    bloc: _toggleCubit,
                    builder: (context, selectedIndex) {
                      return ToggleRowItem(
                        cubit: _toggleCubit,
                        isForVendor: true,
                        hasMorePages: cubit.currentCategoryPage < cubit.totalCategoryPages,
                        onLoadMore: () {
                          cubit.loadMoreCategories();
                        },
                        onCategorySelected: (index) {
                          // index -1 means "All" was selected
                          if (index == -1) {
                            cubit.selectCategory(null, index: 0);
                            _pagingController.refresh();
                          } else if (index >= 0 && index < cubit.allCategories.length) {
                            // Get the selected category
                            final categoryId = cubit.allCategories[index].sId;
                            cubit.selectCategory(categoryId, index: index + 1);
                            // Refresh vendor list with new category
                            _pagingController.refresh();
                          }
                        },
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocConsumer<VendorsListCubit, VendorsListState>(
              listener: (context, state) {
                if (state is VendorsListSuccess) {
                  if (state.isLastPage) {
                    // _pagingController.appendLastPage(state.vendors);
                    _pagingController.appendLastPage(state.vendors);
                  } else {
                    _pagingController.appendPage(state.vendors, state.currentKey + 1);
                  }
                }
                if (state is VendorsListEmpty) {
                  _pagingController.appendLastPage([]);
                }
                if (state is VendorsListError) {
                  _pagingController.error = state.errorMessage;
                }
              },
              builder: (context, state) {
                return PagedListView.separated(
                  pagingController: _pagingController,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  builderDelegate: PagedChildBuilderDelegate<VendorSequenceUser>(
                  // builderDelegate: PagedChildBuilderDelegate<VendorUserData>(
                    itemBuilder: (context, item, index) {
                      debugPrint(item.lastName.toString());
                      return VendorListTileItem(
                        data: VendorCategoryData(title: item.companyName, description: item.companyDescription, vendorLogo: item.companyLogo),
                        // data: VendorCategoryData(title: item.companyName, description: item.companyDesc, vendorLogo: item.companyLogo),
                        userData: item,
                        isForCategory: true,
                        onItemTap: () {
                          debugPrint("data");
                          // context.pushNamed(Routes.kDrawerVendorDetail);
                          context.pushNamed(
                            Routes.kDrawerVendorDetail,
                            extra: item,
                          );
                        },
                      );
                    },
                    noItemsFoundIndicatorBuilder: (_) => const Center(child: Text('No vendors found')),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
