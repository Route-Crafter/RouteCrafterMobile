class Zone{
  final int id;
  final String name;
  const Zone({
    required this.id,
    required this.name
  });
}

final class Country extends Zone{
  final String iso;
  const Country({
    required super.id,
    required super.name,
    required this.iso
  });
}
