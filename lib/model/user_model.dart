class UserModel {
  late String uid;
  late String docId;
  late String name;
  late String createdTime;
  late String lastLoginTime;
  late String birth;
  late String gender;
  late String listener;

  UserModel({
    this.uid = "",
    this.docId = "",
    this.name = "",
    this.birth = "",
    this.gender = "",
    this.createdTime = "",
    this.lastLoginTime = "",
    this.listener = "",
  });

  UserModel.clone(UserModel user)
      : this(
          uid: user.uid,
          docId: user.docId,
          name: user.name,
          createdTime: user.createdTime,
          lastLoginTime: user.lastLoginTime,
          birth: user.birth,
          gender: user.gender,
          listener: user.listener,
        );

  UserModel.fromJson(Map<String, dynamic> json, String docId)
      : uid = json["uid"] as String,
        docId = docId,
        name = json["name"] as String,
        birth = json["birth"] as String,
        gender = json["gender"] as String,
        createdTime = json["createdTime"] as String,
        lastLoginTime = json["lastLoginTime"] as String,
        listener = json["listner"] as String;

  Map<String, dynamic> toMap() {
    return {
      "uid": this.uid,
      "docId": this.docId,
      "name": this.name,
      "createdTime": this.createdTime,
      "lastLoginTime": this.lastLoginTime,
      "birth": this.birth,
      "gender": this.gender,
      "listener": this.listener,
    };
  }
}
