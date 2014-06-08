List<List<String>> transList = [["а", "a"], ["б", "b"], ["в", "w"]
  , ["г", "g"], ["д", "d"], ["е", "e"], ["ё", "*"], ["ж", "v"], ["з", "z"]
  , ["и", "i"], ["й", "j"], ["к", "k"], ["л", "l"], ["м", "m"], ["н", "n"]
  , ["о", "o"], ["п", "p"], ["р", "r"], ["с", "s"], ["т", "t"]
  , ["у", "u"], ["ф", "f"], ["х", "h"], ["ц", "c"], ["ч", "^"], ["ш", "%"]
  , ["щ", "&"], ["ъ", "+"], ["ы", "y"], ["ь", "x"], ["э", "@"], ["ю", "/"]
  , ["я", "q"]];

String rusToEng(String text) {
  for(List<String> list in transList) {
    text = text.replaceAll(list[0], list[1]);
  }
  return text;
}

String engToRus(String text) {
  for(List<String> list in transList) {
    text = text.replaceAll(list[1], list[0]);
  }
  return text;
}
