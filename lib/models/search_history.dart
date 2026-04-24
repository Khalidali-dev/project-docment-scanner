import 'package:objectbox/objectbox.dart';

@Entity()
class SearchHistory {
  @Id(assignable: true)
  int id = 0;

  @Index()
  String query;

  @Index()
  DateTime searchedAt;

  int resultCount = 0;
  String resultType; // 'document', 'note', 'book', 'all'

  SearchHistory({
    required this.query,
    required this.resultType,
    DateTime? searchedAt,
    this.resultCount = 0,
  }) : searchedAt = searchedAt ?? DateTime.now();
}
