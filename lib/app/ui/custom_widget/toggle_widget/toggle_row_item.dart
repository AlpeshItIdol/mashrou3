import 'package:flutter/material.dart';
import 'package:mashrou3/app/ui/custom_widget/toggle_widget/toggle_cubit.dart';
import 'package:mashrou3/app/ui/screens/property_details/sub_screens/vendor_finance/model/vendor_category_list_response.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';

import '../../../../config/resources/app_colors.dart';
import '../../../model/property/property_category_response_model.dart';

class ToggleRowItem extends StatefulWidget {
  final ToggleCubit cubit;
  final bool? isForVendor;
  final VoidCallback? onLoadMore;
  final bool hasMorePages;
  final Function(int)? onCategorySelected;

  const ToggleRowItem({
    super.key,
    required this.cubit,
    this.isForVendor = false,
    this.onLoadMore,
    this.hasMorePages = false,
    this.onCategorySelected,
  });

  @override
  State<ToggleRowItem> createState() => _ToggleRowItemState();
}

class _ToggleRowItemState extends State<ToggleRowItem> {
  late ScrollController _scrollController;
  final GlobalKey _containerKey = GlobalKey();
  final List<GlobalKey> _itemKeys = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedIndex();
    });
  }

  @override
  void didUpdateWidget(ToggleRowItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    final items = widget.isForVendor ?? false ? widget.cubit.vendorItems : widget.cubit.items;
    // Update item keys if items count changed
    if (_itemKeys.length != items.length) {
      _itemKeys.clear();
      for (int i = 0; i < items.length; i++) {
        _itemKeys.add(GlobalKey());
      }
    }
  }

  void _onScroll() {
    if (widget.hasMorePages && widget.onLoadMore != null) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final threshold = maxScroll * 0.8; // Load more at 80% scroll

      if (currentScroll >= threshold) {
        widget.onLoadMore?.call();
      }
    }
  }

  void _scrollToSelectedIndex() {
    if (!_scrollController.hasClients) return;

    final selectedIndex = widget.cubit.state;
    if (selectedIndex < 0 || selectedIndex >= _itemKeys.length) return;

    // Get the context of the selected item
    final selectedItemContext = _itemKeys[selectedIndex].currentContext;
    if (selectedItemContext == null) return;

    final RenderBox? selectedBox = selectedItemContext.findRenderObject() as RenderBox?;
    final RenderBox? scrollBox = _containerKey.currentContext?.findRenderObject() as RenderBox?;
    
    if (selectedBox == null || scrollBox == null) return;

    // Calculate the position of the selected item relative to the scroll view
    final itemPosition = selectedBox.localToGlobal(Offset.zero, ancestor: scrollBox);
    final itemWidth = selectedBox.size.width;
    final scrollViewWidth = scrollBox.size.width;

    // Calculate the scroll offset to center the item
    final targetScrollOffset = _scrollController.offset + 
                               itemPosition.dx + 
                               (itemWidth / 2) - 
                               (scrollViewWidth / 2);

    final clampedOffset = targetScrollOffset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVendor = widget.isForVendor ?? false;
    final items = isVendor ? widget.cubit.vendorItems : widget.cubit.items;
    
    // For vendor, add 1 for "All" option
    final totalItems = isVendor ? items.length + 1 : items.length;

    // Initialize item keys if needed
    if (_itemKeys.length != totalItems) {
      _itemKeys.clear();
      for (int i = 0; i < totalItems; i++) {
        _itemKeys.add(GlobalKey());
      }
    }

    return items.isEmpty && !isVendor
        ? Center(child: Text(appStrings(context).textNoData))
        : LayoutBuilder(
            builder: (context, constraints) {
              // Scroll to selected after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _scrollController.hasClients) {
                  _scrollToSelectedIndex();
                }
              });

              return SingleChildScrollView(
                key: _containerKey,
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: [
                    // Add "All" option for vendor categories
                    if (isVendor)
                      GestureDetector(
                        key: _itemKeys[0],
                        onTap: () {
                          widget.cubit.selectItem(0);
                          Future.delayed(const Duration(milliseconds: 50), () {
                            if (mounted) {
                              _scrollToSelectedIndex();
                            }
                          });
                          // Notify parent about "All" selection (index -1 means all)
                          widget.onCategorySelected?.call(-1);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.cubit.state == 0
                                  ? Utils.isDark(context)
                                      ? Colors.transparent
                                      : AppColors.colorPrimary
                                  : Utils.isDark(context)
                                      ? Colors.transparent
                                      : Colors.grey,
                            ),
                            gradient: (Utils.isDark(context) &&
                                    widget.cubit.state == 0)
                                ? AppColors.primaryGradient
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            color: widget.cubit.state == 0
                                ? Utils.isDark(context)
                                    ? null
                                    : AppColors.colorPrimary.withOpacity(0.1)
                                : Utils.isDark(context)
                                    ? AppColors.black2E
                                    : Colors.transparent,
                          ),
                          child: Text(
                            appStrings(context).textAll,
                            style: TextStyle(
                              color: widget.cubit.state == 0
                                  ? Utils.isDark(context)
                                      ? AppColors.white
                                      : AppColors.colorPrimary
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ...List.generate(items.length, (index) {
                      // Adjust index for vendor items (add 1 because of "All")
                      final displayIndex = isVendor ? index + 1 : index;
                      final name = isVendor
                          ? (items[index] as VendorCategoryData).displayTitle
                          : (items[index] as PropertyCategoryData).name ?? "";

                      return GestureDetector(
                        key: _itemKeys[displayIndex],
                        onTap: () {
                          widget.cubit.selectItem(displayIndex);
                          Future.delayed(const Duration(milliseconds: 50), () {
                            if (mounted) {
                              _scrollToSelectedIndex();
                            }
                          });
                          // Notify parent about category selection
                          widget.onCategorySelected?.call(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.cubit.state == displayIndex
                                  ? Utils.isDark(context)
                                      ? Colors.transparent
                                      : AppColors.colorPrimary
                                  : Utils.isDark(context)
                                      ? Colors.transparent
                                      : Colors.grey,
                            ),
                            gradient: (Utils.isDark(context) &&
                                    widget.cubit.state == displayIndex)
                                ? AppColors.primaryGradient
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            color: widget.cubit.state == displayIndex
                                ? Utils.isDark(context)
                                    ? null
                                    : AppColors.colorPrimary.withOpacity(0.1)
                                : Utils.isDark(context)
                                    ? AppColors.black2E
                                    : Colors.transparent,
                          ),
                          child: Text(
                            name,
                            style: TextStyle(
                              color: widget.cubit.state == displayIndex
                                  ? Utils.isDark(context)
                                      ? AppColors.white
                                      : AppColors.colorPrimary
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      );
                    }),
                    if (widget.hasMorePages)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
