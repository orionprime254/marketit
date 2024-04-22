class Good {
  String title;
  String briefDescription;
  String Price;
  String imagePath;
 // String description;

  Good({
    required this.Price,
    required this.briefDescription,
    required this.title,
    required this.imagePath
   // required this.description
});
  String get _title =>title;
  String get _briefDescription =>briefDescription;
  String get _Price =>Price;
  String get _imagePath =>imagePath;
 // String get _description =>description;
}