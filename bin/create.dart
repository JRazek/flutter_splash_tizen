import 'file_utils.dart';
import 'package:xml/xml.dart';

void main() {
  var doc = loadYamlFileSync("pubspec.yaml")?['flutter_splash_tizen'];
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
}
