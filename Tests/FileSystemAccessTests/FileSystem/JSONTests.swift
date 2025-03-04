//
//  JSONTests.swift
//
//  Copyright © 2024 Noah Kamara.
//

@testable import FileSystemAccess
import Foundation
import Testing

@Suite("JSON", .tags(.fileSystemIO))
final class FileSystemJSONTests {
    let tempDir: TempDirRegistry = .init()

    struct ExampleJSON: Equatable, Codable {
        var name: String = "John Doe"
        var age: Int = 13
        var isSubscribed: Bool = true
    }

    @Test
    func write() async throws {
        let fileManager = FileManager.default
        let rootURL = try tempDir.create()
        let fileSystem = FileSystem(realURL: rootURL)

        let json = ExampleJSON()
        let fileURL = rootURL.appending(component: "profile.json")

        try fileSystem.createJSON(at: URL(filePath: fileURL.lastPathComponent), contents: json)

        var isDirectory = ObjCBool(booleanLiteral: false)
        let fileExistsAtPath = fileManager.fileExists(
            atPath: fileURL.path(),
            isDirectory: &isDirectory
        )

        try #require(fileExistsAtPath)
        #expect(isDirectory.boolValue == false)

        let fileData = try Data(contentsOf: fileURL)
        let decodedJSON = try JSONDecoder().decode(ExampleJSON.self, from: fileData)
        #expect(decodedJSON == json)
    }

    @Test
    func read() async throws {
        let fileManager = FileManager.default
        let rootURL = try tempDir.create()
        let fileSystem = FileSystem(realURL: rootURL)

        let json = ExampleJSON()
        let jsonData = try JSONEncoder().encode(json)
        let fileURL = rootURL.appending(component: "text.txt")

        try #require(fileManager.createFile(atPath: fileURL.path(), contents: jsonData))

        let contents = try fileSystem.jsonContents(
            of: URL(filePath: fileURL.lastPathComponent),
            type: ExampleJSON.self
        )

        #expect(contents == json)
    }
}
