//
//  File 2.swift
//  FileSystemAccess
//
//  Created by Noah Kamara on 28.02.2025.
//

import Foundation
import Testing
@testable import FileSystemAccess

@Suite("TemporaryDirectory")
struct TemporaryDirectoryTests {
    
    @Test
    func test() async throws {
        let fileManager = FileManager.default
        let tempDir = try TemporaryDirectory()

        var isDirectory = ObjCBool(booleanLiteral: false)
        let fileExistsAtPath = fileManager.fileExists(
            atPath: tempDir.rootDirectory.path(),
            isDirectory: &isDirectory
        )

        try #require(fileExistsAtPath)
        #expect(isDirectory.boolValue == true)

        let testFileData = "Hello World".data(using: .utf8)!
        let testFileURL = tempDir.rootDirectory.appending(component: "text.txt")

        try tempDir.createFile(
            at: URL(filePath: testFileURL.lastPathComponent),
            contents: testFileData
        )
        
        let fileData = try Data(contentsOf: testFileURL)
        #expect(fileData == testFileData)
        
        try tempDir.destroy()
        let leftAfterDestroy = fileManager.fileExists(atPath: tempDir.rootDirectory.path())
        #expect(!leftAfterDestroy)
    }
}
