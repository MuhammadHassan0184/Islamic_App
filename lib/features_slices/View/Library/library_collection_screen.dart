import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Data/Models/library_collection_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Library/Controller/library_controller.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_content_card.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_page_header.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_search_field.dart';
import 'package:zi_core/zi_core_io.dart';

class LibraryCollectionScreen extends GetView<LibraryController> {
  const LibraryCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments;
    if (argument is! LibraryCollectionModel) {
      throw StateError('A library collection is required for this screen.');
    }
    final collection = argument;

    return ZiScaffoldB(
      showPagePadding: false,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          LibraryPageHeader(
            title: collection.title,
            subtitle: collection.description,
          ),
          Padding(
            padding: context.responsivePadding(
              horizontal: 0.04,
              vertical: 0.014,
            ),
            child: LibrarySearchField(
              hintText: 'Search ${collection.title}',
              onChanged: (value) => controller.itemSearchQuery.value = value,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: context.responsiveAll(0.06),
                    child: Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: context.scaledFont(14),
                      ),
                    ),
                  ),
                );
              }

              final items = controller.itemsFor(collection);
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: context.responsiveAll(0.06),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 38,
                          color: AppColors.primaryLight,
                        ),
                        SizedBox(height: context.heightPct(0.012)),
                        Text(
                          (controller.contents[collection.fileName] ?? [])
                                  .isEmpty
                              ? 'No entries are available yet.'
                              : 'No entries match your search.',
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

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: context.responsivePadding(
                  horizontal: 0.035,
                  vertical: 0.008,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return LibraryContentCard(
                    item: item,
                    onTap: () =>
                        Get.toNamed(AppRoutes.libraryDetail, arguments: item),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
