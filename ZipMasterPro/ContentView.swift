//
//  ContentView.swift
//  ZipMasterPro
//
//  Created by AI Assistant on 2025/11/03.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var fileManager = FileManagerModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // File Manager Tab
            FileManagerView()
                .environmentObject(fileManager)
                .tabItem {
                    Image(systemName: "folder")
                    Text("文件")
                }
                .tag(0)
            
            // Compression Tab
            CompressionView()
                .environmentObject(fileManager)
                .tabItem {
                    Image(systemName: "archivebox")
                    Text("压缩")
                }
                .tag(1)
            
            // Encryption Tab
            EncryptionView()
                .tabItem {
                    Image(systemName: "lock")
                    Text("加密")
                }
                .tag(2)
            
            // Volume Compression Tab
            VolumeCompressionView()
                .tabItem {
                    Image(systemName: "square.split.2x2")
                    Text("分卷")
                }
                .tag(3)
        }
        .accentColor(.pink)
        .onAppear {
            // Initialize app appearance
            setupAppearance()
        }
    }
    
    private func setupAppearance() {
        // Configure tab bar appearance for LiquidGlass effect
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}