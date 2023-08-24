
import '../models/Mentionable.dart';

class MentionItem extends Mentionable{
  final String title;
  final String photo;
  const MentionItem({required this.title, required this.photo});

  @override
// TODO: implement mentionLabel
  String get mentionLabel => title;

  @override
  String get mentionPhoto => photo;
}