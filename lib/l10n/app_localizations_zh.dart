// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get allpass => 'Allpass';

  @override
  String get appError => '出错了';

  @override
  String get appErrorHint1 => 'App出现错误，快去反馈给作者!';

  @override
  String get appErrorHint2 => '以下是出错信息，请截图发到邮箱sys6511@126.com';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '未启用';

  @override
  String get unlock => '解锁';

  @override
  String get unlockAllpass => '解锁 Allpass';

  @override
  String get pleaseInputMainPassword => '请输入主密码';

  @override
  String get useBiometrics => '使用生物识别';

  @override
  String get notEnableBiometricsYet => '您还未开启生物识别';

  @override
  String lockingRemains(int lockSeconds) {
    return '锁定中，还剩$lockSeconds秒';
  }

  @override
  String get errorExceedThreshold => '连续错误超过五次，锁定30秒';

  @override
  String get clickToUseBiometrics => '点击此处使用指纹解锁';

  @override
  String get usePassword => '使用密码';

  @override
  String get inputMainPasswordTimingHint => 'Allpass 会定期要求输入主密码以防止您忘记主密码';

  @override
  String get verificationSuccess => '验证成功';

  @override
  String get mainPasswordErrorHint => '您似乎忘记了主密码';

  @override
  String get biometricsRecognizedFailed => '识别失败，请重试';

  @override
  String get pleaseInputMainPasswordFirst => '请先输入应用主密码';

  @override
  String get unlockSuccess => '解锁成功';

  @override
  String mainPasswordError(int inputErrorTimes) {
    return '主密码错误，已错误$inputErrorTimes次，连续超过五次将锁定30秒';
  }

  @override
  String get notSetupYet => '还未设置过Allpass，请先进行设置';

  @override
  String get appHasForceLock => '应用已锁定，请使用密码解锁';

  @override
  String get setupAllpass => '设置 Allpass';

  @override
  String get pleaseInputAgain => '请再输入一遍';

  @override
  String get setup => '设置';

  @override
  String get passwordNotSame => '两次密码输入不一致！';

  @override
  String get passwordTooShort => '主密码长度必须大于等于6！';

  @override
  String get setupSuccess => '设置成功';

  @override
  String get alreadySetup => '已有账号注册过，只允许单账号';

  @override
  String get serviceTerms => '服务条款';

  @override
  String get confirmServiceTerms => '同意并继续';

  @override
  String get cancel => '取消';

  @override
  String get password => '密码';

  @override
  String get passwords => '密码';

  @override
  String get addPasswordItem => '添加密码条目';

  @override
  String get passwordEmptyHint => '这里存储你的密码信息，例如\n微博账号、知乎账号等';

  @override
  String get selectOnePasswordAtLeast => '请选择至少一项密码';

  @override
  String get confirmDelete => '确认删除';

  @override
  String deletePasswordsWarning(int count) {
    return '您将删除 $count 项密码，是否继续？';
  }

  @override
  String deletePasswordsSuccess(int count) {
    return '已删除 $count 项密码';
  }

  @override
  String movePasswordsSuccess(int count, String folder) {
    return '已移动 $count 项密码至 $folder 文件夹';
  }

  @override
  String searchButton(String type) {
    return '搜索$type';
  }

  @override
  String get emptyDataHint => '什么也没有，赶快添加吧';

  @override
  String get delete => '删除';

  @override
  String get move => '移动';

  @override
  String get card => '卡片';

  @override
  String get cards => '卡片';

  @override
  String get addCardItem => '添加卡片条目';

  @override
  String get cardEmptyHint => '这里存储你的卡片信息，例如\n身份证，银行卡或贵宾卡等';

  @override
  String get selectOneCardAtLeast => '请选择至少一项卡片';

  @override
  String deleteCardsWarning(int count) {
    return '您将删除 $count 项卡片，是否继续？';
  }

  @override
  String deleteCardsSuccess(int count) {
    return '已删除 $count 项卡片';
  }

  @override
  String moveCardsSuccess(int count, String folder) {
    return '已移动 $count 项卡片至 $folder 文件夹';
  }

  @override
  String get unknownErrorOccur => '出现了错误';

  @override
  String get account => '账号';

  @override
  String get copy => '复制';

  @override
  String get accountCopied => '已复制账号';

  @override
  String get passwordCopied => '已复制密码';

  @override
  String get url => '链接';

  @override
  String get urlCopied => '已复制链接';

  @override
  String get ownerApp => '所属App';

  @override
  String get openAppFailed => '打开App失败，请确保App已安装';

  @override
  String get notes => '备注';

  @override
  String get emptyNotes => '无备注';

  @override
  String get label => '标签';

  @override
  String get labels => '标签';

  @override
  String accountPassword(String account, String password) {
    return '账号: $account\n密码: $password';
  }

  @override
  String get accountPasswordCopied => '已复制账号和密码';

  @override
  String get deletePasswordWaring => '你将永久删除此密码，是否继续？';

  @override
  String get deleteSuccess => '删除成功';

  @override
  String get viewPassword => '查看密码';

  @override
  String get emptyLabel => '无标签';

  @override
  String get none => '无';

  @override
  String get viewCard => '查看卡片';

  @override
  String get ownerName => '拥有者姓名';

  @override
  String get nameCopied => '已复制姓名';

  @override
  String get cardId => '卡号';

  @override
  String get cardIdCopied => '已复制卡号';

  @override
  String get phoneNumber => '绑定手机号';

  @override
  String get phoneNumberCopied => '已复制手机号';

  @override
  String get deleteCardWarning => '您将永久删除此卡片，是否继续？';

  @override
  String get createPassword => '新增密码';

  @override
  String get updatePassword => '编辑密码';

  @override
  String get createSuccess => '新增成功';

  @override
  String get updateSuccess => '更新成功';

  @override
  String get upsertPasswordRule => '名称、用户名和密码不允许为空！';

  @override
  String get name => '名称';

  @override
  String get folder => '文件夹';

  @override
  String get folderTitle => '文件夹';

  @override
  String createLabelSuccess(String tag) {
    return '创建标签 $tag 成功';
  }

  @override
  String labelAlreadyExists(String tag) {
    return '标签 $tag 已存在';
  }

  @override
  String get setToNone => '设置为空';

  @override
  String get addNotes => '添加备注';

  @override
  String get passwordGenerator => '密码生成器';

  @override
  String get symbols => '特殊符号';

  @override
  String get generate => '生成';

  @override
  String get pleaseSelectOneItemAtLeast => '请至少选择一项';

  @override
  String get close => '关闭';

  @override
  String get createCard => '新增卡片';

  @override
  String get updateCard => '编辑卡片';

  @override
  String get cardPasswordEmptyAutoGen => '未输入密码，自动初始化为 00000';

  @override
  String get upsertCardRule => '拥有者姓名和卡号不允许为空';

  @override
  String get settings => '设置';

  @override
  String get mainPasswordManager => '主密码管理';

  @override
  String get biometricAuthentication => '生物识别';

  @override
  String get enableBiometricSuccess => '已开启生物识别';

  @override
  String get disableBiometricSuccess => '已关闭生物识别';

  @override
  String get biometricNotAvailable => '生物识别不可用，请去系统设置中启用并重试';

  @override
  String get authorizationFailed => '授权失败';

  @override
  String get biometricNotSupport => '您的设备似乎不支持生物识别';

  @override
  String get autoLock => '自动锁定';

  @override
  String get autoLockDialogTitle => '切到后台后锁定应用';

  @override
  String get autoLockImmediate => '立刻';

  @override
  String get autoLock30s => '30秒后';

  @override
  String get autoLockDisable => '禁用';

  @override
  String get longPressToCopy => '长按复制密码或卡号';

  @override
  String get appTheme => '主题颜色';

  @override
  String get labelManager => '标签管理';

  @override
  String get folderManager => '文件夹管理';

  @override
  String get webDavSync => 'WebDAV同步';

  @override
  String get importExport => '导入/导出';

  @override
  String get autofill => '自动填充';

  @override
  String get shareToFriends => '推荐给好友';

  @override
  String get feedback => '意见反馈';

  @override
  String get checkUpdate => '检查更新';

  @override
  String get about => '关于';

  @override
  String shareAllpassDesc(String downloadUrl) {
    return '【Allpass】一款简洁好用的私密信息管理工具。【下载地址】$downloadUrl';
  }

  @override
  String get shareAllpassSubject => '软件推荐 —— Allpass';

  @override
  String get pleaseSelect => '请选择';

  @override
  String get authorizeToUnlock => '授权以解锁 Allpass';

  @override
  String get gotoSettings => '去设置';

  @override
  String get iosGoToSettingsDescFace => 'Face ID 暂未启用，请去设置中开启 Face ID 后重试';

  @override
  String get iosGoToSettingsDescFingerprint => '指纹解锁暂未启用，请去设置中开启指纹解锁后重试';

  @override
  String get iosGoToSettingsDescIris => '生物识别暂未启用，请去设置中开启后重试';

  @override
  String get iosGoToSettingsDescDefault =>
      '生物识别授权暂未启用，请去设置中开启 Touch ID 或 Face ID 后重试';

  @override
  String get iosLogoutFace => 'Face ID 被禁用，请锁屏后再解锁以启用Face ID';

  @override
  String get iosLogoutFingerprint => 'Touch ID 被禁用，请锁屏后再解锁以启用 Touch ID';

  @override
  String get iosLogoutIris => '生物识别被禁用，请锁屏后再解锁以启用生物识别';

  @override
  String get androidGoToSettingsDesc => '指纹解锁暂未启用，请去设置中开启指纹解锁后重试';

  @override
  String get biometricRequiredTitle => '暂未开启生物识别';

  @override
  String get signInTitle => '请验证';

  @override
  String get biometricHint => '使用指纹解锁';

  @override
  String get modifyMainPassword => '修改主密码';

  @override
  String get inputMainPasswordTiming => '定期输入主密码';

  @override
  String get secretKeyUpdate => '更新加密密钥';

  @override
  String get clearAllData => '清除所有数据';

  @override
  String get lockAllpass => '锁定 Allpass';

  @override
  String get never => '永不';

  @override
  String get sevenDays => '7 天';

  @override
  String get tenDays => '10 天';

  @override
  String get fifteenDays => '15 天';

  @override
  String get thirtyDays => '30 天';

  @override
  String nDays(int n) {
    return '$n 天';
  }

  @override
  String get confirmSelect => '确认选择';

  @override
  String get selectNeverWarning => '选择此项后，Allpass将不再定期要求您输入主密码，请妥善保管好主密码';

  @override
  String get confirmClearAll => '确认清除';

  @override
  String get clearAllWaring => '此操作将删除所有数据并无法恢复，是否继续？';

  @override
  String get clearAllSuccess => '已删除所有数据';

  @override
  String get mainPasswordIncorrect => '密码错误';

  @override
  String get oldPassword => '原密码';

  @override
  String get newPassword => '新密码';

  @override
  String get pleaseInputOldPassword => '请输入原密码';

  @override
  String get pleaseInputNewPassword => '请输入新密码';

  @override
  String get modifySuccess => '修改成功';

  @override
  String get modifyPasswordFail => '密码小于6位或两次密码输入不一致';

  @override
  String get oldPasswordIncorrect => '原密码错误!';

  @override
  String get secretKeyUpdateHelp1 => '请仔细阅读';

  @override
  String get secretKeyUpdateHelp2 => 'Allpass 1.5.0及以后使用了新的密钥存储方式';

  @override
  String get secretKeyUpdateHelp3 =>
      'Allpass 会对每一个用户生成独一无二的密钥并将其存储到系统特定的区域中，这意味着即使反编译了 Allpass 并通过某些方法获取到了数据库中的数据，也无法轻易破解';

  @override
  String get secretKeyUpdateHelp4 => '升级后，所有密码的加密和解密均将依赖生成的新密钥，请';

  @override
  String get secretKeyUpdateHelp5 => '妥善保管生成后的新密钥';

  @override
  String get secretKeyUpdateHelp6 =>
      '如果您进行了 WebDAV 同步，即使卸载了 Allpass 并且备份文件中密码已加密，仍然可以通过密钥找回数据';

  @override
  String get secretKeyUpdateHelp7 => '升级所需时间较短，因手机而异';

  @override
  String get secretKeyUpdateHelp8 => '升级过程中请不要退出程序，否则可能造成数据丢失！';

  @override
  String get secretKeyUpdateHelp9 => '***************** 注意 *****************';

  @override
  String get secretKeyUpdateHelp10 =>
      '如果您使用 Allpass 进行过 WebDAV 备份，且“加密等级”不是“不加密”，那么密钥更新后旧的备份文件';

  @override
  String get secretKeyUpdateHelp11 => '无法';

  @override
  String get secretKeyUpdateHelp12 => '再使用！（本机数据不受影响）';

  @override
  String get secretKeyUpdateHelp13 => '为了数据安全，仍建议在升级前通过“导出为csv”的方式进行备份！';

  @override
  String get secretKeyUpdateHelp14 => '可以直接编辑下面的输入框，手动输入自定义密钥（32位）';

  @override
  String get secretKeyUpdateHint => '生成后的密钥显示在此';

  @override
  String get generateSecretKey => '生成密钥';

  @override
  String get generateSecretKeyDone => '生成完成，请保管好新密钥（可以长按复制）';

  @override
  String get startUpgrade => '开始升级';

  @override
  String get upgradeDone => '升级完成';

  @override
  String get pleaseGenerateKeyFirst => '请先生成密钥';

  @override
  String get secretKeyLengthRequire => '密钥长度必须为 32 位';

  @override
  String secretKeyUpgradeResult(int passwordCount, int cardCount) {
    return '升级了 $passwordCount 条密码和 $cardCount 个卡片';
  }

  @override
  String secretKeyUpgradeFailed(Object error) {
    return '升级失败：$error';
  }

  @override
  String get feedbackPlaceholder => '说说你的问题';

  @override
  String get feedbackContact => '请输入联系方式（选填）';

  @override
  String get submit => '提交';

  @override
  String get submitting => '提交中，请稍后';

  @override
  String get feedbackContentEmptyWarning => '请输入反馈内容';

  @override
  String get feedbackContentTooLong => '反馈内容必须小于1000字！';

  @override
  String updateAvailable(String? channel, String? version) {
    return '有新版本可以下载！最新版本 $channel V$version';
  }

  @override
  String alreadyLatestVersion(String? channel, String? version) {
    return '您的版本是最新版！$channel V$version';
  }

  @override
  String get updateContent => '更新内容：';

  @override
  String get recentlyUpdateContent => '最近更新：';

  @override
  String networkErrorMsg(String? message) {
    return '网络错误：$message';
  }

  @override
  String get networkErrorHelp => '由于网络原因出现错误，若您确保您的网络无问题，则可能是下面的原因：\n';

  @override
  String unknownError(String? message) {
    return '未知错误: $message';
  }

  @override
  String get unknownErrorHelp => '检查过程中有错误出现！下面是错误信息，请截图发送到 sys6511@126.com\n';

  @override
  String get downloadUpdate => '下载更新';

  @override
  String get remindMeLatter => '下次再说';

  @override
  String get confirm => '确认';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeColorBlue => '蓝色';

  @override
  String get themeColorRed => '红色';

  @override
  String get themeColorTeal => '青色';

  @override
  String get themeColorDeepPurple => '深紫';

  @override
  String get themeColorOrange => '橙色';

  @override
  String get themeColorPink => '粉色';

  @override
  String get themeColorBlueGrey => '蓝灰';

  @override
  String get selectExportType => '选择导出内容';

  @override
  String get exportConfirm => '导出确认';

  @override
  String get exportPasswordConfirmWarning => '导出后的密码将以明文展示，请妥善保管';

  @override
  String get exportCardConfirmWarning => '导出后的卡片将以明文展示，请妥善保管';

  @override
  String get passwordAndCard => '所有';

  @override
  String get exportAllConfirmWarning => '导出后的数据将以明文展示，请妥善保管';

  @override
  String exportFailed(String? message) {
    return '导出失败：$message';
  }

  @override
  String get importFromChrome => '从 Chrome 中导入';

  @override
  String get importFromCsv => '从 CSV 文件导入';

  @override
  String get importFromClipboard => '从剪贴板导入';

  @override
  String get exportToCsv => '导出为 CSV 文件';

  @override
  String get selectImportType => '选择导入内容';

  @override
  String importRecordSuccess(int count) {
    return '导入了 $count 条记录';
  }

  @override
  String get importFailedNotCsv => '导入失败，请确保csv文件为标准Allpass导出文件';

  @override
  String get importCanceled => '取消导入';

  @override
  String get importFromClipboardHelp1 => '此功能帮助您轻松地从之前在记事本中保存的密码导入到Allpass中；\n';

  @override
  String get importFromClipboardHelp2 =>
      '名称是密码的助记符，您可以随便起一个名称来让您知道此条记录是什么内容；\n';

  @override
  String get importFromClipboardHelp3 => '账号是登录使用的账号名，有可能是手机、邮箱或者其他您设置的账号；\n';

  @override
  String get importFromClipboardHelp4 =>
      '网站地址可以帮助Allpass在正确的网站填充您的密码，大多数情况下是网站登录页的URL地址；\n';

  @override
  String get importFromClipboardHelp5 =>
      '两个字段之间请以“空格”作为分隔符，这样Allpass才能正确分辨哪个是用户名，哪个是密码；\n';

  @override
  String get importFromClipboardHelp6 =>
      '如果选择了最后两种导入格式，请输入默认账号；如果有多个用户名，可以分为几次导入；';

  @override
  String get importFromClipboardSelectFormat => '请选择密码格式（空格为分隔符）';

  @override
  String get importFromClipboardFormat1 => '名称 账号 密码 网站地址';

  @override
  String get importFromClipboardFormat2 => '名称 账号 密码';

  @override
  String get importFromClipboardFormat3 => '账号 密码 网站地址';

  @override
  String get importFromClipboardFormat4 => '账号 密码';

  @override
  String get importFromClipboardFormat5 => '名称 密码';

  @override
  String get importFromClipboardFormat6 => '密码';

  @override
  String get importFromClipboardFormatHint => '请在此输入默认账号';

  @override
  String get importFromClipboardFormatHint2 => '请输入默认账号';

  @override
  String get importFromClipboardFormatHint3 => '请输入数据';

  @override
  String get pasteDataHere => '在此粘贴您的数据';

  @override
  String get startImport => '开始导入';

  @override
  String get importing => '导入中，请稍后';

  @override
  String get importComplete => '导入完成';

  @override
  String recordFormatIncorrect(int n) {
    return '第 $n 行记录格式不正确，请检查';
  }

  @override
  String get importFromExternalPreview => '导入预览';

  @override
  String get importFromExternalTips => '左滑以删除密码条目';

  @override
  String get confirmImport => '确认导入';

  @override
  String categoryManagement(String categoryName) {
    return '$categoryName管理';
  }

  @override
  String createCategory(String categoryName) {
    return '新建$categoryName';
  }

  @override
  String createCategorySuccess(String categoryName, String name) {
    return '创建$categoryName $name 成功';
  }

  @override
  String categoryAlreadyExists(String categoryName, String name) {
    return '$categoryName $name 已存在';
  }

  @override
  String get folderDisallowModify => '此文件夹不允许修改';

  @override
  String updateCategory(String categoryName) {
    return '编辑$categoryName';
  }

  @override
  String updateCategorySuccess(Object categoryName, Object name) {
    return '保存$categoryName $name';
  }

  @override
  String deleteCategory(String categoryName) {
    return '删除$categoryName';
  }

  @override
  String get deleteLabelWarning => '拥有此标签的密码或卡片将删除此标签，是否继续？';

  @override
  String get deleteFolderWarning => '此操作将会移动此文件夹下的所有密码及卡片到「默认」文件夹中，是否继续？';

  @override
  String pleaseInputCategoryName(String categoryName) {
    return '请输入$categoryName名';
  }

  @override
  String categoryNameRuleRequire(String categoryName) {
    return '$categoryName名中不允许含有\',\'、\'~\'或\'空格\'';
  }

  @override
  String get categoryNameNotValid => '输入内容不合法，请勿包含‘,’、‘~’或空格';

  @override
  String get categoryNameNotAllowEmpty => '输入内容不合法';

  @override
  String get autofillEnableAllpass => 'Allpass 已是您的自动填充服务';

  @override
  String get autofillDisableAllpass => '未使用 Allpass 作为自动填充服务';

  @override
  String get autofillHelp =>
      '当您在应用程序中输入密码时，自动填充功能会自动提供可能的密码匹配项以便您进行选择。当存储的密码条目符合以下条件之一时，将作为候选项：\n\n1. 密码条目所属App与当前App相匹配时；\n2. 密码条目的名称与当前App名称匹配时；\n\n如果您发现自动填充的结果不准确，您可以在密码编辑页面中修改密码条目所属App，以帮助自动填充功能更准确地匹配密码';

  @override
  String get uploadToRemote => '上传到云端';

  @override
  String get recoverToLocal => '恢复到本地';

  @override
  String get remoteBackupDirectory => '云端备份目录';

  @override
  String get backupFileMethod => '备份文件方式';

  @override
  String get dataMergeMethod => '数据恢复方式';

  @override
  String get encryptLevel => '加密等级';

  @override
  String get logoutAccount => '退出账号';

  @override
  String get confirmUpload => '确认上传';

  @override
  String confirmUploadWaring(String encryptLevel) {
    return '当前加密等级为「$encryptLevel」，是否继续？';
  }

  @override
  String get uploading => '上传中，请等待完成后重试';

  @override
  String get confirmRecover => '确认恢复';

  @override
  String confirmRecoverWarning(String mergeMethod) {
    return '当前恢复数据合并方式为「$mergeMethod」，是否继续？';
  }

  @override
  String get recovering => '正在恢复中，请等待完成后重试';

  @override
  String recoverV1FileHelp(String encryptLevel, String filename) {
    return '检测到正在恢复旧版备份文件，请选择文件种类，文件种类将影响到最终恢复结果，请确保选择正确\n\n加密等级: $encryptLevel 文件名: $filename';
  }

  @override
  String get pleaseInputCustomSecretKey => '请输入自定义密钥(32位)';

  @override
  String get inputCustomSecretKeyHelp => '备份文件所使用加密密钥与当前密钥不一致，请更换备份文件或更新密钥';

  @override
  String get pleaseInputBackupDirectory => '请输入备份目录路径';

  @override
  String get encryptHelp1 =>
      '加密等级是指备份到WebDAV的文件的加密方式，对于旧版备份文件(Allpass 1.7.0以下版本生成的备份文件)，请确保上传与恢复的加密等级相同\n';

  @override
  String get encryptHelp2 => '不加密：';

  @override
  String get encryptHelp3 => '数据直接以明文的方式备份，密码字段可见；最不安全但通用性高，可以直接打开备份文件查看密码\n';

  @override
  String get encryptHelp4 => '仅加密密码字段: ';

  @override
  String get encryptHelp5 => '默认选项，仅将密码与卡片记录中的“密码”字段进行加密，而名称、用户名、标签之类的字段不加密\n';

  @override
  String get encryptHelp6 => '全部加密：';

  @override
  String get encryptHelp7 => '所有字段全部进行加密，加密后的数据完全不可读，最安全但是如果丢失了密钥则有可能无法找回文件\n';

  @override
  String get encryptHelp8 =>
      '后两种加密方式严格依赖本机 Allpass 使用的密钥，在丢失密钥的情况下，一旦进行卸载或者数据清除操作则数据将无法恢复！！！';

  @override
  String get confirmLogout => '确认退出';

  @override
  String get confirmLogoutWaring => '退出账号后需要重新登录，并清除所有配置信息，是否继续？';

  @override
  String lastUploadAt(String uploadTimeString) {
    return '最近上传于$uploadTimeString';
  }

  @override
  String lastRecoverAt(String recoverTimeString) {
    return '最近恢复于$recoverTimeString';
  }

  @override
  String get decryptBackupError => '解密备份文件失败';

  @override
  String get syncAuthFailed => '账号权限失效，请检查网络或退出账号并重新配置';

  @override
  String get syncing => '同步中，请稍后';

  @override
  String get webdavConfig => '账号配置';

  @override
  String get port => '端口号';

  @override
  String get webdavServerUrl => 'WebDAV 服务器地址';

  @override
  String get webdavServerUrlHint => '请以 http:// 或 https:// 开头';

  @override
  String get webdavServerUrlRequire => '服务器地址必须以 http:// 或 https:// 开头';

  @override
  String get webdavPortRequire => '端口号必须为数字';

  @override
  String get webdavLoginSuccess => '账号验证成功';

  @override
  String get webdavLoginFailed => '验证失败，请稍后重试';

  @override
  String get nextStep => '下一步';

  @override
  String get inConfiguration => '配置中';

  @override
  String get webdavHelp1 => '此功能可以将您的数据备份到 WebDAV 服务器中或者进行数据恢复.\n';

  @override
  String get webdavHelp2 => 'WebDAV 服务器地址请以 http:// 或 https:// 开头，如坚果云(点击复制)：';

  @override
  String get webdavHelp3 => '端口号代表服务所在端口，如果您不清楚，请不要编辑.';

  @override
  String get webdavExample => 'https://dav.jianguoyun.com/dav/';

  @override
  String get copySuccess => '复制成功';

  @override
  String get clickToViewAndEditConfig => '点击以查看或修改配置';

  @override
  String get help => '帮助';

  @override
  String get modifyBackupFilename => '修改备份文件名';

  @override
  String get passwordBackupFilename => '密码备份文件名';

  @override
  String get cardBackupFilename => '卡片备份文件名';

  @override
  String get extraBackupFilename => '标签文件夹备份文件名';

  @override
  String get filenameNotAllowSame => '文件名不能相同';

  @override
  String get filenameNotAllowEmpty => '文件名不能为空';

  @override
  String get filenameRuleRequire => '文件名中不能含有 \\/:*?\"<>| 字符';

  @override
  String get selectBackupFile => '选择备份文件';

  @override
  String get gettingBackupFiles => '获取备份文件中，请稍后...';

  @override
  String get noBackupFileHint => '当前目录下无文件，请确保备份目录正确';

  @override
  String currentDirectory(String directory) {
    return '当前目录：$directory';
  }

  @override
  String get uploadFileNotExists => '上传文件失败，文件不存在';

  @override
  String get downloadFileFailed => '下载文件失败';

  @override
  String get fileNotExists => '文件不存在！';

  @override
  String get syncNeedReLogin => '账号权限失效，请重新登录';

  @override
  String get getBackupFileFailed => '获取文件列表失败，请尝试将备份目录改为子文件夹后重试';

  @override
  String get getBackupFileFailedCheckNetwork => '获取文件列表失败，请检查网络';

  @override
  String get uploadSuccess => '上传成功';

  @override
  String get uploadFileFailedReject => '上传失败，请尝试将备份目录改为子文件夹后重试';

  @override
  String get uploadFileFailedCheckNetwork => '上传失败，请检查网络';

  @override
  String uploadFileFailedUnknown(String? message) {
    return '上传失败，错误信息：$message';
  }

  @override
  String uploadFileFailedOther(Object error) {
    return '上传失败 $error';
  }

  @override
  String get downloadComplete => '下载完成';

  @override
  String get unsupportedBackupFile => '不支持的备份文件';

  @override
  String get backupFileCorrupt => '备份文件数据损坏';

  @override
  String get backupFileNotFound => '备份文件已被删除，请再次打开对话框刷新后重试';

  @override
  String get networkError => '网络错误，请稍后重试';

  @override
  String downloadFailedUnknown(String? message) {
    return '下载失败，错误信息：$message';
  }

  @override
  String downloadFailedOther(Object error) {
    return '下载失败 $error';
  }

  @override
  String get folderLabel => '文件夹及标签';

  @override
  String recoverySuccessMsg(String name) {
    return '恢复 $name 成功';
  }

  @override
  String recoveryFailedMsg(Object error) {
    return '恢复失败 $error';
  }

  @override
  String get recoverySuccess => '恢复成功';

  @override
  String get mergeMethodLocalFirst => '本地优先';

  @override
  String get mergeMethodRemoteFirst => '云端优先';

  @override
  String get mergeMethodOnlyRemote => '不保留本地数据';

  @override
  String get mergeMethodLocalFirstHelp => '当本地记录和云端记录名称、用户名和链接相同时，保留本地记录';

  @override
  String get mergeMethodRemoteFirstHelp => '当本地记录和云端记录名称、用户名和链接相同时，使用云端记录';

  @override
  String get mergeMethodOnlyRemoteHelp => '清空本地所有数据，只使用云端数据';

  @override
  String get encryptLevelNone => '不加密';

  @override
  String get encryptLevelOnlyPassword => '仅加密密码字段';

  @override
  String get encryptLevelAll => '全部加密';

  @override
  String get encryptLevelNoneHelp => '备份文件中的密码将以明文状态进行展示';

  @override
  String get encryptLevelOnlyPasswordHelp => '默认选项，只加密密码字段';

  @override
  String get encryptLevelAllHelp => '所有字段均进行加密，无法直接从备份文件中获取信息';

  @override
  String get backupMethodCreateNew => '每次创建新文件';

  @override
  String get backupMethodReplaceExists => '备份到指定文件';

  @override
  String get searchHint => '搜索名称、用户名、备注或标签';

  @override
  String get searchResultEmpty => '无结果，换个关键词试试吧';

  @override
  String get view => '查看';

  @override
  String get edit => '编辑';

  @override
  String get copyUsername => '复制用户名';

  @override
  String get usernameCopied => '已复制用户名';

  @override
  String get copyPassword => '复制密码';

  @override
  String get deletePassword => '删除密码';

  @override
  String get copyOwnerName => '复制拥有者姓名';

  @override
  String get ownerNameCopied => '已复制拥有者姓名';

  @override
  String get copyCardId => '复制卡号';

  @override
  String get deleteCard => '删除卡片';

  @override
  String get fav => '收藏';

  @override
  String get favorites => '收藏';

  @override
  String get allpassIntroduction => '一款简单的私密信息管理工具';

  @override
  String get enterDebugMode => '进入开发者模式';

  @override
  String get contact => '联系方式';

  @override
  String get website => '官网：https://allpass.aengus.top';

  @override
  String get contact1 => '微博：@Aengus_Sun';

  @override
  String get contact1Url => 'https://weibo.com/u/5484402663';

  @override
  String get contact2 => '邮箱：sys6511@126.com';

  @override
  String get contact3 => '开发者博客：https://www.aengus.top';

  @override
  String get projectUrl => '开源地址：Github';

  @override
  String get gitee => '码云';

  @override
  String get defaultFolder => '默认';

  @override
  String get folderEntertainment => '娱乐';

  @override
  String get folderOffice => '办公';

  @override
  String get folderFinance => '金融';

  @override
  String get folderGame => '游戏';

  @override
  String get folderForum => '论坛';

  @override
  String get folderEducation => '教育';

  @override
  String get folderSocial => '社交';

  @override
  String get debugListInstalledApp => '显示已安装App';

  @override
  String get debugPageTest => '页面跳转';

  @override
  String get debugListSp => '查看SP';

  @override
  String get debugDeleteAllPassword => '删除所有密码';

  @override
  String get debugDeleteAllCard => '删除所有卡片';

  @override
  String get debugDeletePasswordDB => '删除密码数据库';

  @override
  String get debugDeleteCardDB => '删除卡片数据库';

  @override
  String get debugAllPasswordDeleted => '已删除所有密码';

  @override
  String get debugAllCardDeleted => '已删除所有卡片';

  @override
  String get debugPasswordDBDeleted => '已删除密码数据库';

  @override
  String get debugCardDBDeleted => '已删除卡片数据库';

  @override
  String get importFromChromeTips1 => '打开 Chrome，进入“密码管理工具”，点击“导出密码”';

  @override
  String get importFromChromeTips2 => '在文件管理中找到导出的密码文件，选择“分享”';

  @override
  String get importFromChromeTips3 =>
      '在分享面板中选择“导入到Allpass中”，将自动打开 Allpass 导入页面';

  @override
  String get storagePermissionDenied => '存储权限被禁止，请前往设置页打开存储空间权限';
}
