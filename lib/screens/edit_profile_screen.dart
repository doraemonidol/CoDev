import 'package:codev/providers/user.dart';
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
  User? user;
  Size? deviceSize;
  double? safeHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = UserPreferences.getUser(context);
    deviceSize = MediaQuery.of(context).size;
    safeHeight = deviceSize!.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: FigmaColors.sUNRISESunray,
      appBar: AppBar(
        backgroundColor: FigmaColors.sUNRISESunray,
        leading: BackButton(),
      ),
      body: Container(
        color: FigmaColors.sUNRISESunray,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 20),
            TextFieldWidget(
                label: 'Full Name',
                text: user!.name,
                onChanged: (name) => user = user!.copy(name: name)),
            SizedBox(height: 20),
            TextFieldWidget(
                label: 'Phone Number',
                text: user!.phone,
                onChanged: (phone) => user = user!.copy(phone: phone)),
            SizedBox(height: 20),
            TextFieldWidget(
                label: 'Email',
                text: user!.email,
                onChanged: (email) => user = user!.copy(email: email)),
            SizedBox(height: 20),
            TextFieldWidget(
                label: 'Location',
                text: user!.location,
                onChanged: (location) => user = user!.copy(location: location)),
            SizedBox(height: 20),

            // dropdown list to choose education level
            Text(
              'Education Level',
              style: FigmaTextStyles.mButton
                  .copyWith(color: FigmaColors.sUNRISELightCharcoal),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: FigmaColors.sUNRISELightCharcoal,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: user!.educationLevel,
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        'Year 7-9',
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                      ),
                      value: 'Year 7-9',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Year 10-11',
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                      ),
                      value: 'Year 10-11',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Year 12-13',
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                      ),
                      value: 'Year 12-13',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Bachelor',
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                      ),
                      value: 'Bachelor',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Master',
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                      ),
                      value: 'Master',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Worked',
                        style: FigmaTextStyles.mButton
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                      ),
                      value: 'Worked',
                    ),
                    DropdownMenuItem(
                      child: Text(
                        'Unknown',
                        style: FigmaTextStyles.mH4
                            .copyWith(color: FigmaColors.sUNRISELightCharcoal),
                      ),
                      value: 'Unknown',
                      //enabled: false,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      user = user!.copy(educationLevel: value.toString());
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Check your info one more time.',
                style: FigmaTextStyles.sButton
                    .copyWith(color: FigmaColors.sUNRISEErrorRed),
              ),
            ),
            SizedBox(height: 10),
            buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  buildSaveButton(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2FD1C5),
          borderRadius: BorderRadius.circular(
            deviceSize!.width * 0.1,
          ),
        ),
        width: 150,
        height: 48,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
              backgroundColor: Color(0xFF2FD1C5),
              shape: ContinuousRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(
                  deviceSize!.width * 0.05,
                ),
              )),
          icon: Text('Save',
              style: FigmaTextStyles.mButton
                  .copyWith(color: FigmaColors.sUNRISEWhite)),
          onPressed: () {
            UserPreferences.setUser(user!);
            Navigator.of(context).pop();
          },
          label: const Icon(
            Icons.save,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  const TextFieldWidget(
      {Key? key,
      this.maxLines = 1,
      required this.label,
      required this.text,
      required this.onChanged})
      : super(key: key);

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: FigmaTextStyles.mButton.copyWith(
              color: FigmaColors.systemDark,
            ),
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
              style: FigmaTextStyles.mB.copyWith(color: FigmaColors.systemDark))
        ],
      ),
    );
  }
}
