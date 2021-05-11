
import 'dart:typed_data';

class ContactSaved {
  String displayName;

  ContactSaved( this.displayName);


  static Map<String, dynamic> toMap(ContactSaved contactSaved) => {
    'displayName': contactSaved.displayName

  };

  Map<String, dynamic> toJson() => {
    ' displayName':  displayName,


  };

  ContactSaved.fromJson(Map<String, dynamic> json)
      :displayName = json['displayName'];
  
  
}


