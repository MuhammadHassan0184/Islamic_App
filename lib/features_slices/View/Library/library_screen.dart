import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Library/Controller/library_controller.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_collection_card.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_page_header.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_search_field.dart';
import 'package:zi_core/zi_core_io.dart';

class LibraryScreen extends GetView<LibraryController> {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZiScaffoldB(
      showPagePadding: false,
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Home_bg_image.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: Colors.white);
            },
          ),
          SafeArea(
            child: Column(
              children: [
                const LibraryPageHeader(
                  title: 'Islamic Library',
                  subtitle: 'Explore helpful Islamic knowledge',
                ),
                Padding(
                  padding: context.responsivePadding(
                    horizontal: 0.04,
                    vertical: 0.014,
                  ),
                  child: LibrarySearchField(
                    onChanged: (value) =>
                        controller.collectionSearchQuery.value = value,
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.errorMessage.value.isNotEmpty) {
                      return _errorState(context);
                    }

                    final collections = controller.filteredCollections;
                    if (collections.isEmpty) {
                      return _emptyState(
                        context,
                        'No collections match your search.',
                      );
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: context.responsivePadding(
                        horizontal: 0.04,
                        vertical: 0.008,
                      ),
                      itemCount: collections.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 220,
                        childAspectRatio:
                            0.95 / MediaQuery.textScalerOf(context).scale(1),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final collection = collections[index];
                        return LibraryCollectionCard(
                          collection: collection,
                          itemCount:
                              controller
                                  .contents[collection.fileName]
                                  ?.length ??
                              0,
                          onTap: () {
                            controller.itemSearchQuery.value = '';
                            Get.toNamed(
                              AppRoutes.libraryCollection,
                              arguments: collection,
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: context.responsiveAll(0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 38,
              color: AppColors.primaryLight,
            ),
            SizedBox(height: context.heightPct(0.012)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.responsiveAll(0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(14),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.loadCollections,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
