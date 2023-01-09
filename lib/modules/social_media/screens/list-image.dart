import 'dart:io';

import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:aplikasi_rw/modules/social_media/controllers/social_media_controllers.dart';
import 'package:aplikasi_rw/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
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
  final int _sizePerPage = 5;

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

  Future<void> _loadMoreAsset() async {
    final List<AssetEntity> entities = await _path.value.getAssetListPaged(
      page: _page + 1,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }

    _entities.addAll(entities);
    _page++;
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
          if (index == _entities.length - 8 &&
              !_isLoadingMore.value &&
              _hasMoreToLoad.value) {
            _loadMoreAsset();
          }
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        shrinkWrap: true,
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
                    onPressed: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context)
                          .pop(); // -> digunakan untuk menutup show modal bottom sheet secara programatic
                    }),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text(
                    'Gallery',
                    style: TextStyle(
                        fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
                  ),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                    Navigator.of(context)
                        .pop(); // -> digunakan untuk menutup show modal bottom sheet secara programatic
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

  void getImage(ImageSource source) async {
    final _picker = ImagePicker();
    var pickedFile = await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      socialMediaControllers.imagePath.value = pickedFile.path;
      final logger = Logger();
      logger.i(socialMediaControllers.imagePath.value);
    }
  }
}
