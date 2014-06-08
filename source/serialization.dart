library serialization;

import "symbols.dart";


class Serialization {

}

abstract class Structure {
  static String text;
  static int pos;
  static StringBuffer buffer = new StringBuffer("");

  static void init(String userText) {
    text = userText;
    pos = -1;
  }

  String toText(value);

  void _toText(value);

  fromText();
}


class IntStructure extends Structure {
  String toText(int value) {
    Structure.buffer.clear();
    _toText(value);
    return Structure.buffer.toString() + ",";
  }

  void _toText(int value) {
    if(value == null) {
      Structure.buffer.write("#");
    } else {
      Structure.buffer.write(value);
    }
  }

  int fromText() {
    String string = "";
    while(true) {
      Structure.pos++;
      switch(Structure.text.codeUnitAt(Structure.pos)) {
        case sharpCode:
          return null;
        case commaCode:
        case colonCode:
        case rightRoundBracketCode:
          return int.parse(string);
        default:
          string += Structure.text[Structure.pos];
      }
    }
  }
}


class DoubleStructure extends Structure {
  String toText(double value) {
    Structure.buffer.clear();
    _toText(value);
    return Structure.buffer.toString() + ",";
  }

  void _toText(double value) {
    if(value == null) {
      Structure.buffer.write("#");
    } else {
      Structure.buffer.write(value);
    }
  }

  double fromText() {
    String string = "";
    while(true) {
      Structure.pos++;
      switch(Structure.text.codeUnitAt(Structure.pos)) {
        case sharpCode:
          return null;
        case commaCode:
        case colonCode:
        case rightRoundBracketCode:
          return double.parse(string);
        default:
          string += Structure.text[Structure.pos];
      }
    }
  }
}


class FixedStringStructure extends Structure {
  int _length;

  String toText(String value) {
    Structure.buffer.clear();
    _toText(value);
    return Structure.buffer.toString() + ",";
  }

  void _toText(String value) {
    assert(value.length == _length);
    Structure.buffer.write(value);
  }

  String fromText() {
    Structure.pos++;
    String string
        = Structure.text.substring(Structure.pos, Structure.pos + _length);
    Structure.pos += _length;
    return string;
  }

  FixedStringStructure(this._length);
}


class StringStructure extends Structure {
  String toText(String value) {
    Structure.buffer.clear();
    _toText(value);
    return Structure.buffer.toString() + ",";
  }

  void _toText(String value) {
    if(value == null) {
      Structure.buffer.write("#");
    } else {
      Structure.buffer.write("\"" + value.toString() + "\"");
    }
  }

  String fromText() {
    String string = "";
    Structure.pos++;
    if(Structure.text.codeUnitAt(Structure.pos) == sharpCode) return null;
    while(true) {
      Structure.pos++;
      int symbol = Structure.text.codeUnitAt(Structure.pos);
      if(symbol == quotesCode) {
        Structure.pos++;
        return string;
      } else {
        string += Structure.text[Structure.pos];
      }
    }
  }
}


class ListStructure<E> extends Structure {
  Structure _entryStructure;

  ListStructure(this._entryStructure);

  String toText(List<E> list) {
    Structure.buffer.clear();
    _toText(list);
    return Structure.buffer.toString() + ",";
  }

  void _toText(List<E> list){
    if(list == null) {
      Structure.buffer.write("#");
      return;
    }

    Structure.buffer.write("(");
    bool first = true;
    list.forEach((entry) {
      if(!first) Structure.buffer.write(",");
      _entryStructure._toText(entry);
      first = false;
    });
    Structure.buffer.write(")");
  }

  List<E> fromText() {
    List list = new List<E>();

    Structure.pos++;
    if(Structure.text.codeUnitAt(Structure.pos) == sharpCode) {
      Structure.pos++;
      return null;
    }
    if(Structure.text.codeUnitAt(Structure.pos + 1) == rightRoundBracketCode) {
      Structure.pos +=2;
      return list;
    }

    while(true) {
      list.add(_entryStructure.fromText());
      if(Structure.text.codeUnitAt(Structure.pos) == rightRoundBracketCode) {
        Structure.pos++;
        return list;
      }
    }
  }
}

class MapStructure<K, V> extends Structure {
  Structure _keyStructure, _valueStructure;

  MapStructure(this._keyStructure, this._valueStructure);

  String toText(Map<K, V> map) {
    Structure.buffer.clear();
    _toText(map);
    return Structure.buffer.toString() + ",";
  }

  void _toText(Map<K, V> map){
    if(map == null) {
      Structure.buffer.write("#");
      return;
    }

    Structure.buffer.write("(");
    bool first = true;
    map.forEach((key, value) {
      if(!first) Structure.buffer.write(",");
      _keyStructure._toText(key);
      Structure.buffer.write(":");
      _valueStructure._toText(value);
      first = false;
    });
    Structure.buffer.write(")");
  }

  Map<K, V> fromText() {
    Map map = new Map<K, V>();

    Structure.pos++;
    if(Structure.text.codeUnitAt(Structure.pos) == sharpCode) {
      Structure.pos++;
      return null;
    }
    if(Structure.text.codeUnitAt(Structure.pos + 1) == rightRoundBracketCode) {
      Structure.pos +=2;
      return map;
    }

    while(true) {
      K key = _keyStructure.fromText();
      map[key] = _valueStructure.fromText();
      if(Structure.text.codeUnitAt(Structure.pos) == rightRoundBracketCode) {
        Structure.pos++;
        return map;
      }
    }
  }
}