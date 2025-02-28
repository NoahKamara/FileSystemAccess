//
//  File.swift
//  FSNamespace
//
//  Created by Noah Kamara on 27.02.2025.
//

import Foundation

/// A file system scoped to a root url
public class FileSystem: @unchecked Sendable {
    fileprivate let fileManager: FileManager
    fileprivate let realURL: URL
    
    public var name: String { realURL.lastPathComponent }
    public var fileExtension: String { realURL.pathExtension }

    public init(realURL: URL, fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.realURL = realURL.absoluteURL
    }
}


extension FileSystem {
    @inline(__always)
    func safeguard<T>(
        _ path: String,
        access: @escaping (URL, FileManager) throws -> T
    ) throws -> T {
        try self.safeguard(URL(filePath: path), access: access)
    }
    
    @inline(__always)
    func safeguard<T>(_ url: URL, access: (URL, FileManager) throws -> T) throws -> T {
        precondition(url.isFileURL, "url must be file-url")
        
        let rootPath = self.realURL.path()
        let realAccessURL = self.realURL.appending(path: url.path()).resolvingSymlinksInPath()
        let accessPath = realAccessURL.path()
        
        guard accessPath.hasPrefix(rootPath) else {
            throw SafeguardFailure(accessPath: url.path())
        }

        return try access(realAccessURL, self.fileManager)
    }

    struct SafeguardFailure: Equatable, LocalizedError, Error {
        let accessPath: String

        var errorDescription: String {
            "SafeguardFailure: Prevented access of unsafe file system path '\(accessPath)'"
        }
    }
}
