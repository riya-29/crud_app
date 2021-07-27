import 'package:crud_app/Model/Data.dart';
import 'package:crud_app/Services/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController nameTEC = TextEditingController();
  TextEditingController ageTEC = TextEditingController();

  @override
  void dispose() {
    // Hive.box('data').close(); //close one box
    Hive.close();               //close all boxes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD"),backgroundColor: Colors.indigo,),

      floatingActionButton: FloatingActionButton(backgroundColor: Colors.indigo,
        onPressed: (){
          showDialog(context: context, builder: (context){
            nameTEC.text="";
            ageTEC.text="";
            return AlertDialog(
              title: Text("Add"),
              content: Container(color: Colors.white,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameTEC,
                        decoration: InputDecoration(
                        hintText: "Name"
                      ),),
                      TextFormField(
                        controller: ageTEC,
                        decoration: InputDecoration(
                          hintText: "Age"
                      ),),
                      RaisedButton(
                          onPressed: (){
                            addData(nameTEC.text, int.parse(ageTEC.text));
                            Navigator.pop(context);
                        },child: Text("Add"),),
                    ],
                  ),
                ),
              );
          });
        },

        child: Icon(Icons.add_rounded),
      ),

      body: ValueListenableBuilder<Box<Data>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          final dataList = box.values.toList().cast<Data>();
          return buildContent(dataList);
        },
      ),
    );
  }

  Future<void> addData(String name,int age)async {
    final data = Data()
        ..name = name
        ..age = age;

    final box = Boxes.getData();
    box.add(data);
  }

  void editData(Data data, String name, int age) {
    data.name = name;
    data.age = age;

    // final box = Boxes.getData();
    // box.put(transaction.key, transaction);

    data.save();
  }

  void deleteData(Data data) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);
    data.delete();
  }

  Widget buildContent(List<Data> dataList) {
    if (dataList.isEmpty) {
      return Center(
        child: Text(
          'No data yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Container(
        child: ListView.builder(itemCount: dataList.length,itemBuilder: (context, index){
          return Dismissible(
            key: Key(dataList[index].toString()),
            onDismissed: (direction){
              dataList[index].delete();
            },
            background: Container(
              padding: EdgeInsets.all(10),
              alignment:Alignment.centerLeft,
              color: Colors.red,
            child: Icon(Icons.delete),),
            secondaryBackground: Container(
              padding: EdgeInsets.all(10),
              alignment:Alignment.centerRight,
              color: Colors.red,
              child: Icon(Icons.delete),),

            child: Card(color: Colors.blueGrey.shade50,
              child: ListTile(
                title: Text("Name: ${dataList[index].name}"),
                subtitle: Text("Age: ${dataList[index].age}"),
                trailing: IconButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context){
                        nameTEC.text = dataList[index].name;
                        ageTEC.text = dataList[index].age.toString();
                        return AlertDialog(
                          title: Text("Edit"),
                          content: Container(color: Colors.white,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: nameTEC,
                                  decoration: InputDecoration(
                                      hintText: "Name"
                                  ),),
                                TextFormField(
                                  controller: ageTEC,
                                  decoration: InputDecoration(
                                      hintText: "Age"
                                  ),),
                                RaisedButton(
                                  onPressed: (){
                                    editData(dataList[index],nameTEC.text, int.parse(ageTEC.text));
                                    Navigator.pop(context);
                                  },child: Text("Update"),),
                              ],
                            ),
                          ),
                        );
                      });
                    },icon: Icon(Icons.edit),),
              ),
            ),
          );
        }),
      );
    }
  }



}
