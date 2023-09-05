import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:codev/helpers/style.dart';
import 'package:codev/screens/edit_profile_screen.dart';

class User {
  final String imagePath;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String timezone;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.timezone});

  User copy({
    String? imagePath,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? timezone
  }) => User(
    imagePath:  imagePath ?? this.imagePath,
    name:  name ?? this.name,
    email:  email ?? this.email,
    phone:  phone ?? this.phone,
    location:  location ?? this.location,
    timezone:  timezone ?? this.timezone,
  );

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'name': name,
    'email': email,
    'phone': phone,
    'location': location,
    'timezone': timezone,
  };

  static User fromJson(Map<String, dynamic> json) => User(
    imagePath: json['imagePath'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    location: json['location'],
    timezone: json['timezone'],
  );
}

class UserPreferences {
  static late SharedPreferences _preferences;
  static const _keyUser = 'key1';
  static const myUser = User(
      imagePath: 'https://i.pinimg.com/474x/69/e4/18/69e418229028158844267992fbdd00b7.jpg',
      name: 'Jennie',
      email: 'jennierubyjane@gmail.com',
      phone: '+84888888888',
      location: 'Seoul',
      timezone: 'HaNoi (GMT +4)'
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());
    await _preferences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);
    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  const ProfileScreen({super.key});


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();
    return Scaffold(
        backgroundColor: FigmaColors.sUNRISESunray,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            backgroundColor: FigmaColors.sUNRISESunray,
            title: const Text('My Profile'),
            centerTitle: true,
            leading: BackButton(),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: Column(
            // physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 27),
              ProfileWidget(
                user: user,
                onClicked: () async {},
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      buildDetailedInformation(user),
                      SizedBox(height:40),
                      buildEditButton(context, setState)
                    ],
                  ),
                ),
              )
            ]
        )
    );
  }

  Widget buildDetailedInformation(User user) {
    return Container(
        margin: EdgeInsets.symmetric(vertical:10),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfo(Icons.phone, "Phone Number", user.phone),
            buildInfo(Icons.email_outlined, "Email", user.email),
            buildInfo(Icons.location_on_outlined, "Location", user.location),
            buildInfo(Icons.watch_later_outlined, "Time Zone", user.timezone, last: true),
          ],
        ),
      );
  }

  Widget buildInfo(IconData icon, String title, String detail, {bool last = false}) {
    return Container(
      width: 265,
      decoration: BoxDecoration(
          border: Border(
              bottom: last ?
              BorderSide.none :
              BorderSide(
                color: FigmaColors.lightblue,
                width: 1,
              )
          )
      ),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: FigmaColors.sUNRISEBluePrimary),
            SizedBox(width: 15),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: FigmaTextStyles.h0.copyWith(color: FigmaColors.sUNRISETextGrey)),
                    Text(detail, style: FigmaTextStyles.mB.copyWith(color: FigmaColors.sUNRISETextGrey), overflow: TextOverflow.ellipsis, maxLines: 1)
                  ],
                ),
              ),
            )
          ]
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
                padding: EdgeInsets.fromLTRB(2,0,0,0),
                backgroundColor: FigmaColors.sUNRISEBluePrimary,
                shape: ContinuousRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.0))),
            icon: Text('Edit', style: FigmaTextStyles.mButton.copyWith(color: FigmaColors.sUNRISEWhite)),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              setState(() {});
            },
            label: const Icon(Icons.border_color, color: FigmaColors.sUNRISEWhite, size: 20)
        ),
      ),
  );
}

class ProfileWidget extends StatefulWidget {
  final User user;
  final VoidCallback onClicked;
  final bool isEdit;

  const ProfileWidget({Key? key, required this.user, this.isEdit = false, required this.onClicked,}) : super(key: key);

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
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: buildEditIcon()),
              ],
            )
        ),
        SizedBox(height: 24),
        Center(child: Text(widget.user.name, style: FigmaTextStyles.mH3.copyWith(color: Color(0xFF2F394B)))),
        Center(child: buildLogOutButton()),
      ],
    );
  }

  Widget buildImage() {
    final image = NetworkImage(widget.user.imagePath);
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
            child: InkWell(onTap: widget.onClicked),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon() => buildBorder(
    borderRadius: 6.0,
    paddingAll: 2.0,
    color: Color(0xFFF5FBFF),
    child: buildBorder(
      paddingAll: 2.0,
      color: Color(0xFF2FD1C5),
      borderRadius: 5.0,
      child: Icon(
        Icons.add_photo_alternate_outlined,
        size: 15,
        color: Colors.white,
      ),
    ),
  );

  Widget buildBorder({
    required Widget child,
    required double borderRadius,
    required double paddingAll,
    required Color color,
  }) => ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Container(
      padding: EdgeInsets.all(paddingAll),
      color: color,
      child: child,
    ),
  );

  bool changeColor = false;
  Widget buildLogOutButton() {
    return TextButton(
      child: Text(
          'Log Out',
          style: FigmaTextStyles.mP.copyWith(color: FigmaColors.sUNRISEBluePrimary)),
      onPressed: (){},
      onHover: (hovered) => setState(() => changeColor = hovered),
    );
  }
}
