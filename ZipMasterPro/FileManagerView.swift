//
//  FileManagerView.swift
//  ZipMasterPro
//
//  Created by AI Assistant on 2025/11/03.
//

import SwiftUI
import UniformTypeIdentifiers

class FileManagerModel: ObservableObject {
    @Published var files: [FileItem] = []
    @Published var isLoading = false
    
    private let fileManager = FileManager.default
    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    init() {
        loadFiles()
        createSampleFiles()
    }
    
    func loadFiles() {
        isLoading = true
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            files = fileURLs.map { url in
                FileItem(name: url.lastPathComponent, url: url, size: getFileSize(url: url))
            }
        } catch {
            print("Error loading files: \(error)")
            files = []
        }
        
        isLoading = false
    }
    
    private func createSampleFiles() {
        let sampleFiles = [
            ("Documents", "zip"),
            ("Photos", "7z"),
            ("Backup", "rar"),
            ("Projects", "tar"),
            ("Music", "gz")
        ]
        
        for (name, ext) in sampleFiles {
            let fileItem = FileItem(
                name: "\(name).\(ext)",
                url: URL(string: "file:///\(name).\(ext)")!,
                size: Int64.random(in: 100000...10000000),
                isSample: true
            )
            files.append(fileItem)
        }
    }
    
    private func getFileSize(url: URL) -> Int64 {
        do {
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int64 ?? 0
        } catch {
            return 0
        }
    }
    
    func deleteFile(_ file: FileItem) {
        if let index = files.firstIndex(where: { $0.id == file.id }) {
            files.remove(at: index)
        }
    }
    
    func extractFile(_ file: FileItem) {
        // Simulate file extraction
        if let index = files.firstIndex(where: { $0.id == file.id }) {
            files[index].isExtracting = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.files[index].isExtracting = false
                self.files[index].isExtracted = true
            }
        }
    }
}

struct FileManagerView: View {
    @EnvironmentObject var fileManager: FileManagerModel
    @State private var showingFilePicker = false
    @State private var selectedFile: FileItem?
    
    var body: some View {
        NavigationView {
            ZStack {
                // LiquidGlass Background
                LiquidGlassBackground()
                
                VStack {
                    if fileManager.isLoading {
                        ProgressView("加载中...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                    } else if fileManager.files.isEmpty {
                        emptyStateView
                    } else {
                        fileListView
                    }
                }
            }
            .navigationTitle("文件管理")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement .navigationBarTrailing) {
                    Button(action: {
                        showingFilePicker = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.pink)
                    }
                }
            }
            .sheet(isPresented: $showingFilePicker) {
                DocumentPicker { url in
                    // Handle selected file
                    let newFile = FileItem(
                        name: url.lastPathComponent,
                        url: url,
                        size: 0
                    )
                    fileManager.files.append(newFile)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.pink.opacity(0.7))
            
            Text("没有文件")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("点击右上角添加文件或拖拽文件到此处")
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingFilePicker = true
            }) {
                Text("添加文件")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
            }
        }
        .padding(40)
    }
    
    private var fileListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(fileManager.files) { file in
                    FileRowView(file: file) {
                        selectedFile = file
                    } onExtract: {
                        fileManager.extractFile(file)
                    } onDelete: {
                        fileManager.deleteFile(file)
                    }
                }
            }
            .padding()
        }
    }
}

struct FileRowView: View {
    let file: FileItem
    let onTap: () -> Void
    let onExtract: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        LiquidGlassCard {
            HStack {
                // File Icon
                FileIconView(fileExtension: file.fileExtension)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(file.name)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(file.formattedSize)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 16) {
                    if file.isExtracting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                            .scaleEffect(0.8)
                    } else if file.isExtracted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Button(action: onExtract) {
                            Image(systemName: "arrow.up.arrow.down.square")
                                .foregroundColor(.pink)
                        }
                    }
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct FileIconView: View {
    let fileExtension: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(iconColor)
                .frame(width: 40, height: 40)
            
            Text(fileExtension.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
    private var iconColor: Color {
        switch fileExtension.lowercased() {
        case "zip":
            return .blue
        case "7z":
            return .green
        case "rar":
            return .red
        case "tar":
            return .orange
        case "gz":
            return .purple
        case "bz2":
            return .indigo
        default:
            return .gray
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    let onPick: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [
            .zipArchive,
            .item
        ])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.onPick(url)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
    }
}

struct FileManagerView_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerView()
            .environmentObject(FileManagerModel())
    }
}