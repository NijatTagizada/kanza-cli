import 'dart:io';

import 'package:yaml/yaml.dart';

import '../../utils/yaml_writer.dart';
import '../../utils/yaml_map_converter.dart';
import '../../constants/constants_data.dart';
import '../../services/package_detail_service.dart';
import '../../model/package_detail.dart';
import '../i_creators.dart';

class ImplPubspecCreator implements IPubspecCreator {
  List<PackageDetail> solvedPackageList = [];

  @override
  Future<bool> getPackageVersion() async {
    try {
      stderr.writeln('Package Resolving...\n');

      for (String package in kPubPackageList) {
        PackageDetail? data = await PackageDetailService().getPackageDetail(
          packageName: package,
        );

        if (data != null) {
          stderr.writeln(data.toString());
          solvedPackageList.add(data);
        }
      }
      return true;
    } catch (e, s) {
      stderr.writeln(e);
      stderr.writeln(s);
      return false;
    }
  }

  @override
  Future<void> writeDependencies() async {
    stderr.writeln('\nWrite down dependencies...\n');

    // Get File
    var yamlFile = File('pubspec.yaml');

    // Convert to YamlMap
    String yamlStr = await yamlFile.readAsString();
    YamlMap yamlMap = loadYaml(yamlStr);

    // Convert to Map
    Map map = yamlMap.toMap();

    // Dependencies section
    Map dependenciesMap = map['dependencies'];
    solvedPackageList.forEach((package) {
      dependenciesMap[package.name] = package.latest.version;
    });

    // Write map in yaml
    final writer = YamlWriter();
    String writeString = writer.write(map);
    yamlFile.writeAsStringSync(writeString, mode: FileMode.write);
  }
}
