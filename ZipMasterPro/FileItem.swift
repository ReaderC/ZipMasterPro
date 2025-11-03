//
//  FileItem.swift
//  ZipMasterPro
//
//  Created by AI Assistant on 2025/11/03.
//

import Foundation
import SwiftUI

struct FileItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let url: URL
    let size: Int64
    var isSample: Bool = false
    var isExtracting: Bool = false
    var isExtracted: Bool = false
    
    var fileExtension: String {
        return URL(fileURLWithPath: name).pathExtension
    }
    
    var formattedSize: String {
        return formatFileSize(size)
    }
    
    private func formatFileSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}