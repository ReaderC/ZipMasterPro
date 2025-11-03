#!/bin/bash

# ZipMaster Pro 云编译脚本
# 这个脚本可以在任何支持bash的环境中运行，包括GitHub Actions、GitLab CI、或其他云编译服务

echo "🚀 ZipMaster Pro 云编译开始..."

# 检查必要的环境变量
if [ -z "$GITHUB_WORKSPACE" ] && [ -z "$CI_PROJECT_DIR" ]; then
    echo "⚠️  未在云环境中运行，切换到本地模式"
    CLOUD_MODE=false
else
    CLOUD_MODE=true
    echo "☁️  云编译模式已启用"
fi

# 设置基本变量
PROJECT_NAME="ZipMasterPro"
SCHEME_NAME="ZipMasterPro"
CONFIGURATION="Release"
BUILD_DIR="build"
ARCHIVE_PATH="${PROJECT_NAME}.xcarchive"
IPA_NAME="${PROJECT_NAME}_unsigned.ipa"

# 函数：显示进度信息
show_progress() {
    echo "⏳ $1..."
}

# 函数：显示成功信息
show_success() {
    echo "✅ $1"
}

# 函数：显示错误信息并退出
show_error() {
    echo "❌ 错误: $1"
    exit 1
}

# 步骤1: 环境检查
show_progress "检查编译环境"

# 检查Xcode
if ! command -v xcodebuild &> /dev/null; then
    show_error "未找到xcodebuild，请确保Xcode已安装"
fi

# 检查项目文件
if [ ! -f "${PROJECT_NAME}.xcodeproj/project.pbxproj" ]; then
    show_error "未找到Xcode项目文件"
fi

show_success "编译环境检查通过"

# 步骤2: 清理之前的构建
show_progress "清理之前的构建文件"
rm -rf "$BUILD_DIR" "$ARCHIVE_PATH" "$IPA_NAME" 2>/dev/null || true
show_success "清理完成"

# 步骤3: 显示环境信息
show_progress "显示编译环境信息"
echo "📋 编译环境信息:"
echo "   Xcode版本: $(xcodebuild -version | head -1)"
echo "   macOS版本: $(sw_vers -productVersion)"
echo "   SDK版本: $(xcrun --sdk iphoneos --show-sdk-version)"
echo "   可用设备:"
xcrun xctrace list devices 2>/dev/null | grep -E "(iPhone|iPad)" | head -5
show_success "环境信息显示完成"

# 步骤4: 构建iOS应用
show_progress "构建iOS应用"

# 尝试不同的构建策略
BUILD_SUCCESS=false

# 策略1: 直接构建应用包
if [ "$BUILD_SUCCESS" = false ]; then
    show_progress "尝试构建应用包"
    xcodebuild -project "${PROJECT_NAME}.xcodeproj" \
        -scheme "$SCHEME_NAME" \
        -configuration "$CONFIGURATION" \
        -destination 'generic/platform=iOS' \
        -derivedDataPath "$BUILD_DIR" \
        clean build \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        AD_HOC_CODE_SIGNING_ALLOWED=YES \
        ARCHS="arm64" \
        ONLY_ACTIVE_ARCH=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=NO \
        DEPLOYMENT_LOCATION=YES \
        INSTALL_PATH=/Applications \
        DSTROOT="$BUILD_DIR"
    
    if [ $? -eq 0 ]; then
        BUILD_SUCCESS=true
        show_success "应用包构建成功"
    else
        show_progress "应用包构建失败，尝试其他方法"
    fi
fi

# 策略2: 使用模拟器构建
if [ "$BUILD_SUCCESS" = false ]; then
    show_progress "尝试使用模拟器构建"
    xcodebuild -project "${PROJECT_NAME}.xcodeproj" \
        -scheme "$SCHEME_NAME" \
        -configuration "$CONFIGURATION" \
        -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
        -derivedDataPath "$BUILD_DIR" \
        clean build \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO
    
    if [ $? -eq 0 ]; then
        BUILD_SUCCESS=true
        show_success "模拟器构建成功"
        echo "⚠️  注意: 这是模拟器版本，只能在模拟器中运行"
    else
        show_progress "模拟器构建失败"
    fi
fi

