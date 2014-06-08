import "dart:io";
import "dart:math";

import "base.dart";
import "translit.dart";

import "words_list.dart";
import "surnames_list.dart";
import "men_names_list.dart";
import "wimen_names_list.dart";
import "first_names_list.dart";
import "last_names_list.dart";
import "en_nouns_list.dart";
import "latin_words_list.dart";


void main(){
  save("nouns", words, ["м", "ж", "с", "мо"]);
  save("adjectives", words, ["п"]);
  save("verbs", words, ["св-нсв", "св", "нсв"]);
  save("surnames", surnames);
  save("men_names", men_names);
  save("wimen_names", wimen_names);
  save("first_names", first_names, null, false);
  save("last_names", last_names, null, false);
  save("en_nouns", en_nouns, null, false);
  save("latin_words", latin_words, null, false);
}

void save(String varName, List<String> words, [List<String> types = null
    , bool russian = true]){
  File file = new File(varName + "_data.dart");
  bool adjectives = (types == ["п"]);
  String text = "";
  List<String> wordList = new List<String>();
  for(String word in words) {

    if(types != null) {
      List<String> parts = word.split(" ");
      if(parts.length != 2) continue;
      if(!types.contains(parts[1])) continue;
      if(adjectives && parts[0][parts[0].length - 1] != "й") continue;
      if(parts[0].length < 3) continue;
      wordList.add(parts[0]);
      text += ",";
    } else {
      if(word.length >= 3) wordList.add(word);
    }
  }

  int k = max((1.0 * wordList.length / 3000.0).floor(), 1);
  List<String> newWordList = new List<String>();
  int q = -1;
  for(String word in wordList){
    q++;
    if(q % k != 0) continue;
    if(newWordList.contains(word)) continue;
    newWordList.add(word);
  }

  text = (new Base.fromWordList(newWordList)).toText();
  if(russian) text = rusToEng(text);

  text = "import 'base.dart';\r\n" + (russian ? "import 'translit.dart';\r\n"
      : "") + "Base " + varName + " = new Base(" + (russian ? "engToRus(" : "")
      + "'" + text + "'" + (russian ? ")" : "") + ");";
  file.writeAsString(text);
}