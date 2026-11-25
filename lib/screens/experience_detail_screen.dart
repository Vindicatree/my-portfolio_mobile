import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatelessWidget {
  const ExperienceDetailScreen({super.key, required this.experience});
  final Experience experience;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(experience.title)),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (experience.thumbnail.isNotEmpty)
          Image.network(
            experience.thumbnail,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        Text(
          experience.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text('Kategori: ${experience.category}'),
        Text(
          'Mulai: ${experience.startedAt?.toLocal().toString().split(' ').first ?? '-'}',
        ),
        Text(
          'Selesai: ${experience.endedAt?.toLocal().toString().split(' ').first ?? 'Berlangsung'}',
        ),
        const SizedBox(height: 12),
        Text(experience.description),
      ],
    ),
  );
}
