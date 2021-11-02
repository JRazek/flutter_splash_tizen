import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:xml/xml.dart';
import 'package:image/image.dart' as img;

Map? loadYamlFileSync(String path) {
  File file = File(path);
  if (file.existsSync() == true) {
    return loadYaml(file.readAsStringSync());
  }
  return null;
}

XmlDocument loadXMLFileSync(String path) {
  File file = File(path);
  if (file.existsSync() == true) {
    return XmlDocument.parse(file.readAsStringSync());
  }
  throw FormatException("could not read $path");
}

void writeToFileSync(String path, String data) {
  File file = File(path);
  if (file.existsSync() == true) {
    file.writeAsStringSync(data);
  } else {
    throw FormatException("could not write to $path");
  }
}

void main() {
  var doc = loadYamlFileSync("pubspec.yaml")?['flutter_native_splash'];
  String color = doc["color"] ?? ""; //[TODO] generation of image in this color?
  String image = doc["image"] ?? "";
  bool tizenFlag = doc["tizen"] ?? false;
  if (!tizenFlag) return;

  String tizenManifestPath = "tizen/tizen-manifest.xml";

  XmlDocument tizenManifest = loadXMLFileSync(tizenManifestPath);
  XmlNode el = tizenManifest.root;

  XmlElement? splashScreens = el
      .getElement("manifest")
      ?.getElement("ui-application")
      ?.getElement("splash-screens");
  if (splashScreens == null) {
    throw FormatException("error when reading $tizenManifestPath");
  }
  splashScreens.children.clear();
  XmlElement splashScreen = XmlElement(XmlName("splash-screen"));
  splashScreen.children.clear();
  splashScreen.setAttribute("src", image);
  splashScreen.setAttribute("type", "img");
  splashScreen.setAttribute("indicator-display", "true");
  splashScreen.setAttribute("app-control-operation", "true");
  splashScreen.setAttribute("orientation", "portrait");
  splashScreens.children.add(splashScreen);

  writeToFileSync(tizenManifestPath, el.toXmlString());
  // print(el.children);
  // print(el.toXmlString());
}
