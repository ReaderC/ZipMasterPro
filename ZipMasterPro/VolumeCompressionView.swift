//
//  VolumeCompressionView.swift
//  ZipMasterPro
//
//  Created by AI Assistant on 2025/11/03.
//

import SwiftUI
import Combine

struct VolumeCompressionView: View {
    @State private var fileSize: Double = 1000 // MB
    @State private var volumeSize: Double = 100 // MB
    @State private var compressionLevel = 5
    @State private var showingResults = false
    @State private var calculationProgress = 0.0
    
    private let compressionLevels = [
        (name: "存储", value: 0, description: "不压缩，仅打包"),
        (name: "最快", value: 1, description: "快速压缩，文件较大"),
        (name: "快速", value: 3, description: "较快压缩，平衡速度"),
        (name: "标准", value: 5, description: "推荐设置，平衡性能"),
        (name: "较好", value: 7, description: "更好压缩，稍慢"),
        (name: "最好", value: 9, description: "最高压缩，最慢")
    ]
    
    var calculatedVolumes: Int {
        Int(ceil(fileSize / volumeSize))
    }
    
    var compressedSize: Double {
        // Simulate compression based on level
        let compressionRatio = 1.0 - (Double(compressionLevel) * 0.08)
        return fileSize * compressionRatio
    }
    
    var estimatedTime: String {
        let baseTime = fileSize / 50.0 // Base: 50MB per minute
        let levelMultiplier = 1.0 + (Double(compressionLevel) * 0.1)
        let totalMinutes = baseTime * levelMultiplier
        
        if totalMinutes < 1 {
            return "小于1分钟"
        } else if totalMinutes < 60 {
            return "\\(Int(totalMinutes))分钟"
        } else {
            let hours = Int(totalMinutes) / 60
            let minutes = Int(totalMinutes) % 60
            return "\\(hours)小时\\(minutes)分钟"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidGlassBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // File Size Selection
                        fileSizeSection
                        
                        // Volume Size Selection
                        volumeSizeSection
                        
                        // Compression Level
                        compressionLevelSection
                        
                        // Results Preview
                        if showingResults {
                            resultsSection
                        }
                        
                        // Action Button
                        actionButtonSection
                    }
                    .padding()
                }
            }
            .navigationTitle("分卷压缩")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var fileSizeSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("原始文件大小")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    Slider(
                        value: $fileSize,
                        in: 10...5000,
                        step: 10
                    ) {
                        Text("文件大小")
                    } minimumValueLabel: {
                        Text("10MB")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    } maximumValueLabel: {
                        Text("5GB")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .accentColor(.pink)
                    
                    Text("\\(Int(fileSize)) MB")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Quick Size Selection
                HStack(spacing: 8) {
                    ForEach([100, 500, 1000, 2000], id: \.self) { size in
                        Button(action: {
                            fileSize = Double(size)
                        }) {
                            Text("\\(size)MB")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(fileSize == Double(size) ? Color.pink : Color.white.opacity(0.1))
                                )
                                .foregroundColor(fileSize == Double(size) ? .white : .white.opacity(0.8))
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var volumeSizeSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("分卷大小")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    Slider(
                        value: $volumeSize,
                        in: 10...500,
                        step: 10
                    ) {
                        Text("分卷大小")
                    } minimumValueLabel: {
                        Text("10MB")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    } maximumValueLabel: {
                        Text("500MB")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .accentColor(.purple)
                    
                    Text("\\(Int(volumeSize)) MB")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Quick Volume Size Selection
                HStack(spacing: 8) {
                    ForEach([50, 100, 200, 500], id: \.self) { size in
                        Button(action: {
                            volumeSize = Double(size)
                        }) {
                            Text("\\(size)MB")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(volumeSize == Double(size) ? Color.purple : Color.white.opacity(0.1))
                                )
                                .foregroundColor(volumeSize == Double(size) ? .white : .white.opacity(0.8))
                        }
                    }
                }
                
                // Volume Count Display
                HStack {
                    Text("预计分卷数:")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text("\\(calculatedVolumes) 个")
                        .font(.headline)
                        .foregroundColor(.pink)
                }
            }
            .padding()
        }
    }
    
    private var compressionLevelSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("压缩级别")
                    .font(.headline)
                    .foregroundColor(.white)
                
                // Level Selection Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(compressionLevels, id: \.value) { level in
                        CompressionLevelButton(
                            level: level,
                            isSelected: compressionLevel == level.value
                        ) {
                            compressionLevel = level.value
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var resultsSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("压缩结果预览")
                    .font(.headline)
                    .foregroundColor(.white)
                
                // Key Metrics
                HStack(spacing: 20) {
                    MetricView(
                        title: "总分卷",
                        value: "\\(calculatedVolumes)",
                        subtitle: "个文件",
                        color: .pink
                    )
                    
                    MetricView(
                        title: "压缩后",
                        value: String(format: "%.1f", compressedSize),
                        subtitle: "MB",
                        color: .purple
                    )
                    
                    MetricView(
                        title: "压缩率",
                        value: String(format: "%.1f", (1 - compressedSize / fileSize) * 100),
                        subtitle: "%",
                        color: .blue
                    )
                }
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Estimated Time
                HStack {
                    Text("预计时间:")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text(estimatedTime)
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                // Volume Preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("分卷预览:")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    VolumePreviewView(volumeCount: calculatedVolumes)
                }
            }
            .padding()
        }
    }
    
    private var actionButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: calculateResults) {
                HStack {
                    Image(systemName: showingResults ? "arrow.clockwise" : "chart.bar")
                    Text(showingResults ? "重新计算" : "计算结果")
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
            
            if showingResults {
                Button(action: startVolumeCompression) {
                    HStack {
                        Image(systemName: "square.split.2x2")
                        Text("开始分卷压缩")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
        }
    }
    
    private func calculateResults() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showingResults = false
        }
        
        // Simulate calculation progress
        calculationProgress = 0.0
        
        Timer.publish(every: 0.02, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                calculationProgress += 0.02
                
                if calculationProgress >= 1.0 {
                    self.calculationProgress = 1.0
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.showingResults = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func startVolumeCompression() {
        // Simulate starting volume compression
        print("Starting volume compression with \(calculatedVolumes) volumes")
    }
    
    @State private var cancellables = Set<AnyCancellable>()
}

struct CompressionLevelButton: View {
    let level: (name: String, value: Int, description: String)
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(level.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                
                Text(level.description)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.pink : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.pink : Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

struct MetricView: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct VolumePreviewView: View {
    let volumeCount: Int
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 8) {
            ForEach(0..<min(volumeCount, 15), id: \.self) { index in
                VolumePartView(index: index + 1)
            }
            
            if volumeCount > 15 {
                Text("+\\(volumeCount - 15)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.1))
                    )
            }
        }
    }
}

struct VolumePartView: View {
    let index: Int
    
    var body: some View {
        VStack {
            Image(systemName: "doc")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text("part\\(index)")
                .font(.system(size: 8))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct VolumeCompressionView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeCompressionView()
    }
}