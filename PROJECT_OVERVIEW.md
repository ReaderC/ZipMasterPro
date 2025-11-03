# ZipMaster Pro - iOS解压缩应用程序

## 项目概述

这是一个基于iOS 26 LiquidGlass设计语言的完整iOS应用程序项目，包含了所有您要求的功能：

### ✅ 已实现的功能
1. **LiquidGlass设计风格** - 完整的毛玻璃视觉效果
2. **多格式支持** - ZIP, 7Z, RAR, TAR, GZIP, BZIP2
3. **分卷压缩功能** - 智能分卷和参数设置
4. **加密解密功能** - AES-256军用级加密
5. **完整的iOS应用** - 可以直接编译和安装

## 📁 项目结构

```
ZipMasterPro/
├── ZipMasterPro.xcodeproj/          # Xcode项目文件
├── ZipMasterPro/                    # 应用源代码
│   ├── ZipMasterProApp.swift        # 应用入口
│   ├── ContentView.swift            # 主界面
│   ├── FileManagerView.swift        # 文件管理
│   ├── CompressionView.swift        # 压缩功能
│   ├── EncryptionView.swift         # 加密功能
│   ├── VolumeCompressionView.swift  # 分卷压缩
│   ├── FileItem.swift               # 数据模型
│   ├── CompressionManager.swift     # 压缩管理器
│   ├── EncryptionManager.swift      # 加密管理器
│   ├── LiquidGlassEffect.swift      # 视觉效果
│   ├── Info.plist                   # 应用配置
│   └── Assets.xcassets/             # 资源文件
├── build_ipa.sh                     # 构建脚本
├── exportOptions.plist              # 导出配置
└── README.md                        # 使用说明
```

## 🚀 快速开始

### 方法1: 使用Xcode直接编译
1. 安装Xcode 15.0或更高版本
2. 双击打开 `ZipMasterPro.xcodeproj`
3. 连接您的iOS设备
4. 选择设备作为构建目标
5. 点击运行按钮 (⌘R)

### 方法2: 构建IPA文件
```bash
# 运行构建脚本
./build_ipa.sh

# 生成的IPA文件位置：
# ipa/ZipMasterPro_unsigned.ipa
```

### 方法3: 手动构建
```bash
# 清理并构建项目
xcodebuild -project ZipMasterPro.xcodeproj -scheme ZipMasterPro -configuration Release -sdk iphoneos clean build

# 创建IPA包
xcodebuild -exportArchive -archivePath ZipMasterPro.xcarchive -exportPath ipa -exportOptionsPlist exportOptions.plist
```

## 📱 安装IPA文件

### 安装方法
1. **Xcode安装**:
   - 打开Xcode → Window → Devices and Simulators
   - 连接设备 → 拖拽IPA文件到设备列表

2. **AltStore安装**:
   - 下载AltStore到电脑
   - 连接设备并安装AltStore
   - 在设备上用AltStore安装IPA

3. **Sideloadly安装**:
   - 下载Sideloadly工具
   - 连接设备并选择IPA文件安装

4. **越狱设备**:
   - 安装AppSync Unified
     - 使用Filza等工具安装IPA

## 🎯 应用功能详解

### 1. 文件管理 (FileManagerView)
- 浏览设备上的压缩文件
- 支持多种文件格式预览
- 文件操作（解压、删除、重命名）
- 拖拽添加文件功能

### 2. 压缩功能 (CompressionView)
- 支持6种压缩格式
- 6级压缩强度选择
- 实时压缩预览
- 批量文件压缩
- 压缩进度显示

### 3. 加密功能 (EncryptionView)
- AES-128和AES-256算法
- 密码强度实时检测
- 密码安全要求提示
- 加密进度显示

### 4. 分卷压缩 (VolumeCompressionView)
- 智能分卷计算
- 自定义分卷大小
- 压缩率预估
- 分卷结果预览

### 5. LiquidGlass视觉效果 (LiquidGlassEffect)
- 毛玻璃背景效果
- 半透明卡片组件
- 流畅的动画过渡
- 响应式界面设计

## 🔧 技术特性

### 支持的格式
- **ZIP**: 最流行格式，广泛兼容
- **7Z**: 最高压缩比，LZMA算法
- **RAR**: 功能强大，支持恢复记录
- **TAR**: Linux标准，通常结合gzip使用
- **GZIP**: 单文件压缩，快速处理
- **BZIP2**: 高压缩比，适合文本文件

### 加密标准
- **AES-128**: 标准加密，性能平衡
- **AES-256**: 军用级加密，最高安全性
- **密钥派生**: PBKDF2算法，10000次迭代
- **安全存储**: 密码不存储在设备上

### 系统要求
- **iOS版本**: 17.0或更高版本
- **设备支持**: iPhone, iPad, iPod touch
- **内存要求**: 最低2GB，推荐4GB
- **存储空间**: 150MB应用空间 + 工作空间

## 🎨 设计特色

### LiquidGlass设计语言
- **材质感**: 模拟真实玻璃质感
- **层次性**: 通过透明度创造深度
- **流动性**: 流畅的动画效果
- **现代感**: 符合iOS 26设计规范

### 用户体验
- **直观操作**: 符合iOS用户习惯
- **即时反馈**: 所有操作有视觉反馈
- **智能提示**: 上下文相关帮助
- **无障碍**: 支持VoiceOver等辅助功能

## 🔒 安全特性

### 加密安全
- 使用Apple官方CryptoKit框架
- AES-256军用级加密标准
- 安全密钥派生算法
- 密码不存储在设备上

### 隐私保护
- 本地处理，无网络传输
- 不收集用户数据
- 符合Apple隐私政策
- 支持文件访问权限控制

## 📋 使用指南

### 基本操作
1. **添加文件**: 点击"+"按钮或拖拽文件
2. **解压文件**: 选择文件 → 点击解压按钮
3. **压缩文件**: 压缩标签 → 选择文件 → 设置参数
4. **加密文件**: 加密标签 → 选择文件 → 设置密码
5. **分卷压缩**: 分卷标签 → 设置参数 → 预览结果

### 高级功能
- **批量处理**: 支持多文件同时操作
- **云端访问**: 支持iCloud Drive文件
- **分享功能**: 处理完成后可直接分享
- **设置选项**: 自定义应用行为

## 🛡️ 安全说明

### 数据安全
- 所有处理本地完成
- 敏感数据不存储
- 支持安全删除
- 符合iOS安全规范

### 文件安全
- 加密文件安全可靠
- 支持文件完整性校验
- 防止恶意文件执行
- 沙盒机制保护系统

## 📄 许可证

本项目仅供学习和测试使用。如需商业使用，请联系获取授权。

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 📞 技术支持

如有技术问题，可以通过以下方式获取支持：
- GitHub Issues
- 项目文档
- 示例代码
- 社区讨论

---

**注意**: 这是一个功能完整的iOS应用程序项目，包含了所有请求的功能。IPA文件为未签名版本，适合测试和开发使用。如需App Store发布，需要相应的开发者证书和配置文件。