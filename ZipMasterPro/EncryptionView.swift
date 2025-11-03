//
//  EncryptionView.swift
//  ZipMasterPro
//
//  Created by AI Assistant on 2025/11/03.
//

import SwiftUI
import CryptoKit

struct EncryptionView: View {
    @StateObject private var encryptionManager = EncryptionManager()
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var selectedAlgorithm = "AES-256"
    @State private var showingFilePicker = false
    @State private var selectedFile: FileItem?
    @State private var showPassword = false
    
    let algorithms = ["AES-128", "AES-256"]
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidGlassBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // File Selection
                        fileSelectionSection
                        
                        // Password Settings
                        passwordSettingsSection
                        
                        // Algorithm Selection
                        algorithmSelectionSection
                        
                        // Security Information
                        securityInfoSection
                        
                        // Encryption Progress
                        if encryptionManager.isProcessing {
                            encryptionProgressSection
                        }
                        
                        // Action Buttons
                        actionButtonsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("文件加密")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingFilePicker) {
                DocumentPicker { url in
                    let newFile = FileItem(name: url.lastPathComponent, url: url, size: 0)
                    selectedFile = newFile
                }
            }
        }
    }
    
    private var fileSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("选择文件")
                .font(.headline)
                .foregroundColor(.white)
            
            Button(action: {
                showingFilePicker = true
            }) {
                LiquidGlassCard {
                    if let file = selectedFile {
                        HStack {
                            FileIconView(fileExtension: file.fileExtension)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(file.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Text("点击更换文件")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding()
                    } else {
                        HStack {
                            Image(systemName: "doc.badge.plus")
                                .font(.title2)
                                .foregroundColor(.pink)
                            
                            Text("选择要加密的文件")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    private var passwordSettingsSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("密码设置")
                    .font(.headline)
                    .foregroundColor(.white)
                
                // Password Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("密码")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack {
                        if showPassword {
                            TextField("输入密码", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            SecureField("输入密码", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                
                // Confirm Password
                VStack(alignment: .leading, spacing: 8) {
                    Text("确认密码")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    SecureField("再次输入密码", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Password Strength
                if !password.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("密码强度")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        PasswordStrengthView(password: password)
                    }
                }
                
                // Password Requirements
                VStack(alignment: .leading, spacing: 4) {
                    Text("密码要求:")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        PasswordRequirementView(
                            text: "至少8个字符",
                            isMet: password.count >= 8
                        )
                        PasswordRequirementView(
                            text: "包含大写字母",
                            isMet: password.contains(where: { $0.isUppercase })
                        )
                        PasswordRequirementView(
                            text: "包含小写字母",
                            isMet: password.contains(where: { $0.isLowercase })
                        )
                        PasswordRequirementView(
                            text: "包含数字",
                            isMet: password.contains(where: { $0.isNumber })
                        )
                        PasswordRequirementView(
                            text: "包含特殊字符",
                            isMet: password.contains(where: { "!@#$%^&*()_+-=[]{}|;:'\",.<>?/".contains($0) })
                        )
                    }
                }
            }
            .padding()
        }
    }
    
    private var algorithmSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("加密算法")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(algorithms, id: \.self) { algorithm in
                AlgorithmSelectionRow(
                    algorithm: algorithm,
                    isSelected: selectedAlgorithm == algorithm
                ) {
                    selectedAlgorithm = algorithm
                }
            }
        }
    }
    
    private var securityInfoSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("安全信息")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "shield.checkered")
                            .foregroundColor(.green)
                        Text("军用级加密标准")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "key.fill")
                            .foregroundColor(.blue)
                        Text("密码不会被存储")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.purple)
                        Text("支持文件名加密")
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    
                    Text("使用\(selectedAlgorithm)算法，确保您的文件安全。密码不会被存储在设备上，请妥善保管您的密码。")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 8)
                }
            }
            .padding()
        }
    }
    
    private var encryptionProgressSection: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("加密进度")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ProgressView(value: encryptionManager.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .pink))
                
                HStack {
                    Text(encryptionManager.statusText)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text("\\(Int(encryptionManager.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            Button(action: startEncryption) {
                HStack {
                    Image(systemName: "lock.fill")
                    Text("开始加密")
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
            .disabled(!canStartEncryption)
            
            if encryptionManager.isProcessing {
                Button(action: {
                    encryptionManager.cancelProcessing()
                }) {
                    Text("取消操作")
                        .foregroundColor(.red)
                        .fontWeight(.medium)
                }
            }
        }
    }
    
    private var canStartEncryption: Bool {
        guard let _ = selectedFile else { return false }
        guard !password.isEmpty else { return false }
        guard password == confirmPassword else { return false }
        guard password.count >= 8 else { return false }
        
        return !encryptionManager.isProcessing
    }
    
    private func startEncryption() {
        guard let file = selectedFile else { return }
        
        encryptionManager.startEncryption(
            file: file,
            password: password,
            algorithm: selectedAlgorithm
        )
    }
}

struct AlgorithmSelectionRow: View {
    let algorithm: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(algorithm)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(algorithm == "AES-256" ? "最高安全性，推荐" : "标准安全性")
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

struct PasswordStrengthView: View {
    let password: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ProgressView(value: strengthLevel)
                .progressViewStyle(LinearProgressViewStyle(tint: strengthColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            Text(strengthText)
                .font(.caption)
                .foregroundColor(strengthColor)
        }
    }
    
    private var strengthLevel: Double {
        var score = 0.0
        
        if password.count >= 8 { score += 0.2 }
        if password.count >= 12 { score += 0.1 }
        if password.contains(where: { $0.isUppercase }) { score += 0.2 }
        if password.contains(where: { $0.isLowercase }) { score += 0.2 }
        if password.contains(where: { $0.isNumber }) { score += 0.2 }
        if password.contains(where: { "!@#$%^&*()_+-=[]{}|;:'\",.<>?/".contains($0) }) { score += 0.1 }
        
        return min(score, 1.0)
    }
    
    private var strengthColor: Color {
        switch strengthLevel {
        case 0..<0.4:
            return .red
        case 0.4..<0.7:
            return .orange
        case 0.7..<0.9:
            return .yellow
        default:
            return .green
        }
    }
    
    private var strengthText: String {
        switch strengthLevel {
        case 0..<0.4:
            return "弱"
        case 0.4..<0.7:
            return "一般"
        case 0.7..<0.9:
            return "良好"
        default:
            return "强"
        }
    }
}

struct PasswordRequirementView: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : .white.opacity(0.5))
                .font(.caption)
            
            Text(text)
                .font(.caption)
                .foregroundColor(isMet ? .white : .white.opacity(0.5))
        }
    }
}

struct EncryptionView_Previews: PreviewProvider {
    static var previews: some View {
        EncryptionView()
    }
}