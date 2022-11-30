import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
TextEditingController _textFieldController = TextEditingController();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("TO-DO App"),
        backgroundColor: Colors.blue,
      ),
      body:Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child:Column(
                children: [
                  const SizedBox(
                    child: Text("TO-DO List",style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('todolist').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final docs = snapshot.data!.docs;
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 90,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.values[3],
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          docs[index]['title'].toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Expanded( // <-- SEE HERE
                                      flex: 3, // <-- SEE HERE
                                      child: SizedBox.shrink(),
                                    ),
                                    Container(
                                      child: Checkbox(
                                        fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                          return Colors.white;
                                        }),
                                        checkColor: Colors.blue,
                                        value: false,
                                        onChanged: (bool? value){
                                          addtofirebase(docs[index]['title'], 'done');
                                          setState(()async{
                                            await FirebaseFirestore.instance.collection('todolist')
                                                .doc(docs[index]['id']).delete()
                                                .then(
                                                  (doc) => log("Document deleted"),
                                              onError: (e) =>
                                                  log("Error updating document $e"),
                                            );

                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('todolist')
                                              .doc(docs[index]['id'])
                                              .delete()
                                              .then(
                                                (doc) => log("Document deleted"),
                                            onError: (e) =>
                                                log("Error updating document $e"),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                              );
                            });
                      }
                    },
                  ),
                  const SizedBox(
                    child: Text("Completed Tasks",style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('done').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final docs = snapshot.data!.docs;
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 90,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.values[3],
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          docs[index]['title'].toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Expanded( // <-- SEE HERE
                                      child: SizedBox.shrink(),
                                      flex: 3,
                                    ),
                                    const SizedBox(
                                      child:Text("Task Done!",style: TextStyle(
                                        color: Colors.white,

                                      ),),
                                    ),
                                    Container(
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('done')
                                              .doc(docs[index]['id'])
                                              .delete()
                                              .then(
                                                (doc) => log("Document deleted"),
                                            onError: (e) =>
                                                log("Error updating document $e"),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                              );
                            });
                      }
                    },
                  )
                ],
              )


            ),




      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    title: const Text("Add a task"),
                    content: TextField(
                      controller: _textFieldController,
                    ),
                    actions:<Widget> [
                      ElevatedButton(
                        child: const Text('OK',style: TextStyle(
                          fontSize: 15,
                        ),),
                        onPressed: () async{
                          Fluttertoast.showToast(msg: _textFieldController.text);
                          addtofirebase(_textFieldController.text.toString(),'todolist');
                          _textFieldController.text="";
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                );
              });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  addtofirebase(String task,String collection) async {
    await FirebaseFirestore.instance.collection(collection).doc(task).set({"title":task,"id":task});
  }



}
