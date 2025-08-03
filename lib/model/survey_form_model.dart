class SurveyFormModel {
  String? formName;
  int? id;
  List<Sections>? sections;

  SurveyFormModel({this.formName, this.id, this.sections});

  SurveyFormModel.fromJson(Map<String, dynamic> json) {
    formName = json['formName'];
    id = json['id'];
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['formName'] = formName;
    data['id'] = id;
    if (sections != null) {
      data['sections'] = sections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sections {
  String? name;
  String? key;
  List<Fields>? fields;

  Sections({this.name, this.key, this.fields});

  Sections.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['key'] = key;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fields {
  int? id;
  String? key;
  Properties? properties;

  Fields({this.id, this.key, this.properties});

  Fields.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['key'] = key;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Properties {
  String? type;
  String? defaultValue;
  String? hintText;
  int? minLength;
  int? maxLength;
  String? label;
  String? listItems;
  bool? multiSelect;
  bool? multiImage;

  Properties({
    this.type,
    this.defaultValue,
    this.hintText,
    this.minLength,
    this.maxLength,
    this.label,
    this.listItems,
    this.multiSelect,
    this.multiImage,
  });

  Properties.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    defaultValue = json['defaultValue'];
    hintText = json['hintText'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    label = json['label'];
    listItems = json['listItems'];
    multiSelect = json['multiSelect'];
    multiImage = json['multiImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['defaultValue'] = defaultValue;
    data['hintText'] = hintText;
    data['minLength'] = minLength;
    data['maxLength'] = maxLength;
    data['label'] = label;
    data['listItems'] = listItems;
    data['multiSelect'] = multiSelect;
    data['multiImage'] = multiImage;
    return data;
  }
}