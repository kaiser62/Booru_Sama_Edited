class AutocompleteDto {
  AutocompleteDto({
    this.id,
    this.name,
    this.postCount,
    this.category,
    this.antecedentName,
  });

  factory AutocompleteDto.fromJson(Map<String, dynamic> json) {
    return AutocompleteDto(
      id: json['id'],
      name: json['name'],
      postCount: json['post_count'],
      category: json['category'],
      antecedentName: json['antecedent_name'],
    );
  }

  final int? id;
  final String? name;
  final int? postCount;
  final int? category;
  final String? antecedentName;

  @override
  String toString() => name ?? '';
}