# 策略3: 使用xcodebuild archive
if [ "$BUILD_SUCCESS" = false ]; then
    show_progress "尝试使用archive构建"
    xcodebuild -project "${PROJECT_NAME}.xcodeproj" \
        -scheme "$SCHEME_NAME" \
        -configuration "$CONFIGURATION" \
        -destination 'generic/platform=iOS' \
        -archivePath "$ARCHIVE_PATH" \
        archive \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        AD_HOC_CODE_SIGNING_ALLOWED=YES \
        ARCHS="arm64" \
        ONLY_ACTIVE_ARCH=NO
    
    if [ $? -eq 0 ]; then
        BUILD_SUCCESS=true
        show_success "Archive构建成功"
    else
        show_error "所有构建方法都失败了"
    fi
fi

# 步骤5: 查找并处理构建结果
show_progress "处理构建结果"

# 查找构建的应用
if [ -d "$ARCHIVE_PATH" ]; then
    # 从archive中提取应用
    APP_PATH="$ARCHIVE_PATH/Products/Applications/${PROJECT_NAME}.app"
    if [ ! -d "$APP_PATH" ]; then
        # 尝试其他可能的位置
        APP_PATH=$(find "$ARCHIVE_PATH" -name "*.app" -type d | head -1)
    fi
elif [ -d "$BUILD_DIR" ]; then
    # 从构建目录中查找应用
    APP_PATH=$(find "$BUILD_DIR" -name "*.app" -type d | grep -v "x86_64" | head -1)
    if [ -z "$APP_PATH" ]; then
        APP_PATH=$(find "$BUILD_DIR" -name "*.app" -type d | head -1)
    fi
fi

if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
    show_error "未找到构建的应用文件"
fi

echo "📱 找到应用: $APP_PATH"
show_success "构建结果处理完成"

# 步骤6: 创建IPA包
show_progress "创建IPA包"

# 创建Payload目录
mkdir -p Payload

# 复制应用
if [ -d "$APP_PATH" ]; then
    cp -R "$APP_PATH" Payload/
else
    show_error "应用文件不存在: $APP_PATH"
fi

# 检查是否成功复制
if [ ! -d "Payload/$(basename "$APP_PATH")" ]; then
    show_error "应用复制失败"
fi

# 创建IPA文件
show_progress "打包IPA文件"
zip -r "$IPA_NAME" Payload

if [ ! -f "$IPA_NAME" ]; then
    show_error "IPA文件创建失败"
fi

# 清理临时文件
rm -rf Payload

show_success "IPA包创建完成"

# 步骤7: 显示结果信息
show_progress "显示构建结果"

echo ""
echo "🎉 构建完成！"
echo "====================="
echo "📱 应用名称: $PROJECT_NAME"
echo "📦 IPA文件: $IPA_NAME"
echo "📏 文件大小: $(ls -lh "$IPA_NAME" | awk '{print $5}')"
echo "🔧 构建配置: $CONFIGURATION"
echo "📱 目标平台: iOS"
echo "🏗️  架构: arm64"
echo "====================="

# 步骤8: 云编译特殊处理
if [ "$CLOUD_MODE" = true ]; then
    echo ""
    echo "☁️ 云编译完成！"
    echo "📤 IPA文件已准备好上传或发布"
    
    # 如果是GitHub Actions，设置输出
    if [ -n "$GITHUB_OUTPUT" ]; then
        echo "ipa-path=$IPA_NAME" >> "$GITHUB_OUTPUT"
        echo "app-name=$PROJECT_NAME" >> "$GITHUB_OUTPUT"
        echo "build-success=true" >> "$GITHUB_OUTPUT"
    fi
fi

# 步骤9: 提供后续操作建议
echo ""
echo "🔧 后续操作建议:"
echo "1. 安装IPA到设备:"
echo "   - 使用Xcode: 连接设备，拖拽IPA到Devices窗口"
echo "   - 使用AltStore: 通过AltStore应用安装"
echo "   - 使用Sideloadly: 通过Sideloadly工具安装"
echo "   - 越狱设备: 使用AppSync Unified安装"
echo ""
echo "2. 测试应用功能:"
echo "   - 文件压缩和解压"
echo "   - 加密和解密"
echo "   - 分卷压缩"
echo "   - LiquidGlass界面效果"
echo ""
echo "3. 定制开发:"
echo "   - 修改界面设计"
echo "   - 添加新功能"
echo "   - 优化性能"
echo "   - 适配新设备"

# 完成
show_success "云编译脚本执行完成！"
echo ""
echo "🙏 感谢使用ZipMaster Pro云编译脚本！"
echo "如有问题，请查看构建日志或联系技术支持。"