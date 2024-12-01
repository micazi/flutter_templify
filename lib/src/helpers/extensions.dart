import 'package:darted_cli/darted_cli.dart';

extension DartedFlagEX on DartedFlag {
  DartedFlag copyWith({
    String? name,
    String? abbreviation,
    bool? canBeNegated,
    bool? appliedByDefault,
  }) {
    return DartedFlag(
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      canBeNegated: canBeNegated ?? this.canBeNegated,
      appliedByDefault: appliedByDefault ?? this.appliedByDefault,
    );
  }
}
