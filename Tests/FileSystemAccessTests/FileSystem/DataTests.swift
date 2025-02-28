//
//  DataTests.swift
//
//  Copyright © 2024 Noah Kamara.
//

@testable import FileSystemAccess
import Foundation
import Testing

@Suite("Data", .tags(.fileSystemIO))
final class FileSystemDataTests {
    let tempDir: TempDirRegistry = .init()

    @Test
    func write() async throws {
        let fileManager = FileManager.default
        let rootURL = try tempDir.create()
        let fileSystem = FileSystem(realURL: rootURL)

        let data = "Hello World".data(using: .utf8)!
        let fileURL = rootURL.appending(component: "text.txt")

        try fileSystem.createFile(at: URL(filePath: fileURL.lastPathComponent), contents: data)

        var isDirectory = ObjCBool(booleanLiteral: false)
        let fileExistsAtPath = fileManager.fileExists(
            atPath: fileURL.path(),
            isDirectory: &isDirectory
        )
        try #require(fileExistsAtPath)
        #expect(isDirectory.boolValue == false)

        let fileData = try Data(contentsOf: fileURL)
        #expect(fileData == data)
    }

    @Test
    func writeIntermediate() async throws {
        let fileManager = FileManager.default
        let rootURL = try tempDir.create()
        let fileSystem = FileSystem(realURL: rootURL)

        let data = "Hello World".data(using: .utf8)!
        let fileURL = rootURL.appending(components: "folder", "text.txt")

        try fileSystem.createFile(
            at: URL(filePath: "folder/text.txt"),
            contents: data,
            createIntermediateDirs: true
        )

        var isDirectory = ObjCBool(booleanLiteral: false)
        let fileExistsAtPath = fileManager.fileExists(
            atPath: fileURL.path(),
            isDirectory: &isDirectory
        )
        try #require(fileExistsAtPath)
        #expect(isDirectory.boolValue == false)

        let fileData = try Data(contentsOf: fileURL)
        #expect(fileData == data)
    }

    @Test
    func read() async throws {
        let fileManager = FileManager.default
        let rootURL = try tempDir.create()
        let fileSystem = FileSystem(realURL: rootURL)

        let data = "Hello World".data(using: .utf8)!
        let fileURL = rootURL.appending(component: "text.txt")

        try #require(fileManager.createFile(atPath: fileURL.path(), contents: data))

        let contents = try fileSystem.contents(of: URL(filePath: "text.txt"))
        #expect(contents == data)
    }
}
