import 'dart:async';
import 'dart:io';
import 'i_command.dart';

import '../structure_creators/pubspec/impl_pubspec_creator.dart';

class PubUpdaterCommand implements ICommand {
  @override
  Future<void> execute() async {
    ImplPubspecCreator pubspecCreator = ImplPubspecCreator();
    bool res = await pubspecCreator.getPackageVersion();

    if (res) {
      await pubspecCreator.writeDependencies();
    } else {
      stderr.writeln("Can't get package versions");
    }
  }
}
