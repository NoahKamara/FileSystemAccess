//
//  TemporaryFileSystem.swift
//
//  Copyright © 2024 Noah Kamara.
//

import Foundation

public final class TemporaryFileSystem: FileSystem, @unchecked Sendable {
    public let rootDirectory: URL

    public init(fileManager: FileManager = .default) throws {
        let rootDirectory = URL
            .temporaryDirectory
            .appending(component: UUID().uuidString, directoryHint: .isDirectory)

        try fileManager.createDirectory(at: rootDirectory, withIntermediateDirectories: false)
        self.rootDirectory = rootDirectory
        super.init(realURL: rootDirectory, fileManager: fileManager)
    }

    public consuming func destroy(fileManager: FileManager = .default) throws {
        try fileManager.removeItem(at: self.rootDirectory)
    }

    deinit {
        try? destroy()
    }
}

