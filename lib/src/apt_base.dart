import 'dart:async';

import 'package:dbus/dbus.dart';

const kAptInterface = 'org.debian.apt';
const kAptPath = '/org/debian/apt';
const kPropAutoUpdateInterval = 'AutoUpdateInterval';
const kPropAutoDownload = 'AutoDownload';
const kPropAutoCleanInterval = 'AutoCleanInterval';
const kPropUnattendedUpgrade = 'UnattendedUpgrade';
const kPropPopConParticipation = 'PopConParticipation';
const kPropRebootRequired = 'RebootRequired';

class AptService {
  AptService() : _object = _createObject();

  final DBusRemoteObject _object;
  StreamSubscription<DBusPropertiesChangedSignal>? _propertyListener;

  static DBusRemoteObject _createObject() {
    return DBusRemoteObject(
      DBusClient.system(),
      name: kAptInterface,
      path: DBusObjectPath(kAptPath),
    );
  }

  Future<void> init() async {
    _autoUpdateInterval = await _object.getAutoCleanInterval();
    _autoDownload = await _object.getAutoDownload();
    _autoCleanInterval = await _object.getAutoCleanInterval();
    _unattendedUpgrade = await _object.getUnattendedUpgrade();
    _popConParticipation = await _object.getPopConParticipation();
    _rebootRequired = await _object.getRebootRequired();
    _propertyListener ??= _object.propertiesChanged.listen(_updateProperties);
  }

  Future<void> dispose() async {
    await _propertyListener?.cancel();
    await _object.client.close();
    _propertyListener = null;
  }

  void _updateProperties(DBusPropertiesChangedSignal signal) {
    if (signal.autoUpdateIntervalChanged) {
      _object.getAutoUpdateInterval().then(_updateAutoInterval);
    }
    if (signal.autoDownloadChanged) {
      _object.getAutoDownload().then(_updateAutoDownload);
    }
    if (signal.autoCleanInterval) {
      _object.getAutoCleanInterval().then(_updateAutoCleanInterval);
    }
    if (signal.unattendedUpgradeChanged) {
      _object.getUnattendedUpgrade().then(_updateUnattendedUpgrade);
    }
    if (signal.popConParticipationChanged) {
      _object.getPopConParticipation().then(_updatePopConParticipation);
    }
    if (signal.rebootRequiredChanged) {
      _object.getRebootRequired().then(_updateRebootRequired);
    }
  }

  int? _autoUpdateInterval;
  int? get autoUpdateInterval => _autoUpdateInterval;
  final _autoUpdateIntervalController = StreamController<int>.broadcast();
  Stream<int> get autoUpdateIntervalChanged =>
      _autoUpdateIntervalController.stream;
  void _updateAutoInterval(int? value) {
    if (value == null) return;
    _autoUpdateInterval = value;
    _autoUpdateIntervalController.add(value);
  }

  bool? _autoDownload;
  bool? get autoDownload => _autoDownload;
  final _autoDownloadController = StreamController<bool>.broadcast();
  Stream<bool> get autoDownloadChanged => _autoDownloadController.stream;
  void _updateAutoDownload(bool? value) {
    if (value == null) return;
    _autoDownload = value;
    _autoDownloadController.add(value);
  }

  int? _autoCleanInterval;
  int? get autoCleanInterval => _autoCleanInterval;
  final _autoCleanIntervalController = StreamController<int>.broadcast();
  Stream<int> get autoCleanIntervalChanged =>
      _autoCleanIntervalController.stream;
  void _updateAutoCleanInterval(int? value) {
    if (value == null) return;
    _autoCleanInterval = value;
    _autoCleanIntervalController.add(value);
  }

  int? _unattendedUpgrade;
  int? get unattendedUpgrade => _unattendedUpgrade;
  final _unattendedUpgradeController = StreamController<int>.broadcast();
  Stream<int> get unattendedUpgradeChanged =>
      _unattendedUpgradeController.stream;
  void _updateUnattendedUpgrade(int? value) {
    if (value == null) return;
    _unattendedUpgrade = value;
    _unattendedUpgradeController.add(value);
  }

  bool? _popConParticipation;
  bool? get popConParticipation => _popConParticipation;
  final _popConParticipationController = StreamController<bool>.broadcast();
  Stream<bool> get popConParticipationChanged =>
      _popConParticipationController.stream;
  void _updatePopConParticipation(bool? value) {
    if (value == null) return;
    _popConParticipation = value;
    _popConParticipationController.add(value);
  }

  bool? _rebootRequired;
  bool? get rebootRequired => _rebootRequired;
  final _rebootRequiredController = StreamController<bool>.broadcast();
  Stream<bool> get rebootRequiredChanged =>
      _popConParticipationController.stream;
  void _updateRebootRequired(bool? value) {
    if (value == null) return;
    _rebootRequired = value;
    _rebootRequiredController.add(value);
  }

