import 'package:flutter/material.dart';
import 'package:codev/screens/profile_screen.dart';

import '../helpers/style.dart';
import '../main.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.getUser();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: FigmaColors.sUNRISESunray,
    appBar: AppBar(
      backgroundColor: FigmaColors.sUNRISESunray,
      leading: BackButton(),
    ),
    body: Container(
      color: FigmaColors.sUNRISESunray,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          TextFieldWidget(
              label: 'Full Name',
              text: user.name,
              onChanged: (name) => user = user.copy(name: name)
          ),
          SizedBox(height: 20),
          TextFieldWidget(
              label: 'Phone Number',
              text: user.phone,
              onChanged: (phone) => user = user.copy(phone: phone)
          ),
          SizedBox(height: 20),
          TextFieldWidget(
              label: 'Email',
              text: user.email,
              onChanged: (email) => user = user.copy(email: email)
          ),
          SizedBox(height: 20),
          TextFieldWidget(
              label: 'Location',
              text: user.location,
              onChanged: (location) => user = user.copy(location: location)
          ),
          SizedBox(height: 20),
          TextFieldWidget(
              label: 'Time Zone',
              text: user.timezone,
              onChanged: (timezone) => user = user.copy(timezone: timezone)
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Check your info one more time.',
                style: FigmaTextStyles.mButton.copyWith(color: FigmaColors.sUNRISEBluePrimary),
            ),
          ),
          SizedBox(height: 10),
          buildSaveButton(context),
        ],
      ),
    ),
  );

  buildSaveButton(BuildContext context) => Center(
    child: Container(
      decoration: BoxDecoration(
        color: Color(0xFF2FD1C5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      width: 150,
      height: 48,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.fromLTRB(2,0,0,0),
              backgroundColor: Color(0xFF2FD1C5),
              shape: ContinuousRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(12.0),)),
          icon: Text('Save', style: FigmaTextStyles.mButton.copyWith(color: FigmaColors.sUNRISEWhite)),
          onPressed: () {
            UserPreferences.setUser(user);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          label: const Icon(Icons.save, color: Colors.white, size: 20)
      ),
    ),
  );
}

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: FigmaTextStyles.h4.copyWith(color: FigmaColors.systemDark),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          style: FigmaTextStyles.mB.copyWith(color: FigmaColors.systemDark)
        )
      ],
    ),
  );
}