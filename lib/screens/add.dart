// ignore_for_file: must_be_immutable, unrelated_type_equality_checks, unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studentappgetx/helper/student_helper.dart';
import 'package:studentappgetx/helper/validators.dart';
import 'package:studentappgetx/model/db_functions.dart';
import 'package:studentappgetx/model/student_model.dart';
import 'package:studentappgetx/screens/homepage.dart';

class AddPage extends StatefulWidget {
   AddPage({
    super.key,
    required this.isEdit,
    this.stu});

   bool isEdit = false ;
   StudentModel? stu;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  DbFunctions dbhelper = DbFunctions();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _mobileController = TextEditingController();

  final _emailController = TextEditingController();

  final gender = ['male','female','others'];

  String selGender='';

  final domainList = ['MERN - web development','MEAN - web development','Django and React','Mobile development using Flutter','Data Science','Cyber security'];

  String selDomain = '';

  File? _selectedImage;

  DateTime dob = DateTime.now();

  String? d;

  DateTime? db;
final controller = Get.put(StudentGetX());

  @override
  Widget build(BuildContext context) {

    

    if(widget.isEdit){
      controller.profileImage.value = widget.stu!.photo;
      _nameController.text = widget.stu!.name;
      controller.gender.value = widget.stu!.gender;
      controller.domain.value = widget.stu!.domain;
      db = DateTime.parse(widget.stu!.dob);
      _mobileController.text = widget.stu!.mobile;
      _emailController.text = widget.stu!.email;


    }
    return  Scaffold(
        appBar: AppBar(
          title: widget.isEdit?const Text("Edit student details"):const Text("Register new students")
        ),
    
        body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                    children: [

                         Obx(
                           (){
                            return GestureDetector(
                            onTap: () async{
                               controller.getImage();
                               
                            },
                            child: Container(
                              height: 120,width: 120,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(width: 2)
                              ),
                              child: controller.profileImage != ''
                              ?Image.file(File(controller.profileImage.toString()),fit: BoxFit.fill,)
                              :const Icon(Icons.photo)                  
                                             ,
                            )
                                             );
  }),
                      
        
        
                      const SizedBox(height: 20,),
        
                      TextFormField(
                        controller: _nameController,
                        validator: Validators.validateFullName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: "Name"
                        ),
                      ),
        
                      const SizedBox(height: 20,),
        
          Obx(
            ()=> Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: gender.map((String value1) {
                  return  Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          Text(
                            value1,
                            style: const TextStyle(
                              fontSize: 12, 
                            ),
                          ),
                          Radio(
                            value: value1,
                            groupValue: controller.gender.value,
                            onChanged: (selectedValue) {
                              
                                selGender = selectedValue.toString();
                              controller.setGender(selGender);
                            },
                          ),
                        ],
                      ),
                    );
                 
                }).toList(),
              ),
               ],
                ),
              ),
          ),
            const SizedBox(height: 20,),
      
              DropdownButtonFormField(
                    validator: (value){
                        if(value == null ){
                          return "select Domain";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Domain',
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(117, 185, 237, 1)),
                              borderRadius: BorderRadius.circular(10.0)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0))),
                      items: domainList.map((String domain) {
                        return DropdownMenuItem(
                            value: domain, child: Text(domain));
                      }).toList(),
                      onChanged: (String? domain) {
                        controller.setDomain(domain!);
                      }),
                
        
                      const SizedBox(height: 15,),
        
                      Row(
                        children: [
                          const Text("Date Of Birth"),
                               Obx(
                                 ()=> TextButton(onPressed: (){
                                   showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1973),
                                      lastDate: DateTime(2025)).then((value) => controller.setDOB(value!));
                                  
                              }, child: Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.dateOfBirth.toString())))),
                               ),
                          
                        ],
                      ),
        
                      const SizedBox(height: 10,),
        
                      TextFormField(
                        validator: Validators.validateMobile,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          hintText: "Mobile ",
                        ),
                        keyboardType: TextInputType.number,
                      ),
        
                      const SizedBox(height: 20,),
        
                      TextFormField(
                        validator:Validators.validateEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: "Email"
                        ),
                        keyboardType: TextInputType.emailAddress,
                      )
                    ],
                  )),
                ),
    
                const SizedBox(height: 20,),
    
              widget.isEdit?
              ElevatedButton.icon(
                onPressed: (){
                    edit(d=controller.domain.toString(), db=DateTime.parse(controller.dateOfBirth.toString()));
                }, 
                icon: const Icon(Icons.update), 
                label: const Text("Update"))
                :ElevatedButton.icon(
                onPressed: (){

                  submit(
                    d=controller.domain.toString(), db=DateTime.parse(controller.dateOfBirth.toString())
                  );
                }, 
                icon: const Icon(Icons.save), 
                label: const Text("Register"))
    
              ],
            ),
          ),
    )
    );
  }

// ...
Future<void> submit(String? d, DateTime? db) async {
  var imagePath = controller.profileImage.value;
  final name = _nameController.text.trim();
  var gender = controller.gender.value;
  final domain = d;
  final dob = db?.toString();
  final mobile = _mobileController.text.trim();
  final email = _emailController.text.trim();

  if (_formKey.currentState?.validate() ?? false) {
    if (imagePath != null && dob != null ) {
      final student = StudentModel(
        photo: imagePath,
        name: name,
        gender: gender,
        domain: domain!,
        dob: dob,
        mobile: mobile,
        email: email,
      );
      dbhelper.addStudent(student);
      controller.profileImage.value = '';
      controller.gender.value = '';
      Get.snackbar("Successful", "Student registered");
      Get.off(const HomePage());
    } else {
  Get.snackbar("Error", "Not registered");
    }
  }else{
  Get.snackbar("Error", "Not registered");
  }
}

//to update
Future<void> edit(String? d, DateTime? db) async {
  int? id = widget.stu!.id;
  // print(id);
  final imagePath = _selectedImage?.path;
  final name = _nameController.text.trim();
  final gender = selGender;
  final domain = d;
  final dob = db?.toString();
  final mobile = _mobileController.text.trim();
  final email = _emailController.text.trim();

  if (_formKey.currentState?.validate() ?? false) { 
    if (imagePath != null && dob != null) {
     dbhelper.editStudent(id!, imagePath, name, gender, domain!, dob, mobile, email);
    } else {
  Get.snackbar("Error", "Enter all data");
    }
  }else{
  Get.snackbar("Error", "Add all data ");
  }
}

}

