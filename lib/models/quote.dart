class Quote {
  String quote;
  String author;

  Quote(this.quote, this.author);

  factory Quote.fromJson(dynamic json) {
    return Quote("${json['q']}", "${json['a']}");
  }

  Map toJson() => {'q': quote, 'a': author};
}
