class MusicModel {
  late String songPiece;
  late String docId;
  late String title;
  late String category;
  late String artist;
  late String like;
  late String count;
  late String desc;
  late String mainInstrument;
  late String otherInstrument;
  late String tempo;
  late String url;

  MusicModel({
    this.songPiece = "",
    this.docId = "",
    this.title = "",
    this.like = "",
    this.count = "",
    this.desc = "",
    this.category = "",
    this.artist = "",
    this.mainInstrument = "",
    this.otherInstrument = "",
    this.tempo = "",
    this.url = "",
  });

  MusicModel.clone(MusicModel music)
      : this(
          songPiece: music.songPiece,
          docId: music.docId,
          title: music.title,
          category: music.category,
          artist: music.artist,
          like: music.like,
          count: music.count,
          desc: music.desc,
          mainInstrument: music.mainInstrument,
          otherInstrument: music.otherInstrument,
          tempo: music.tempo,
          url: music.url,
        );

  MusicModel.fromJson(Map<String, dynamic> json, String docId)
      : songPiece = json["Song/Piece"] as String,
        docId = docId,
        title = json["title"] as String,
        like = json["like"] as String,
        count = json["count"] as String,
        desc = json["desc"] as String,
        category = json["Genre"] as String,
        artist = json["Composer/Artist"] as String,
        mainInstrument = json["Main Instrument"] as String,
        otherInstrument = json["Other Instrument"] as String,
        tempo = json["Tempo (BPM)"] as String,
        url = json["url"] as String;

  Map<String, dynamic> toMap() {
    return {
      "songPiece": this.songPiece,
      "docId": this.docId,
      "title": this.title,
      "category": this.category,
      "artist": this.artist,
      "like": this.like,
      "count": this.count,
      "desc": this.desc,
      "mainInstrument": this.mainInstrument,
      "otherInstrument": this.otherInstrument,
      "url": this.url,
    };
  }
}
