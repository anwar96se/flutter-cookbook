import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const title = 'Persist data with SQLite';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(fontFamily: 'Raleway'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = SQLHelper();

  Future<List<Dog>> _futureDogs;

  @override
  void initState() {
    super.initState();
    _futureDogs = dbHelper.dogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<Dog>>(
        future: _futureDogs,
        builder: (context, snapshot) {
          return (snapshot.hasData)
              ? _buildList(snapshot.data)
              : Center(child: Text('No Items found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            dbHelper.insertDog(Dog(name: "Dia'a", age: 25));
            _futureDogs = dbHelper.dogs();
          });
        },
      ),
    );
  }

  Widget _buildList(List<Dog> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key(item.id.toString()),
          onDismissed: (direction) {
            setState(() {
              items.remove(item);
              final removeItem = dbHelper.deleteDog(item.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('$removeItem removed'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    setState(() {
                      dbHelper.insertDog(item);
                      _futureDogs = dbHelper.dogs();
                    });
                  },
                ),
              ));
            });
          },
          background: Container(color: Colors.red),
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                final updatedDog = Dog(
                  id: items[index].id,
                  name: items[index].name + ' Updated',
                  age: 26,
                );
                dbHelper.updateDog(updatedDog);
                _futureDogs = dbHelper.dogs();
              });
            },
            child: ListTile(
              title: Text('Dog: ${items[index].name}'),
              subtitle: Text('Age: ${items[index].age}'),
            ),
          ),
        );
      },
    );
  }
}

class SQLHelper {
  Future<Database> get database async => openDatabase(
        join(await getDatabasesPath(), 'doggie_database.db'),
        onCreate: _createDB,
        version: 1,
      );

  Future<void> _createDB(Database db, int version) {
    return db.execute('CREATE TABLE dogs('
        'id INTEGER, '
        'name TEXT, '
        'age INTEGER,'
        'PRIMARY KEY("id" AUTOINCREMENT)'
        ')');
  }

  Future<void> insertDog(Dog dog) async {
    final Database db = await database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDog(Dog dog) async {
    final Database db = await database;
    await db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ? ',
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    final Database db = await database;
    await db.delete(
      'dogs',
      where: 'id = ? ',
      whereArgs: [id],
    );
  }

  Future<List<Dog>> dogs() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(
      maps.length,
      (i) => Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      ),
    );
  }
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
