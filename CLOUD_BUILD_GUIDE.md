# ZipMaster Pro - 云编译使用指南

## 🌟 概述

没有苹果电脑？没问题！您可以使用云编译服务来构建ZipMaster Pro iOS应用程序。本指南将介绍多种云编译方法。

## ☁️ 云编译选项

### 方法1: GitHub Actions (推荐)
**优点**: 免费、自动化、易于使用
**限制**: 每月2000分钟免费额度

### 方法2: GitLab CI/CD
**优点**: 免费、功能强大
**限制**: 每月400分钟免费额度

### 方法3: 其他云服务
- **MacStadium**: 专业Mac云服务
- **Scaleway**: 欧洲云服务商
- **Amazon EC2 Mac**: AWS Mac实例

## 🚀 GitHub Actions 使用指南

### 步骤1: 准备GitHub仓库

1. **创建GitHub账户**
   - 访问 [github.com](https://github.com)
   - 注册免费账户

2. **创建新仓库**
   - 点击 "New repository"
   - 命名为 "ZipMasterPro"
   - 选择 "Public" 或 "Private"
   - 不要初始化README

3. **上传项目文件**
   ```bash
   # 在本地项目目录中
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/ZipMasterPro.git
   git push -u origin main
   ```

### 步骤2: 启用GitHub Actions

1. **进入仓库设置**
   - 打开您的ZipMasterPro仓库
   - 点击 "Settings" 标签

2. **启用Actions**
   - 点击 "Actions" → "General"
   - 确保 "Allow all actions and reusable workflows" 被选中
   - 点击 "Save"

### 步骤3: 触发构建

#### 方法A: 推送代码自动构建
```bash
# 修改任意文件后提交
git add .
git commit -m "Trigger build"
git push
```

#### 方法B: 手动触发构建
1. 进入GitHub仓库
2. 点击 "Actions" 标签
3. 选择工作流
4. 点击 "Run workflow"

#### 方法C: 创建版本标签
```bash
# 创建版本标签
git tag v1.0.0
git push origin v1.0.0
```

### 步骤4: 下载IPA文件

1. **从Actions下载**
   - 进入 "Actions" 标签
   - 点击最新的工作流运行
   - 在 "Artifacts" 部分下载IPA文件

2. **从Releases下载** (如果使用标签)
   - 进入 "Releases" 标签
   - 下载发布的IPA文件

## 📋 GitLab CI 使用指南

### 步骤1: 准备GitLab仓库

1. **创建GitLab账户**
   - 访问 [gitlab.com](https://gitlab.com)
   - 注册免费账户

2. **创建新项目**
   - 点击 "New project"
   - 命名为 "ZipMasterPro"

3. **上传项目文件**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://gitlab.com/YOUR_USERNAME/ZipMasterPro.git
   git push -u origin main
   ```

### 步骤2: 创建GitLab CI配置

创建 `.gitlab-ci.yml` 文件：

```yaml
stages:
  - build

variables:
  LC_ALL: "en_US.UTF-8"
  LANG: "en_US.UTF-8"

build-ios:
  stage: build
  tags:
    - macos
  script:
    - echo "🔨 开始构建iOS应用..."
    - xcodebuild -version
    - xcodebuild -project ZipMasterPro.xcodeproj -scheme ZipMasterPro -configuration Release -destination 'generic/platform=iOS' clean build CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
    - echo "📦 创建IPA包..."
    - mkdir -p Payload
    - cp -R build/Release-iphoneos/ZipMasterPro.app Payload/
    - zip -r ZipMasterPro_unsigned.ipa Payload
    - rm -rf Payload
  artifacts:
    paths:
      - ZipMasterPro_unsigned.ipa
    expire_in: 1 week
  only:
    - main
    - tags
```

## 🔧 本地云编译脚本

### 使用 cloud_build.sh

```bash
# 使脚本可执行
chmod +x cloud_build.sh

# 运行云编译
./cloud_build.sh
```

### 脚本功能
- ✅ 自动环境检查
- ✅ 多种构建策略
- ✅ 错误处理和重试
- ✅ 详细日志输出
- ✅ 结果验证

## 📱 安装IPA文件

### 方法1: 使用Xcode
1. 连接iOS设备到电脑
2. 打开Xcode
3. 菜单：Window → Devices and Simulators
4. 拖拽IPA文件到设备列表

### 方法2: 使用AltStore
1. 在电脑上安装AltStore
2. 连接iOS设备
3. 通过AltStore安装IPA文件

### 方法3: 使用Sideloadly
1. 下载Sideloadly工具
2. 连接iOS设备
3. 选择IPA文件安装

### 方法4: 越狱设备
1. 安装AppSync Unified
2. 使用Filza等工具安装IPA

## ⚠️ 重要提醒

### 安全注意事项
- IPA文件为未签名版本
- 仅用于测试和开发目的
- 商业使用需要开发者证书
- 注意来源安全，避免恶意软件

### 系统要求
- iOS 17.0或更高版本
- 需要信任开发者证书
- 可能需要关闭某些安全限制

### 使用限制
- 未签名应用7天后过期
- 最多安装3个未签名应用
- 某些功能可能受限

## 🛠️ 故障排除

### 常见问题

#### 1. 构建失败
```bash
# 检查Xcode版本
xcodebuild -version

# 检查项目文件
xcodebuild -list

# 清理并重新构建
rm -rf build/
xcodebuild clean
```

#### 2. IPA安装失败
- 检查设备是否信任开发者
- 确认iOS版本兼容性
- 检查设备存储空间
- 重启设备后重试

#### 3. 应用闪退
- 检查系统日志
- 确认权限设置
- 检查内存使用情况
- 更新到最新iOS版本

### 获取帮助
- 查看构建日志
- 检查GitHub Issues
- 参考项目文档
- 寻求社区支持

## 🎉 成功标志

当您看到以下信息时，表示云编译成功：

```
🎉 构建完成！
=====================
📱 应用名称: ZipMasterPro
📦 IPA文件: ZipMasterPro_unsigned.ipa
📏 文件大小: 5.2M
🔧 构建配置: Release
📱 目标平台: iOS
🏗️  架构: arm64
=====================
```

## 📞 技术支持

### 文档资源
- [GitHub Actions文档](https://docs.github.com/en/actions)
- [Xcode构建指南](https://developer.apple.com/xcode/)
- [iOS开发文档](https://developer.apple.com/ios/)

### 社区支持
- [Stack Overflow](https://stackoverflow.com)
- [iOS开发者社区](https://developer.apple.com/forums/)
- [Reddit iOS开发](https://www.reddit.com/r/iOSProgramming/)

---

## 🎊 云编译成功！

**恭喜！您现在可以使用云编译来构建ZipMaster Pro iOS应用程序了！**

### 下一步操作
1. **选择云编译平台** - GitHub Actions (推荐)
2. **设置仓库** - 上传项目文件
3. **触发构建** - 自动或手动触发
4. **下载IPA** - 从Artifacts或Releases下载
5. **安装应用** - 使用Xcode或第三方工具

### 使用建议
- **立即体验** - 尝试云编译流程
- **功能测试** - 测试所有压缩功能
- **界面欣赏** - 感受LiquidGlass设计
- **性能评估** - 在不同设备上测试
- **定制开发** - 根据需要进行修改

**无需苹果电脑，也能享受iOS开发的乐趣！**

云编译让iOS开发变得更加便捷和可访问。您可以在任何平台上开发，然后使用云服务来构建和测试您的应用程序。

**祝您使用愉快！** 🎉