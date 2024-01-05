import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreateBodyProgPage extends StatefulWidget {
  final Function(String? addedPath) callback;
  CreateBodyProgPage(this.callback, {Key? key}) : super(key: key);

  @override
  State<CreateBodyProgPage> createState() => _CreateBodyProgPageState();
}

class _CreateBodyProgPageState extends State<CreateBodyProgPage> {
  int step_index = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile> imageFileList = [];

    void selectImages() async {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      setState(() {
        if (selectedImages!.isNotEmpty) {
          imageFileList.addAll(selectedImages);
        }
        imageFileList.forEach((image) {
          widget.callback(image.path);
        });
      });
    }

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Create A Body Transfomation",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: const EdgeInsets.all(10),
                child: Stepper(
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: details.onStepContinue,
                            child: step_index == 1
                                ? const Text('Submit')
                                : const Text('Next'),
                          ),
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: step_index == 0
                                ? const Text('')
                                : const Text('Back'),
                          ),
                        ],
                      );
                    },
                    currentStep: step_index,
                    onStepCancel: () {
                      if (step_index > 0) {
                        setState(() {
                          step_index -= 1;
                        });
                      }
                    },
                    onStepContinue: () {
                      if (step_index < 1) {
                        setState(() {
                          step_index += 1;
                        });
                      }
                      if (step_index == 1) {
                        submitBodyProg();
                      }
                    },
                    onStepTapped: (int index) {
                      setState(() {
                        step_index = index;
                      });
                    },
                    steps: [
                      Step(
                          title:
                              const Text("Enter your current weight in lbs:"),
                          content: TextField(
                            controller: timeController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.]")),
                            ],
                          )),
                      Step(
                          title: const Text("Pick images from your gallery :"),
                          content: Column(
                            children: [
                              imageFileList.isNotEmpty ? Text("${imageFileList.length}Selected Images") : SizedBox.shrink(),
                              TextButton(
                                onPressed: selectImages,
                                child: const Text("Click To Pick"),
                              ),
                            ],
                          )),
                    ]),
              ),
            ),
            const SizedBox(
              height: 90,
            )
          ],
        ),
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              heroTag: "createbodyprogexitbtn",
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }

  void submitBodyProg() {

  }
}
