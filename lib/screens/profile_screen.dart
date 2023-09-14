import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codev/providers/auth.dart';
import 'package:codev/providers/user.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:codev/helpers/style.dart';
import 'package:codev/screens/edit_profile_screen.dart';
import 'package:codev/providers/user.dart' as CoDevCS;

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Size? deviceSize;
  double? safeHeight;
  late CoDevCS.User user;

  @override
  void initState() {
    super.initState();
  }

  Future<void> uploadProfileImage() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    var permissionStatus = (androidInfo.version.sdkInt <= 32) ? await Permission.storage.request() : await Permission.photos.request();
    if (permissionStatus.isGranted) {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        var file = File(image.path);
        if (!context.mounted) return;
        var imageName = Provider.of<Auth>(context, listen: false).userId;
        var snapshot = await FirebaseStorage.instance.ref().child('images/$imageName').putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        if (!context.mounted) return;
        Provider.of<User>(context, listen: false).imageUrl = downloadUrl;
        await Provider.of<User>(context, listen: false).updateUser(Provider.of<Auth>(context, listen: false).userId);
        // setState(() {
        //   user.imageUrl = downloadUrl;
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetch user data from firestore with id get from provider auth Provider.of<Auth>(context,listen: false,).userId;

    deviceSize = MediaQuery.of(context).size;
    safeHeight = deviceSize!.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(Provider.of<Auth>(context, listen: false).userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.data());
            user = CoDevCS.User.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);
            return Scaffold(
                backgroundColor: FigmaColors.sUNRISESunray,
                body: Column(
                    // physics: BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 20),
                      ProfileWidget(
                        user: user,
                        onClicked: uploadProfileImage,
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: FigmaColors.sUNRISEWhite,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildDetailedInformation(user),
                              buildEditButton(context, setState),
                            ],
                          ),
                        ),
                      )
                    ]));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildDetailedInformation(User user) {
    return Container(
      padding: EdgeInsets.only(
        left: deviceSize!.width * 0.1,
        right: deviceSize!.width * 0.1,
        top: safeHeight! * 0.03,
        bottom: safeHeight! * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfo(
            CupertinoIcons.phone,
            "Phone Number",
            user.phone,
          ),
          buildInfo(
            CupertinoIcons.mail,
            "Email",
            user.email,
          ),
          buildInfo(
            CupertinoIcons.location,
            "Location",
            user.location,
          ),
          buildInfo(
            CupertinoIcons.book,
            "Education Level",
            user.educationLevel,
            last: true,
          ),
        ],
      ),
    );
  }

  Widget buildInfo(IconData icon, String title, String detail,
      {bool last = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: last
              ? BorderSide.none
              : const BorderSide(
                  color: FigmaColors.lightblue,
                  width: 1,
                ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Icon(
          //   icon,
          //   color: FigmaColors.sUNRISEBluePrimary,
          //   size: safeHeight! * 0.05,
          //   weight: 0.1,
          //   grade: 0.1,
          // ),
          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                String.fromCharCode(icon.codePoint),
                style: TextStyle(
                  inherit: false,
                  color: FigmaColors.sUNRISEBluePrimary,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w100,
                  fontFamily: icon.fontFamily,
                  package: icon.fontPackage,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: FigmaTextStyles.h0
                      .copyWith(color: FigmaColors.sUNRISETextGrey)),
              const SizedBox(height: 4),
              Text(detail,
                  style: FigmaTextStyles.mB
                      .copyWith(color: FigmaColors.sUNRISETextGrey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1)
            ],
          )
        ],
      ),
    );
  }

  buildEditButton(BuildContext context, Function setState) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: FigmaColors.sUNRISEBluePrimary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: 150,
          height: 48,
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                backgroundColor: FigmaColors.sUNRISEBluePrimary,
                shape: ContinuousRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(
                    deviceSize!.width * 0.1,
                  ),
                ),
              ),
              icon: Text('Edit',
                  style: FigmaTextStyles.mButton
                      .copyWith(color: FigmaColors.sUNRISEWhite)),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    user: user,
                  ),
                ));
                print('done editing');
                setState(() {});
              },
              label: const Icon(Icons.border_color,
                  color: FigmaColors.sUNRISEWhite, size: 20)),
        ),
      );
}

class ProfileWidget extends StatefulWidget {
  final CoDevCS.User user;
  final VoidCallback onClicked;
  final bool isEdit;

  const ProfileWidget({
    Key? key,
    required this.user,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Center(
            child: Stack(
          children: [
            buildImage(),
            Positioned(bottom: 0, right: 0, child: buildEditIcon()),
          ],
        )),
        const SizedBox(height: 24),
        Center(
            child: Text(widget.user.name,
                style: FigmaTextStyles.mH3.copyWith(color: const Color(0xFF2F394B)))),
        Center(
          child: TextButton(
            child: Text('Log Out',
                style: FigmaTextStyles.mP
                    .copyWith(color: FigmaColors.sUNRISEBluePrimary)),
            onPressed: () {
              print('Log Out');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ),
      ],
    );
  }

  Widget buildImage() {
    final image = NetworkImage(widget.user.imageUrl);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: FigmaColors.sUNRISEBluePrimary, width: 2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.0),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            child: InkWell(
              onTap: widget.onClicked,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon() => buildBorder(
        borderRadius: 6.0,
        paddingAll: 2.0,
        color: const Color(0xFFF5FBFF),
        child: buildBorder(
          paddingAll: 2.0,
          color: const Color(0xFF2FD1C5),
          borderRadius: 5.0,
          child: const Icon(
            Icons.add_photo_alternate_outlined,
            size: 20,
            color: Colors.white,
          ),
        ),
      );

  Widget buildBorder({
    required Widget child,
    required double borderRadius,
    required double paddingAll,
    required Color color,
  }) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: EdgeInsets.all(paddingAll),
          color: color,
          child: child,
        ),
      );
}
