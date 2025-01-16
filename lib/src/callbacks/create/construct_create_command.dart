String constructCreateCommand(
    {required bool isPackage,
    required List<String> platforms,
    required String projectName,
    String? domain}) {
  // Construct the platforms arguments
  String p = '';
  if (platforms.isNotEmpty && !isPackage) {
    if (platforms.contains('android')) {
      p += '--platforms android ';
    }
    if (platforms.contains('ios')) {
      p += '--platforms ios ';
    }
    if (platforms.contains('web')) {
      p += '--platforms web ';
    }
    if (platforms.contains('windows')) {
      p += '--platforms windows ';
    }
    if (platforms.contains('linux')) {
      p += '--platforms linux ';
    }
    if (platforms.contains('macos')) {
      p += '--platforms macos ';
    }
  }

  // Construct & return the command...
  return 'create ${isPackage ? '-t package ' : ''} ${domain != null ? '--org ${domain.split('.').reversed.join('.')}' : ''} $p --project-name $projectName';
}
