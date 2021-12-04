class NoteModel{
  String title;
  String content;

  NoteModel({
    required this.title,
    required this.content,
  });

  Map<String,dynamic> toMap(){
    return {
      "title":title,
      "content":content,
    };
  }
}