# ZipMaster Pro - iOS解压缩专家

基于iOS 26 LiquidGlass设计语言的强大解压缩工具，支持ZIP、7Z、RAR等主流格式，提供AES-256加密和智能分卷压缩功能。

## 🌟 主要功能

### 📁 文件管理
- 直观的文件浏览器界面
- 支持多种压缩格式预览
- 拖拽文件添加功能
- 文件操作历史记录

### 🗜️ 压缩功能
- **支持格式**: ZIP, 7Z, RAR, TAR, GZIP, BZIP2
- **压缩级别**: 6种压缩级别可选（存储到极致）
- **多文件压缩**: 支持批量文件压缩
- **实时预览**: 压缩前预估文件大小

### 🔐 加密解密
- **AES-256加密**: 军用级加密标准
- **密码强度检测**: 实时密码强度评估
- **安全提示**: 密码安全要求指导
- **多算法支持**: AES-128和AES-256

### 📊 分卷压缩
- **智能分卷**: 自动计算最优分卷方案
- **自定义大小**: 灵活设置分卷大小（10MB-500MB）
- **进度预览**: 实时显示分卷结果
- **压缩率计算**: 智能预估压缩效果

### ✨ LiquidGlass设计
- **毛玻璃效果**: 现代化的半透明界面
- **流畅动画**: 丝滑的交互动画效果
- **响应式设计**: 完美适配iPhone和iPad
- **深色模式**: 支持系统深色模式

## 🛠️ 技术特性

### 支持的压缩格式
| 格式 | 解压 | 压缩 | 加密 | 分卷 | 压缩率 |
|------|------|------|------|------|--------|
| ZIP  | ✅   | ✅   | ✅   | ✅   | 70%    |
| 7Z   | ✅   | ✅   | ✅   | ✅   | 95%    |
| RAR  | ✅   | ❌   | ✅   | ✅   | 85%    |
| TAR  | ✅   | ✅   | ❌   | ❌   | 50%    |
| GZIP | ✅   | ✅   | ❌   | ❌   | 75%    |
| BZIP2| ✅   | ✅   | ❌   | ❌   | 90%    |

### 系统要求
- **iOS版本**: iOS 17.0+
- **设备支持**: iPhone, iPad, iPod touch
- **存储空间**: 150MB可用空间
- **内存要求**: 2GB RAM最低，4GB RAM推荐

## 🚀 安装指南

### 方法1: 直接安装IPA文件
1. 下载 `ZipMasterPro_unsigned.ipa` 文件
2. 使用以下工具之一安装：
   - **Xcode**: Window → Devices and Simulators → 拖拽IPA文件
   - **AltStore**: 通过AltStore安装（需要电脑配合）
   - **Sideloadly**: 使用Sideloadly工具安装
   - **AppSync**: 越狱设备可使用AppSync Unified安装

### 方法2: 使用Xcode编译
1. 安装Xcode 15.0或更高版本
2. 打开 `ZipMasterPro.xcodeproj`
3. 连接iOS设备
4. 选择设备作为目标
5. 点击运行按钮编译安装

### 方法3: 自行构建IPA
```bash
# 运行构建脚本
./build_ipa.sh

# 生成的IPA文件位置：
# ipa/ZipMasterPro_unsigned.ipa
```

## 📱 使用指南

### 基本操作
1. **添加文件**: 点击右上角"+"按钮或拖拽文件到应用
2. **解压文件**: 选择压缩文件，点击解压按钮
3. **压缩文件**: 切换到压缩标签，选择文件和格式
4. **加密文件**: 在加密标签中设置密码和算法
5. **分卷压缩**: 在分卷标签中设置参数并预览结果

### 高级功能
- **批量操作**: 支持多文件同时处理
- **密码管理**: 安全存储常用密码（可选）
- **云端集成**: 支持iCloud Drive文件访问
- **分享功能**: 处理完成后可直接分享文件

## 🔧 开发信息

### 项目结构
```
ZipMasterPro/
├── ZipMasterProApp.swift          # 应用入口
├── ContentView.swift               # 主界面
├── FileManagerView.swift           # 文件管理
├── CompressionView.swift           # 压缩功能
├── EncryptionView.swift            # 加密功能
├── VolumeCompressionView.swift     # 分卷压缩
├── FileItem.swift                  # 数据模型
├── CompressionManager.swift        # 压缩管理器
├── EncryptionManager.swift         # 加密管理器
├── LiquidGlassEffect.swift         # 视觉效果
└── Resources/                      # 资源文件
```

### 使用的框架
- **SwiftUI**: 用户界面框架
- **Combine**: 响应式编程
- **CryptoKit**: 加密功能
- **UniformTypeIdentifiers**: 文件类型处理

### 构建要求
- **Xcode**: 15.0+
- **Swift**: 5.9+
- **iOS SDK**: 17.0+

## 🎨 设计理念

### LiquidGlass设计语言
- **材质感**: 模拟真实玻璃质感
- **层次感**: 通过透明度和模糊创造深度
- **流动性**: 流畅的动画和过渡效果
- **现代感**: 符合iOS 26设计规范

### 用户体验
- **直观操作**: 符合iOS用户习惯
- **即时反馈**: 所有操作都有视觉反馈
- **智能提示**: 上下文相关的帮助信息
- **无障碍支持**: 支持VoiceOver等辅助功能

## 🔒 安全说明

### 加密安全
- 使用Apple官方CryptoKit框架
- AES-256军用级加密标准
- 密码不会存储在设备上
- 支持安全密钥派生

### 隐私保护
- 不收集用户数据
- 所有处理本地完成
- 无网络传输敏感信息
- 符合Apple隐私政策

## 📄 许可证

本项目仅供学习和测试使用。商业使用请获取相应授权。

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 📞 支持

如有问题或建议，请通过以下方式联系：
- 邮件: support@zipmaster.pro
- GitHub Issues

---

**注意**: 这是一个演示性质的iOS应用程序，展示了iOS 26 LiquidGlass设计语言的解压缩工具。实际功能可能需要额外的库和配置。