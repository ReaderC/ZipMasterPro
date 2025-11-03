//
//  CompressionView.swift
//  ZipMasterPro
//
//  Created by AI Assistant on 2025/11/03.
//

import SwiftUI

struct CompressionView: View {
    @EnvironmentObject var fileManager: FileManagerModel
    @StateObject private var compressionManager = CompressionManager()
    @State private var selectedFormat = "zip"
    @State private var compressionLevel = 5
    @State private var showingFilePicker = false
    @State private var filesToCompress: [FileItem] = []
    
    let formats = [
        ("zip", "ZIP", "最兼容"),
        ("7z", "7Z", "最高压缩比"),
        ("tar", "TAR", "Linux标准"),
        ("gz", "GZIP", "单文件压缩")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidGlassBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Format Selection
                        formatSelectionSection
                        
                        // Compression Settings
                        compressionSettingsSection
                        
                        // Selected Files
                        selectedFilesSection
                        
                        // Compression Progress
                        if compressionManager.isCompressing {
                            compressionProgressSection
                        }
                        
                        // Action Button
                        actionButtonSection
                    }
                    .padding()
                }
            }
            .navigationTitle("文件压缩")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingFilePicker) {
                DocumentPicker { url in
                    let newFile = FileItem(name: url.lastPathComponent, url: url, size: 0)
                    filesToCompress.append(newFile)
                }
            }
        }
    }
    
    private var formatSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("选择格式")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(formats, id: \.0) { format in
                FormatSelectionRow(
                    format: format.0,
                    name: format.1,
                    description: format.2,
                    isSelected: selectedFormat == format.0
                ) {
                    selectedFormat = format.0
                }
            }
        }
    }
    
    private var compressionSettingsSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("压缩设置")
                    .font(.headline)
                    .foregroundColor(.white)
                
                // Compression Level
                VStack(alignment: .leading, spacing: 8) {
                    Text("压缩等级: \\(compressionLevel)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Slider(value: Binding(
                        get: { Double(compressionLevel) },
                        set: { compressionLevel = Int($0) }
                    ), in: 1...9, step: 1)
                    .accentColor(.pink)
                    
                    HStack {
                        Text("快速")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                        Text("极致")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                // Format Info
                VStack(alignment: .leading, spacing: 4) {
                    Text("格式信息")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(getFormatInfo(selectedFormat))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
        }
    }
    
    private var selectedFilesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("选择文件")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    showingFilePicker = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.pink)
                }
            }
            
            if filesToCompress.isEmpty {
                LiquidGlassCard {
                    Text("点击 + 添加要压缩的文件")
                        .foregroundColor(.white.opacity(0.7))
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            } else {
                ForEach(filesToCompress) { file in
                    FileSelectionRow(file: file) {
                        if let index = filesToCompress.firstIndex(where: { $0.id == file.id }) {
                            filesToCompress.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    private var compressionProgressSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("压缩进度")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ProgressView(value: compressionManager.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .pink))
                
                HStack {
                    Text(compressionManager.statusText)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text("\\(Int(compressionManager.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
        }
    }
    
    private var actionButtonSection: some View {
        VStack(spacing: 12) {
            Button(action: startCompression) {
                HStack {
                    Image(systemName: "archivebox")
                    Text(filesToCompress.isEmpty ? "选择文件" : "开始压缩")
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.pink, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .disabled(filesToCompress.isEmpty || compressionManager.isCompressing)
            
            if compressionManager.isCompressing {
                Button(action: {
                    compressionManager.cancelCompression()
                }) {
                    Text("取消压缩")
                        .foregroundColor(.red)
                        .fontWeight(.medium)
                }
            }
        }
    }
    
    private func startCompression() {
        guard !filesToCompress.isEmpty else { return }
        
        compressionManager.startCompression(
            files: filesToCompress,
            format: selectedFormat,
            level: compressionLevel
        )
    }
    
    private func getFormatInfo(_ format: String) -> String {
        switch format {
        case "zip":
            return "ZIP是最流行的压缩格式，具有广泛的兼容性，支持加密和分卷压缩。"
        case "7z":
            return "7Z格式提供最高的压缩比，使用LZMA/LZMA2压缩算法，适合需要最大化压缩效果的场景。"
        case "tar":
            return "TAR是Linux/Unix系统的标准归档格式，通常与其他压缩算法结合使用。"
        case "gz":
            return "GZIP主要用于单文件压缩，常与TAR结合使用，在Linux系统中广泛使用。"
        default:
            return "未知格式"
        }
    }
}

struct FormatSelectionRow: View {
    let format: String
    let name: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                FileIconView(fileExtension: format)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.pink)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.pink : Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

struct FileSelectionRow: View {
    let file: FileItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            FileIconView(fileExtension: file.fileExtension)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(file.isSample ? "示例文件" : "真实文件")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct CompressionView_Previews: PreviewProvider {
    static var previews: some View {
        CompressionView()
            .environmentObject(FileManagerModel())
    }
}