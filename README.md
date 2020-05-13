# Allpass

## 介绍
![Allpass](http://aengus.top/assets/common/allpass-icon.png)

Allpass是一款简单的私密数据管理工具，包括支持密码存储与卡片信息存储。采用Flutter构建，目前完成了针对安卓的适配。

- 密码与卡片信息管理
- 支持指纹解锁软件
- AES256位加密
- 支持从csv文件中导入或导出为csv文件
- 支持从Chrome中导入密码
- 支持从剪贴板中导入密码
- 标签功能
- 文件夹功能
- 收藏功能
- 备注功能
- 密码生成器
- 多选编辑功能
- WebDAV同步功能

# 注意

**若要构建Allpass，请修改**`lib/utils/encrypt_util.dart`**中的**`_key`**（32位字符串）**；

**作者发布的Allpass已签名。所以如果在已安装作者发布的Allpass的情况下，安装自己构建的程序，请先卸载，否则可能导致安装失败或者密码数据丢失。**

# 软件截图

![登录页](http://aengus.top/assets/screenshots/allpass/login.png)
![注册页](http://aengus.top/assets/screenshots/allpass/register.png)
![密码页](http://aengus.top/assets/screenshots/allpass/password.png)
![查看密码页](http://aengus.top/assets/screenshots/allpass/view_password.png)
![卡片页](http://aengus.top/assets/screenshots/allpass/card.png)
![分类](http://aengus.top/assets/screenshots/allpass/classification.png)
![分类详情页](http://aengus.top/assets/screenshots/allpass/fav.png)
![设置页](http://aengus.top/assets/screenshots/allpass/setting.png)
![关于页](http://aengus.top/assets/screenshots/allpass/about.png)

# 下载体验

你可以在酷安搜索“Allpass”进行下载，扫描下面的二维码或者[点此下载](https://www.aengus.top/assets/app/Allpass_V1.2.0_signed.apk)
![AllpassV1.2.0](https://www.aengus.top/assets/app/allpass_v1.2.0.png)

# 未来规划

- ~WebDAV同步功能~（已完成）
- ~多选编辑功能~（已完成）
- 自动填充
- 自动获取网站favicon作为密码头像
- 智能识别网址生成名称

## 文件结构

- dao/ 与数据库交互层
- model/ 密码或卡片实体类
- pages/ 页面
- params/ 软件相关参数
- provider/ 状态管理
- route/ 路由管理
- services/ 服务管理，包括生物识别授权及路由服务
- utils/ 工具
- ui/ 界面相关
- widgets/ 自定义组件

## 命名规范

### Dart文件
1. dart文件采用下划线命名方式；
2. 类采取大驼峰命名法，变量、常量、函数名采用小驼峰命名法；
3. 导包as后的名称使用小写+下划线；
4. 导包顺序为：
    Dart SDK; flutter内的库; 第三方库; 自己的库; 相对路径引用;

### 数据库相关
1. 数据库表名使用下划线命名方式，且表名开头的第一个单词为`allpass`；
2. 表的列名与model相同，采用小写驼峰命名方式；

# 仓库地址
| 位置 | 地址                                   |
| ---- | -------------------------------------- |
| Github | [https://github.com/sunyongsheng/Allpass](https://github.com/sunyongsheng/Allpass) |
| 码云 | [https://gitee.com/sunyongsheng/Allpass](https://gitee.com/sunyongsheng/Allpass) |

# Flutter环境
```
[√] Flutter (Channel stable, v1.12.13+hotfix.5, on Microsoft Windows [Version 10.0.18363.592], locale zh-CN)

[√] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
[√] Android Studio (version 3.5)
```

# LICENSE
[![License](https://img.shields.io/badge/license-Apache%202-green.svg)](https://www.apache.org/licenses/LICENSE-2.0)