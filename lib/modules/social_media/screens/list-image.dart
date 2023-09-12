import 'dart:io';

import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:aplikasi_rw/modules/social_media/controllers/social_media_controllers.dart';
import 'package:aplikasi_rw/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimpleExamplePage extends StatefulWidget {
  const SimpleExamplePage({Key key}) : super(key: key);

  @override
  _SimpleExamplePageState createState() => _SimpleExamplePageState();
}

class _SimpleExamplePageState extends State<SimpleExamplePage> {
  /// Customize your own filter options.
  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  int _sizePerPage = 5;

  Rx<AssetPathEntity> _path = AssetPathEntity(id: '1', name: 'album').obs;
  RxList<AssetEntity> _entities = <AssetEntity>[].obs;
  int _totalEntitiesCount = 0;

  int _page = 0;
  RxBool _isLoading = false.obs;
  RxBool _isLoadingMore = false.obs;
  RxBool _hasMoreToLoad = true.obs;

  SocialMediaControllers socialMediaControllers =
      Get.put(SocialMediaControllers(), permanent: true);

  Future<void> _requestAssets() async {
    _isLoading.value = true;

    bool permissionLocation =
        await Permission.photos.status.isPermanentlyDenied;

    if (permissionLocation) {
      await initPermissionGallery(permissionLocation);
    }

    // Request permissions.
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) {
      return;
    }
    // Further requests can be only proceed with authorized or limited.
    if (!ps.hasAccess) {
      _isLoading.value = false;

      // showToast('Permission is not accessible.');
      return;
    }
    // Obtain assets using the path entity.
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        onlyAll: true,
        filterOption: _filterOptionGroup,
        type: RequestType.image);
    if (!mounted) {
      return;
    }
    // Return if not paths found.
    if (paths.isEmpty) {
      _isLoading.value = false;

      // showToast('No paths found.');
      return;
    }

    _path.value = paths.first;

    _totalEntitiesCount = await _path.value.assetCountAsync;
    final List<AssetEntity> entities = await _path.value.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }

    _entities.value = entities;
    _isLoading.value = false;
    _hasMoreToLoad.value = _entities.length < _totalEntitiesCount;
  }

  Future initPermissionGallery(bool permissionLocation) async {
    if (permissionLocation) {
      await _dialogRequirePermissionsOpenSettings(
        title: 'Berikan Akses Gallery',
        content:
            'Untuk menggunakan fitur yang membutuhkan akses galeri, kami memerlukan izin akses galeri Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () async {
          await Get.back();

          await _dialogMessage(
              title: 'Berikan Akses Gallery',
              content:
                  'Anda tidak bisa membuat status sosial media dengan gambar tanpa ijin akses Gallery. Kami mengerti bahwa Anda ingin mengatur izin secara manual. Jika Anda berubah pikiran atau ingin memberikan izin nanti, Anda dapat membuka pengaturan aplikasi di perangkat Anda dan mengatur izin dengan mudah.',
              yes: () {
                Get.back();
              },
              context: context);
        },
        yes: () async {
          await openAppSettings();
          Get.back();
        },
        context: context,
      );
    }
  }

  Future<dynamic> _dialogMessage(
      {String title, String content, Function yes, BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig.text(16),
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: SizeConfig.text(12), color: Colors.grey),
          ),
          titlePadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          actions: [
            TextButton(
              onPressed: yes,
              child: Text(
                'OKE',
                style: TextStyle(fontSize: SizeConfig.text(14)),
              ),
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: 0,
          ),
        );
      },
    );
  }

  Future<dynamic> _dialogRequirePermissionsOpenSettings(
      {String title,
      String content,
      Function yes,
      Function no,
      BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig.text(16),
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: SizeConfig.text(12), color: Colors.grey),
          ),
          titlePadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          actions: [
            TextButton(
              onPressed: no,
              child: Text(
                'Tidak',
                style: TextStyle(fontSize: SizeConfig.text(14)),
              ),
            ),
            TextButton(
              onPressed: yes,
              child: Text(
                (Platform.isIOS) ? 'Pengaturan' : 'Pengaturan',
                style: TextStyle(fontSize: SizeConfig.text(14)),
              ),
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: 0,
          ),
        );
      },
    );
  }

  Future<void> _loadMoreAsset() async {
    _page += 5;
    _sizePerPage += 5;

    final List<AssetEntity> entities = await _path.value.getAssetListRange(
      start: _page,
      end: _sizePerPage,
    );
    if (!mounted) {
      return;
    }

    final logger = Logger();
    logger.e('load more asset');

    _entities.addAll(entities);

    logger.e(_entities.length);
    _hasMoreToLoad.value = _entities.length < _totalEntitiesCount;
    _isLoadingMore.value = false;
  }

  @override
  didChangeDependencies() {
    _requestAssets();
    super.didChangeDependencies();
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      if (_isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      if (_path == null) {
        return const Center(child: Text('Request paths first.'));
      }
      if (_entities?.isNotEmpty != true) {
        return const Center(child: Text('No assets found on this device.'));
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _entities.length,
        itemBuilder: (context, index) {
          final AssetEntity entity = _entities[index];
          return GestureDetector(
            onTap: () {
              final logger = Logger();
              entity.file.then((value) {
                logger.i(value.path);
                socialMediaControllers.imagePath.value = value.path;
              });
            },
            child: FutureBuilder<File>(
                future: entity.file,
                builder: (context, snapshot) => (snapshot.hasData)
                    ? Container(
                        width: 64.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey),
                        margin: EdgeInsets.only(right: 16.w),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AssetEntityImage(
                              entity,
                              fit: BoxFit.cover,
                              isOriginal: false, // Defaults to `true`.
                              filterQuality: FilterQuality.medium,
                              thumbnailSize: const ThumbnailSize.square(
                                  200), // Preferred value.
                              thumbnailFormat:
                                  ThumbnailFormat.jpeg, // Defaults to `jpeg`.
                            )),
                      )
                    : CircularProgressIndicator.adaptive()),
          );
        },
      );
    });
  }

  ScrollController controller = ScrollController();

  void onScroll() async {
    final logger = Logger();
    if (controller.position.haveDimensions) {
      if (controller.position.maxScrollExtent == controller.position.pixels) {
        if (!_isLoadingMore.value && _hasMoreToLoad.value) {
          logger.e('load dari on scroll');
          _loadMoreAsset();
        }
      }
    }
  }

  @override
  initState() {
    controller.addListener(onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        shrinkWrap: true,
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return bottomImagePicker(context);
                    },
                  );
                },
                child: Container(
                  width: 64.w,
                  height: 64.h,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: SvgPicture.asset(
                                'assets/img/image-svg/camera-status.svg')),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              GestureDetector(
                onTap: () {
                  locationDialog();
                },
                child: SizedBox(
                  width: 64.w,
                  height: 64.h,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: SvgPicture.asset(
                                'assets/img/image-svg/location-status.svg')),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              _buildBody(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomImagePicker(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: 100.h,
        child: Column(
          children: [
            Text(
              'Pilih gambar',
              style: TextStyle(fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      'Kamera',
                      style: TextStyle(
                          fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
                    ),
                    onPressed: () async {
                      await getImage(ImageSource.camera, context);
                    }),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text(
                    'Gallery',
                    style: TextStyle(
                        fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
                  ),
                  onPressed: () async {
                    await getImage(ImageSource.gallery, context);
                  },
                )
              ],
            )
          ],
        ),
      );

  void locationDialog() async {
    LocationServices userLocation = LocationServices();

    Get.defaultDialog(
      title: 'Mendapatkan lokasi',
      titleStyle: TextStyle(
        fontSize: 12.sp,
      ),
      content: Column(
        children: [
          LottieBuilder.asset(
            'assets/animation/get_location.json',
            fit: BoxFit.cover,
          ),
        ],
      ),
      radius: 6,
    );

    userLocation.locationStream.listen((event) async {
      List<Address> address;
      if (Platform.isAndroid) {
        address =
            await Geocoder.google('AIzaSyDbZjwizgtMKuRhgruNqb4eBg2jQzuQjFE')
                .findAddressesFromCoordinates(
          Coordinates(event.latitude, event.longitude),
        );
      } else {
        address =
            await Geocoder.google('AIzaSyAprQJ0_yPDIrLRJKB-nXDh9EdITtxTdcY')
                .findAddressesFromCoordinates(
          Coordinates(event.latitude, event.longitude),
        );
      }

      if (event != null) {
        Get.back();
      }

      Get.defaultDialog(
        title: 'Mendapatkan lokasi',
        titleStyle: TextStyle(
          fontSize: 12.sp,
        ),
        content: Column(
          children: [
            LottieBuilder.asset(
              'assets/animation/get_location.json',
              fit: BoxFit.cover,
            ),
            Text(
              '${address[0].addressLine}',
              style: TextStyle(
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        radius: 6,
      );

      socialMediaControllers.location.value = address[0].addressLine;

      Future.delayed(Duration(seconds: 1)).then((value) {
        Get.back();
      });
    });
  }

  void imagePicker(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile imageOrPhoto = await picker.pickImage(source: source);

    if (imageOrPhoto != null) {
      socialMediaControllers.imagePath.value = imageOrPhoto.path;
    }
  }

  Future getImage(ImageSource source, BuildContext context) async {
    if (source == ImageSource.camera) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
        if (await Permission.camera.status.isDenied) {
          await _showDialogReqCamera(context, source);
        } else if (await Permission.camera.status.isPermanentlyDenied) {
          await _showDialogReqCameraOpenSetting(context, source);
        } else if (await Permission.camera.status.isGranted) {
          requestImageOrPhoto(source);
        }
      }
    } else if (source == ImageSource.gallery) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
        if (await Permission.photos.status.isDenied) {
          await _showDialogReqGallery(context, source);
        } else if (await Permission.photos.status.isPermanentlyDenied) {
          await _showDialogReqGalleryOpenSetting(context, source);
        } else if (await Permission.photos.status.isGranted) {
          requestImageOrPhoto(source);
        } else if (await Permission.photos.status.isLimited) {
          await _showDialogReqGalleryOpenSetting(context, source);
        }
      }
    }
  }

  Future<void> requestImageOrPhoto(ImageSource source) async {
    imagePicker(source);
  }

  void showConfirmationDialog(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Akses'),
        content: Column(
          children: [
            const Text(
                'Kami mengerti bahwa Anda ingin mengatur izin secara manual. Jika Anda berubah pikiran atau ingin memberikan izin nanti, Anda dapat membuka pengaturan aplikasi di perangkat Anda dan mengatur izin dengan mudah.'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Get
                ..back()
                ..back()
                ..back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogReqCamera(
      BuildContext context, ImageSource source) async {
    bool permissionGranted = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Kamera'),
        content: Column(
          children: [
            const Text(
                'Untuk mengganti foto profile anda, kami perlu mengakses kamera pada perangkat Anda. Tolong beri izin akses kamera.'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);

              showConfirmationDialog(context);
            },
            child: const Text('Tolak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              var status = await Permission.camera.request();
              permissionGranted = status.isGranted;
              if (permissionGranted) {
                Get.back();
                requestImageOrPhoto(source);
              } else if (status.isPermanentlyDenied) {
                showConfirmationDialog(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialogReqGallery(
      BuildContext context, ImageSource source) async {
    bool permissionGranted = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Gallery'),
        content: Column(
          children: [
            const Text(
                'Untuk mengganti foto profile anda, kami perlu mengakses gallery pada perangkat Anda. Tolong beri izin akses gallery.'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);

              showConfirmationDialog(context);
            },
            child: const Text('Tolak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              var status = await Permission.photos.request();
              permissionGranted = status.isGranted;
              if (permissionGranted) {
                Get.back();
                requestImageOrPhoto(source);
              } else if (status.isPermanentlyDenied) {
                showConfirmationDialog(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDialogReqCameraOpenSetting(
      BuildContext context, ImageSource source) async {
    bool permissionGranted = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Gallery'),
        content: Column(
          children: [
            const Text(
                'Untuk menggunakan fitur yang membutuhkan kamera, kami memerlukan izin akses kamera Anda. Kami akan membuka pengaturan sekarang. Apakah Anda ingin memberikan izin akses sekarang?'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showConfirmationDialog(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Pengaturan'),
          ),
        ],
      ),
    );

    return permissionGranted;
  }

  Future<bool> _showDialogReqGalleryOpenSetting(
      BuildContext context, ImageSource source) async {
    bool permissionGranted = false;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Izin Gallery'),
        content: Column(
          children: [
            const Text(
                'Untuk menggunakan fitur yang membutuhkan gallery, kami memerlukan izin akses gallery Anda. Kami akan membuka pengaturan sekarang. Apakah Anda ingin memberikan izin akses sekarang?'),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              showConfirmationDialog(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text('Pengaturan'),
          ),
        ],
      ),
    );

    return permissionGranted;
  }
}
