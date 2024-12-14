import 'package:cached_network_image/cached_network_image.dart';
import 'package:aurora_teacher/data/models/studyMaterial.dart';
import 'package:aurora_teacher/ui/styles/colors.dart';
import 'package:aurora_teacher/ui/widgets/customAppbar.dart';
import 'package:aurora_teacher/ui/widgets/errorContainer.dart';
import 'package:aurora_teacher/utils/labelKeys.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageFileScreen extends StatefulWidget {
  final StudyMaterial imageFileMaterial;
  const ImageFileScreen({super.key, required this.imageFileMaterial});

  static Route route(RouteSettings routeSettings) {
    final StudyMaterial studyMaterial =
        (routeSettings.arguments as Map?)?["studyMaterial"] ??
            StudyMaterial.fromJson({});
    return CupertinoPageRoute(
      builder: (_) => ImageFileScreen(
        imageFileMaterial: studyMaterial,
      ),
    );
  }

  @override
  State<ImageFileScreen> createState() => _ImageFileScreenState();
}

class _ImageFileScreenState extends State<ImageFileScreen> {
  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          setState(() {
            isFullScreen = !isFullScreen;
          });
        },
        child: Icon(
          isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: !isFullScreen
                  ? UiUtils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          UiUtils.appBarSmallerHeightPercentage,
                      keepExtraSpace: false,
                    )
                  : 0,
            ),
            child: CachedNetworkImage(
              imageBuilder: (context, imageProvider) => InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Container(
                  alignment: Alignment.center,
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              imageUrl: widget.imageFileMaterial.fileUrl,
              errorWidget: (context, url, error) => Center(
                child: ErrorContainer(
                  errorMessageText: UiUtils.getTranslatedLabel(
                      context, imageFileOpenErrorKey),
                ),
              ),
              progressIndicatorBuilder: (context, url, progress) => Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      UiUtils.getTranslatedLabel(context, imageFileLoadingKey),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${((progress.downloaded / (progress.totalSize ?? 100)) * 100).toStringAsFixed(2)} %",
                      style: const TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 6,
                      child: LayoutBuilder(
                        builder: (context, boxConstraints) {
                          return Stack(
                            children: [
                              UiUtils.buildProgressContainer(
                                width: boxConstraints.maxWidth,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.5),
                              ),
                              UiUtils.buildProgressContainer(
                                width: boxConstraints.maxWidth *
                                    (progress.downloaded /
                                        (progress.totalSize ?? 100)) *
                                    100 *
                                    0.01,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isFullScreen)
            CustomAppBar(
              title: widget.imageFileMaterial.fileName.substring(
                0,
                widget.imageFileMaterial.fileName.lastIndexOf('.') == -1
                    ? widget.imageFileMaterial.fileName.length
                    : widget.imageFileMaterial.fileName.lastIndexOf('.'),
              ),
              actionButton: IconButton(
                icon: SvgPicture.asset(
                  UiUtils.getImagePath("download_icon.svg"),
                  width: 20,
                  height: 20,
                ),
                onPressed: () {
                  UiUtils.openDownloadBottomsheet(
                    context: context,
                    storeInExternalStorage: true,
                    studyMaterial: widget.imageFileMaterial,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
