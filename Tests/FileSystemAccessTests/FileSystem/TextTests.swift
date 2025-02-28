//
//  TextTests.swift
//
//  Copyright © 2024 Noah Kamara.
//

@testable import FileSystemAccess
import Foundation
import Testing

@Suite("Text", .tags(.fileSystemIO))
final class FileSystemTextTests {
    let tempDir: TempDirRegistry = .init()

    deinit {
        try! tempDir.tearDown()
    }

    @Test(arguments: stringEncodings)
    func write(encoding: String.Encoding) async throws {
        let fileManager = FileManager.default
        let rootURL = try tempDir.create()
        let fileSystem = FileSystem(realURL: rootURL)

        let text = "Hello World"
        let fileURL = rootURL.appending(component: "text.txt")

        try fileSystem.createTextFile(
            at: URL(filePath: fileURL.lastPathComponent),
            text: text,
            encoding: encoding
        )

        var isDirectory = ObjCBool(booleanLiteral: false)
        let fileExistsAtPath = fileManager.fileExists(
            atPath: fileURL.path(),
            isDirectory: &isDirectory
        )
        try #require(fileExistsAtPath)
        #expect(isDirectory.boolValue == false)

        let fileData = try Data(contentsOf: fileURL)
        #expect(fileData == text.data(using: encoding))
    }

    @Test(arguments: stringEncodings)
    func read(encoding: String.Encoding) async throws {
        let fileManager = FileManager.default
        let rootURL = try tempDir.create()
        let fileSystem = FileSystem(realURL: rootURL)

        let data = "Hello World".data(using: encoding)!
        let fileURL = rootURL.appending(component: "text.txt")

        try #require(fileManager.createFile(atPath: fileURL.path(), contents: data))

        let contents = try fileSystem.textContents(
            of: URL(filePath: fileURL.lastPathComponent),
            encoding: encoding
        )
        #expect(contents == "Hello World")
    }
}

private let stringEncodings: Set<String.Encoding> = [
    .ascii,
    .nextstep,
    .japaneseEUC,
    .utf8,
    .isoLatin1,
    .nonLossyASCII,
    .shiftJIS,
    .isoLatin2,
    .unicode,
    .windowsCP1251,
    .windowsCP1252,
    .windowsCP1253,
    .windowsCP1254,
    .windowsCP1250,
    .iso2022JP,
    .macOSRoman,
    .utf16,
    .utf16BigEndian,
    .utf16LittleEndian,
    .utf32,
    .utf32BigEndian,
    .utf32LittleEndian,
]
