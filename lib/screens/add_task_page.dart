import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/tasks.dart';
import '../widgets/my_button.dart';
import 'agenda_screen.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = DateFormat("hh:mm a").format(DateTime.now().add(const Duration(hours: 1, minutes: 5))).toString();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now().add(const Duration(minutes: 5))).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly", "Yearly"];
  int _selectedColor = 0;
  List<Color> colorList = [Colors.blue, Colors.red, Colors.yellow, Colors.pink];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
                MyInputField(title: "Description", hint: "Enter your description", controller: _descriptionController),
                MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
                    widget: IconButton(
                      icon: Icon(Icons.calendar_today_outlined),
                      color: Colors.grey,
                      onPressed: () => _getDateFromUser(),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: "Start Date",
                        hint: _startTime,
                        widget: IconButton(
                          icon: Icon(Icons.access_time_rounded,
                            color: Colors.grey,),
                          onPressed: () => _getTimeFromUser(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: MyInputField(
                        title: "End Date",
                        hint: _endTime,
                        widget: IconButton(
                          icon: Icon(Icons.access_time_rounded,
                            color: Colors.grey,),
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                        ),
                      ),
                    )
                  ],
                ),
                MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
                    widget: DropdownButton(
                      icon: Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey,),
                      style: TextStyle(),
                      underline: Container(height: 0,),
                      iconSize: 32,
                      elevation: 4,
                      onChanged: (String? newValue) => setState(() => _selectedRemind = int.parse(newValue!)),
                      items: remindList.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString(), style: TextStyle(color: Colors.grey),),
                        );
                      }).toList(),
                    )),
                MyInputField(title: "Repeat", hint: _selectedRepeat,
                    widget: DropdownButton(
                      icon: Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey,),
                      style: TextStyle(),
                      underline: Container(height: 0,),
                      iconSize: 32,
                      elevation: 4,
                      onChanged: (String? newValue) => setState(() => _selectedRepeat = newValue!),
                      items: repeatList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.grey),),
                        );
                      }).toList(),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _colorPallete(),
                      MyButton(label: Text(
                        "Create Task",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
                      ), onTap: () => _validate())
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  _validate() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty){
      DateTime startTime = DateFormat("hh:mm a").parse(_startTime);
      DateTime endTime = DateFormat("hh:mm a").parse(_endTime);
      Task newTask = Task(
          field: _titleController.text,
          course: _descriptionController.text,
          stage: "",
          startTime : DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, startTime.hour, startTime.minute),
          endTime : DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, endTime.hour, endTime.minute),
          state: 0,
          color: colorList[_selectedColor]
      );
      list.add(newTask);
      Navigator.of(context).pop();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 12.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Required",  style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("All fields are required!"),
                  ],
                )
              ],
            ),
          )
      );
    }
  }

  _getDateFromUser() async{
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2121)
    );
    setState(() => _selectedDate = _pickerDate!);
  }
  _getTimeFromUser({bool isStartTime = true}) async {
    TimeOfDay? _pickedTime = await _showTimePicker();
    if (_pickedTime == null){
      print("Time Selection Canceled");
    }else {
      String _formattedTime = _pickedTime.format(context);
      if (isStartTime == true){
        setState(() => _startTime = _formattedTime);
      }else if (isStartTime == false){
        setState(() => _endTime = _formattedTime);
      }
    }
  }

  _showTimePicker(){
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          // 10:30 PM
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])
        )
    );
  }

  _colorPallete() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
      SizedBox(height: 8.0,),
      Wrap(
        children: List<Widget>.generate(
            colorList.length,
                (int index) => GestureDetector(
              onTap: () => setState(() => _selectedColor = index),
              child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                      radius: 14,
                      backgroundColor: colorList[index],
                      child: _selectedColor == index ?
                      Icon(Icons.done, color: Colors.white, size: 16,) : Container()
                  )
              ),
            )
        ),
      )
    ],
  );
}

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({Key? key, required this.title, required this.hint, this.controller, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey,
                    width: 1.0
                ),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        )
                    ),

                  ),
                ),
                widget == null ? Container() : Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}