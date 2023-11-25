import 'package:flutter/material.dart';

class Saran extends StatefulWidget {
  const Saran({Key? key}) : super(key: key);

  @override
  _SaranState createState() => _SaranState();
}

class _SaranState extends State<Saran> {
  int selectedCard = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Kesan & Saran",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCard(
                cardIndex: 1,
                title: 'Kesan',
                content: 'Salah satu matkul terseru hingga selalu '
                    'deg-degan setiap ada tugas.\n\nIstilahnya memacu '
                    'adrenalin saya dan teman-teman sebagai mahasiswa. '
                    'Namun, tidak dipungkiri, saya senang mendapat banyak '
                    'ilmu dan pengetahuan baru yang bermanfaat',
                icon: Icons.sentiment_satisfied,
              ),
              _buildCard(
                cardIndex: 2,
                title: 'Saran',
                content: 'Saya rasa akan lebih seru kalau materi belajar '
                    'juga sama banyak dengan lingkup tugas yang diberikan. '
                    'Namun, saya paham bahwa teman-teman dan pak Bagus '
                    'memiliki keterbatasan waktu yang harus diluangkan, '
                    '\n\njadi saya harap kita bisa lebih saling menghargai '
                    'dan mempertimbangkan waktu orang lain',
                icon: Icons.thumb_up_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required int cardIndex,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          selectedCard = cardIndex;
        });
      },
      onExit: (_) {
        setState(() {
          selectedCard = 0;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: selectedCard == cardIndex ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 40.0,
              ),
              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