  /// Invokes org.debian.apt.FixIncompleteInstall()
  Future<String> fixIncompleteInstall({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callFixIncompleteInstall(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.FixBrokenDepends()
  Future<String> fixBrokenDepends({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callFixBrokenDepends(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.UpdateCache()
  Future<String> updateCache({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callUpdateCache(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.UpdateCachePartially()
  Future<String> updateCachePartially(
    String sourcesList, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callUpdateCachePartially(
        sourcesList,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.RemovePackages()
  Future<String> removePackages(
    List<String> packageNames, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callRemovePackages(
        packageNames,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.UpgradeSystem()
  Future<String> upgradeSystem(
    bool safeMode, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callUpgradeSystem(
        safeMode,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.CommitPackages()
  Future<String> callCommitPackages({
    List<String> install = const <String>[],
    List<String> reinstall = const <String>[],
    List<String> remove = const <String>[],
    List<String> purge = const <String>[],
    List<String> upgrade = const <String>[],
    List<String> downgrade = const <String>[],
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callCommitPackages(
        install,
        reinstall,
        remove,
        purge,
        upgrade,
        downgrade,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.InstallPackages()
  Future<String> installPackages(
    List<String> packageNames, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callInstallPackages(
        packageNames,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.UpgradePackages()
  Future<String> upgradePackages(
    List<String> packageNames, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callUpgradePackages(
        packageNames,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.AddVendorKeyFromKeyserver()
  Future<String> addVendorKeyFromKeyserver(
    String keyid,
    String keyserver, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callAddVendorKeyFromKeyserver(
        keyid,
        keyserver,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.AddVendorKeyFromFile()
  Future<String> addVendorKeyFromFile(
    String path, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callAddVendorKeyFromFile(
        path,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.RemoveVendorKey()
  Future<String> removeVendorKey(
    String fingerprint, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callRemoveVendorKey(
        fingerprint,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.InstallFile()
  Future<String> installFile(
    String path,
    bool force, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callInstallFile(
        path,
        force,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.Clean()
  Future<String> clean({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callClean(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.Reconfigure()
  Future<String> reconfigure({
    required List<String> packages,
    required String priority,
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callReconfigure(
        packages,
        priority,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.AddRepository()
  Future<String> addRepository({
    required String srcType,
    required String uri,
    required String dist,
    required List<String> comps,
    required String comment,
    required String sourcesfile,
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callAddRepository(
        srcType,
        uri,
        dist,
        comps,
        comment,
        sourcesfile,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.EnableDistroComponent()
  Future<String> enableDistroComponent(
    String component, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callEnableDistroComponent(
        component,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.GetTrustedVendorKeys()
  Future<List<String>> getTrustedVendorKeys({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callGetTrustedVendorKeys(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.GetActiveTransactions()
  Future<List<DBusValue>> getActiveTransactions({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callGetActiveTransactions(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.Quit()
  Future<void> quit({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callQuit(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.debian.apt.AddLicenseKey()
  Future<String> callAddLicenseKey(
    String pkgName,
    String jsonToken,
    String serverName, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callAddLicenseKey(
        pkgName,
        jsonToken,
        serverName,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );
}

extension _AptObject on DBusRemoteObject {
  /// Gets org.debian.apt.AutoUpdateInterval
  Future<int> getAutoUpdateInterval() async {
    var value = await getProperty(
      kAptInterface,
      kPropAutoUpdateInterval,
      signature: DBusSignature('i'),
    );
    return value.asInt32();
  }

  /// Gets org.debian.apt.AutoDownload
  Future<bool> getAutoDownload() async {
    var value = await getProperty(
      kAptInterface,
      kPropAutoDownload,
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  /// Gets org.debian.apt.AutoCleanInterval
  Future<int> getAutoCleanInterval() async {
    var value = await getProperty(
      kAptInterface,
      kPropAutoCleanInterval,
      signature: DBusSignature('i'),
    );
    return value.asInt32();
  }

  /// Gets org.debian.apt.UnattendedUpgrade
  Future<int> getUnattendedUpgrade() async {
    var value = await getProperty(
      kAptInterface,
      kPropUnattendedUpgrade,
      signature: DBusSignature('i'),
    );
    return value.asInt32();
  }

  /// Gets org.debian.apt.PopConParticipation
  Future<bool> getPopConParticipation() async {
    var value = await getProperty(
      kAptInterface,
      kPropPopConParticipation,
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  /// Gets org.debian.apt.RebootRequired
  Future<bool> getRebootRequired() async {
    var value = await getProperty(
      kAptInterface,
      kPropRebootRequired,
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  /// Invokes org.debian.apt.FixIncompleteInstall()
  Future<String> callFixIncompleteInstall({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'FixIncompleteInstall',
      [],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.FixBrokenDepends()
  Future<String> callFixBrokenDepends({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'FixBrokenDepends',
      [],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.UpdateCache()
  Future<String> callUpdateCache({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'UpdateCache',
      [],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.UpdateCachePartially()
  Future<String> callUpdateCachePartially(
    String sourcesList, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'UpdateCachePartially',
      [DBusString(sourcesList)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.RemovePackages()
  Future<String> callRemovePackages(
    List<String> packageNames, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'RemovePackages',
      [DBusArray.string(packageNames)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.UpgradeSystem()
  Future<String> callUpgradeSystem(
    bool safeMode, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'UpgradeSystem',
      [DBusBoolean(safeMode)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.CommitPackages()
  Future<String> callCommitPackages(
    List<String> install,
    List<String> reinstall,
    List<String> remove,
    List<String> purge,
    List<String> upgrade,
    List<String> downgrade, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'CommitPackages',
      [
        DBusArray.string(install),
        DBusArray.string(reinstall),
        DBusArray.string(remove),
        DBusArray.string(purge),
        DBusArray.string(upgrade),
        DBusArray.string(downgrade)
      ],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.InstallPackages()
  Future<String> callInstallPackages(
    List<String> packageNames, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'InstallPackages',
      [DBusArray.string(packageNames)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.UpgradePackages()
  Future<String> callUpgradePackages(
    List<String> packageNames, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'UpgradePackages',
      [DBusArray.string(packageNames)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.AddVendorKeyFromKeyserver()
  Future<String> callAddVendorKeyFromKeyserver(
    String keyid,
    String keyserver, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'AddVendorKeyFromKeyserver',
      [DBusString(keyid), DBusString(keyserver)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.AddVendorKeyFromFile()
  Future<String> callAddVendorKeyFromFile(
    String path, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'AddVendorKeyFromFile',
      [DBusString(path)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.RemoveVendorKey()
  Future<String> callRemoveVendorKey(
    String fingerprint, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'RemoveVendorKey',
      [DBusString(fingerprint)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.InstallFile()
  Future<String> callInstallFile(
    String path,
    bool force, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'InstallFile',
      [DBusString(path), DBusBoolean(force)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.Clean()
  Future<String> callClean({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'Clean',
      [],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.Reconfigure()
  Future<String> callReconfigure(
    List<String> packages,
    String priority, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'Reconfigure',
      [DBusArray.string(packages), DBusString(priority)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.AddRepository()
  Future<String> callAddRepository(
    String srcType,
    String uri,
    String dist,
    List<String> comps,
    String comment,
    String sourcesfile, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'AddRepository',
      [
        DBusString(srcType),
        DBusString(uri),
        DBusString(dist),
        DBusArray.string(comps),
        DBusString(comment),
        DBusString(sourcesfile)
      ],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.EnableDistroComponent()
  Future<String> callEnableDistroComponent(
    String component, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'EnableDistroComponent',
      [DBusString(component)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.debian.apt.GetTrustedVendorKeys()
  Future<List<String>> callGetTrustedVendorKeys({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'GetTrustedVendorKeys',
      [],
      replySignature: DBusSignature('as'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asStringArray().toList();
  }

  /// Invokes org.debian.apt.GetActiveTransactions()
  Future<List<DBusValue>> callGetActiveTransactions({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'GetActiveTransactions',
      [],
      replySignature: DBusSignature('sas'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues;
  }

  /// Invokes org.debian.apt.Quit()
  Future<void> callQuit({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      kAptInterface,
      'Quit',
      [],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.debian.apt.AddLicenseKey()
  Future<String> callAddLicenseKey(
    String pkgName,
    String jsonToken,
    String serverName, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kAptInterface,
      'AddLicenseKey',
      [DBusString(pkgName), DBusString(jsonToken), DBusString(serverName)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }
}

extension _AptChangedSignal on DBusPropertiesChangedSignal {
  bool get autoUpdateIntervalChanged =>
      changedProperties.containsKey(kPropAutoUpdateInterval);

  bool get autoCleanInterval =>
      changedProperties.containsKey(kPropAutoCleanInterval);

  bool get autoDownloadChanged =>
      changedProperties.containsKey(kPropAutoDownload);

  bool get unattendedUpgradeChanged =>
      changedProperties.containsKey(kPropUnattendedUpgrade);

  bool get popConParticipationChanged =>
      changedProperties.containsKey(kPropPopConParticipation);

  bool get rebootRequiredChanged =>
      changedProperties.containsKey(kPropRebootRequired);
}
