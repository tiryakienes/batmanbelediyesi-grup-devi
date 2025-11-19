class MeclisDecision {
  final String title;
  final String url;

  MeclisDecision({
    required this.title,
    required this.url,
  });
}

class MeclisDecisionYear {
  final String year;
  final List<MeclisDecision> decisions;

  MeclisDecisionYear({
    required this.year,
    required this.decisions,
  });
}

