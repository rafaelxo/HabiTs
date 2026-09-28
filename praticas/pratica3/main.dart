import 'package:flutter/material.dart';

void main() => runApp(const MyDiaryApp());

class Habit {
  final String name;
  final String goal;
  final IconData icon;

  const Habit(this.name, this.goal, this.icon);
}

const initialHabits = [
  Habit('Beber água', 'Meta: 8 copos por dia', Icons.local_drink),
  Habit('Ler', 'Meta: 20 páginas por dia', Icons.menu_book),
  Habit('Caminhar', 'Meta: 30 minutos por dia', Icons.directions_walk),
  Habit('Dormir cedo', 'Meta: antes das 23h', Icons.bedtime),
  Habit('Estudar programação', 'Meta: 2 horas por dia', Icons.computer),
];

Future<List<Habit>> fetchHabits() async {
  try {
    await Future.delayed(const Duration(seconds: 2));
    return initialHabits;
  } catch (e) {
    throw Exception('Erro ao carregar hábitos: $e');
  }
}

class DisplayHabits extends StatefulWidget {
  const DisplayHabits({super.key, required this.futureHabits});

  final Future<List<Habit>> futureHabits;

  @override
  State<DisplayHabits> createState() => _DisplayHabitsState();
}

class _DisplayHabitsState extends State<DisplayHabits> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();

  List<Habit> _habits = [];
  bool _isLoading = true;
  bool _mostrarFormulario = false;

  @override
  void initState() {
    super.initState();
    widget.futureHabits
        .then((loadedHabits) {
          setState(() {
            _habits = List.from(loadedHabits);
            _isLoading = false;
          });
        })
        .catchError((_) {
          setState(() {
            _isLoading = false;
          });
        });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _addHabit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _habits.add(
          Habit(
            _nameController.text.trim(),
            'Meta: ${_goalController.text.trim()}',
            Icons.star,
          ),
        );
        _mostrarFormulario = false;
      });
      _nameController.clear();
      _goalController.clear();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Meus Hábitos'),
      actions: [
        IconButton(
          icon: Icon(_mostrarFormulario ? Icons.close : Icons.add),
          onPressed: () {
            setState(() {
              _mostrarFormulario = !_mostrarFormulario;
            });
          },
        ),
      ],
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              if (_mostrarFormulario) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome do hábito',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe o nome';
                            }
                            if (value.trim().length < 3) {
                              return 'Use ao menos 3 letras';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _goalController,
                          decoration: const InputDecoration(
                            labelText: 'Meta diária',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe a meta';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _addHabit,
                          child: const Text('Adicionar'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
              ],
              Expanded(
                child: _habits.isEmpty
                    ? const Center(child: Text('Nenhum hábito cadastrado'))
                    : ListView.separated(
                        itemCount: _habits.length,
                        separatorBuilder: (context, i) =>
                            const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final h = _habits[i];
                          return ListTile(
                            leading: Icon(h.icon),
                            title: Text(h.name),
                            subtitle: Text(h.goal),
                          );
                        },
                      ),
              ),
            ],
          ),
  );
}

class MyDiaryApp extends StatelessWidget {
  const MyDiaryApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Diário de Hábitos',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5276)),
      useMaterial3: true,
    ),
    home: DisplayHabits(futureHabits: fetchHabits()),
  );
}
