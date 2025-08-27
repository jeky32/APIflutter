import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const UniversityApp());

class UniversityApp extends StatelessWidget {
  const UniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Material 3 + custom color scheme
    final seed = const Color(0xFF6750A4); // ungu
    return MaterialApp(
      title: 'Daftar Universitas',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ),
      home: const UniversityListPage(),
    );
  }
}

class University {
  final String name;
  final String country;
  final String webPage;
  final String? stateProvince;

  University({
    required this.name,
    required this.country,
    required this.webPage,
    this.stateProvince,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      country: json['country'],
      stateProvince: json['state-province'],
      webPage: (json['web_pages'] as List).isNotEmpty ? json['web_pages'][0] : '',
    );
  }
}

class UniversityListPage extends StatefulWidget {
  const UniversityListPage({super.key});

  @override
  State<UniversityListPage> createState() => _UniversityListPageState();
}

class _UniversityListPageState extends State<UniversityListPage> {
  final TextEditingController _countryCtrl = TextEditingController(text: 'Indonesia');
  final TextEditingController _searchCtrl = TextEditingController();

  List<University> _universities = [];
  List<University> _filtered = [];
  bool _loading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchUniversities(_countryCtrl.text);
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _countryCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _universities.where((u) {
        final name = u.name.toLowerCase();
        final country = u.country.toLowerCase();
        final state = (u.stateProvince ?? '').toLowerCase();
        return name.contains(q) || country.contains(q) || state.contains(q);
      }).toList();
    });
  }

  Future<void> _fetchUniversities(String country) async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final url = Uri.parse('http://universities.hipolabs.com/search?country=$country');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final list = data.map((e) => University.fromJson(e)).toList().cast<University>();
        // sort by name
        list.sort((a, b) => a.name.compareTo(b.name));
        setState(() {
          _universities = list;
          _filtered = list;
        });
      } else {
        setState(() => _error = 'Gagal memuat data (code ${res.statusCode})');
      }
    } catch (e) {
      setState(() => _error = 'Terjadi kesalahan: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openWebsite(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Website tidak tersedia')));
      return;
    }
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak bisa membuka URL')));
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Universitas'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: Column(
        children: [
          // Filter bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countryCtrl,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      labelText: 'Negara (contoh: Indonesia)',
                      prefixIcon: Icon(Icons.public),
                    ),
                    onSubmitted: (v) => _fetchUniversities(v.trim().isEmpty ? 'Indonesia' : v.trim()),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _fetchUniversities(_countryCtrl.text.trim().isEmpty ? 'Indonesia' : _countryCtrl.text.trim()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Muat'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Cari universitas / negara / provinsi…',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          if (_loading) const LinearProgressIndicator(),

          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: cs.error),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error)),
                ],
              ),
            ),

          // List
          Expanded(
            child: _filtered.isEmpty && !_loading
                ? const Center(child: Text('Tidak ada data'))
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      final u = _filtered[i];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: cs.secondaryContainer,
                            foregroundColor: cs.onSecondaryContainer,
                            child: const Icon(Icons.school),
                          ),
                          title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                runSpacing: -6,
                                children: [
                                  Chip(
                                    label: Text(u.country),
                                    backgroundColor: cs.primaryContainer,
                                    labelStyle: TextStyle(color: cs.onPrimaryContainer),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  if ((u.stateProvince ?? '').isNotEmpty)
                                    Chip(
                                      label: Text(u.stateProvince!),
                                      backgroundColor: cs.tertiaryContainer,
                                      labelStyle: TextStyle(color: cs.onTertiaryContainer),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                            ],
                          ),
                          trailing: FilledButton.tonalIcon(
                            onPressed: () => _openWebsite(u.webPage),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Website'),
                          ),
                          onTap: () => _openWebsite(u.webPage),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
