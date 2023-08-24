
/// A mentionable object.
abstract class Mentionable {
  /// default constructor.
  const Mentionable();

  String get fullMentionLabel => '@$mentionLabel';

  /// Text that will be input after @ character in
  /// [TextField] to show mention.
  String get mentionLabel;
  String get mentionPhoto;

  /// Way to render mention as a String in
  /// the TextField final result.
  String buildMention() => fullMentionLabel;

  /// Return true when [search] match the mentionable.
  bool match(String search) =>
      fullMentionLabel.toLowerCase().contains(search.toLowerCase());


}
