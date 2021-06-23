class UserModelClass {
  final  id;
  final  name;
  final  email;
  late final  isOnline;
  final imageUrl;

  UserModelClass({
    required this.id,
    required this.name,
    required this.email,
    required this.isOnline,
    this.imageUrl,
  });

  factory UserModelClass.fromJson(final json){
    return UserModelClass(
        id: json!["id"],
        name:json["name"],
        isOnline: json["status"],
        imageUrl:json["image"],
        email : json["email"]
    );

  }

    Map<String,dynamic> toJson(){
    return {
      "id" : id,
      "name" : name,
      "status": isOnline,
      "email" : email,
      "image" : imageUrl

    };


   }
  }
