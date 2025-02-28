//
//  TextTests.swift
//
//  Copyright © 2024 Noah Kamara.
//

@testable import FileSystemAccess
import Foundation
import Testing

@Suite("Text", .tags(.fileSystemIO))
final class FileSystemExternalTests {
    let tempDir: TempDirRegistry = .init()
    
    @Test()
    func importItem() async throws {
        let fileManager = FileManager.default
        
        let externalFileURL = try tempDir.create().appending(component: "text.txt")
        let data = "Hello World".data(using: .utf8)!

        try #require(fileManager.createFile(atPath: externalFileURL.path(), contents: data))
        
        
        let rootURL = try tempDir.create()
        
        let internalFileURL = rootURL.appending(component: "internal.txt")

        let fileSystem = FileSystem(realURL: rootURL)
        try fileSystem.copyExternalItem(at: externalFileURL, to: URL(filePath: internalFileURL.lastPathComponent))

        var isDirectory = ObjCBool(booleanLiteral: false)
        let fileExistsAtPath = fileManager.fileExists(
            atPath: internalFileURL.path(),
            isDirectory: &isDirectory
        )
        try #require(fileExistsAtPath)
        #expect(isDirectory.boolValue == false)

        let fileData = try Data(contentsOf: internalFileURL)
        #expect(fileData == data)
    }
}
