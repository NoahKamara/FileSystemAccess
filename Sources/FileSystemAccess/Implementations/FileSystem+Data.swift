//
//  File.swift
//  FileSystemAccess
//
//  Created by Noah Kamara on 28.02.2025.
//

import Foundation

public extension FileSystem {
    /// Creates a file with the specified content and attributes at the given location.
    ///
    /// - Parameters:
    ///   - url: The url for the new file.
    ///   - contents: A data object containing the contents of the new file.
    ///   - createIntermediateDirs: create intermediate directories if necessary
    func createFile(
        at url: URL,
        contents: Data,
        createIntermediateDirs: Bool = false
    ) throws {
        if createIntermediateDirs, url.pathComponents.count > 1 {
            let parentURL = url.deletingLastPathComponent()

            try safeguard(parentURL) { url, fileManager in
                let fileExists = fileManager.directoryExists(atPath: url.path())

                if !fileExists {
                    try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
                }
            }
        }

        try self.safeguard(url) { url, _ in
            try contents.write(to: url)
        }
    }

    /// Returns the contents at the specified url
    /// - Parameters:
    ///   - url: The url of the file whose contents you want.
    func contents(of url: URL) throws -> Data {
        try self.safeguard(url) { url, fileManager in
            try fileManager.contents(of: url)
        }
    }
}
