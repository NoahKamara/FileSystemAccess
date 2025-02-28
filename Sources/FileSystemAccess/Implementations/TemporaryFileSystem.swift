//
//  File.swift
//  FileSystemAccess
//
//  Created by Noah Kamara on 27.02.2025.
//

import Foundation

public final class TemporaryDirectory: FileSystem, @unchecked Sendable {
    let rootDirectory: URL
    
    public init(fileManager: FileManager = .default) throws {
        let rootDirectory = URL
            .temporaryDirectory
            .appending(component: UUID().uuidString, directoryHint: .isDirectory)
        
        try fileManager.createDirectory(at: rootDirectory, withIntermediateDirectories: false)
        self.rootDirectory = rootDirectory
        super.init(realURL: rootDirectory, fileManager: fileManager)
    }

    consuming func destroy(fileManager: FileManager = .default) throws {
        try fileManager.removeItem(at: rootDirectory)
    }
    
    deinit {
        try? destroy()
    }
}


//public final class TemporaryDirectory: FileSystem, Sendable {
//    init(_ name: String?) {
//        let url = URL.temporaryDirectory.appending(component: uniqueName(name))
//        super.init(realURL: url)
//    }
//    
//    deinit {
//        
//    }
//}
//
//
//func uniqueName(_ name: String?) -> String {
//    let uuid = UUID().uuidString
//    
//    if let name {
//         // Take first 8 characters of UUID
//        return "\(name)_\(uuid.prefix(8))"
//    } else {
//        return uuid
//    }
//}
