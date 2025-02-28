//
//  File.swift
//  FileSystemAccess
//
//  Created by Noah Kamara on 28.02.2025.
//

import Foundation

public extension FileSystem {
    /// Creates a file with the specified text content at the given location.
    /// - Parameters:
    ///   - url: The url for the new file.
    ///   - text: A string value that will be encoded as contents of the new file
    ///   - encoding: The string encoding to use
    ///   - createIntermediateDirs: create intermediate directories if they do not exist
    func createTextFile(
        at url: URL,
        text: String,
        encoding: String.Encoding,
        createIntermediateDirs: Bool = false
    ) throws {
        guard let data = text.data(using: encoding) else {
            throw StringEncodingError()
        }

        try self.createFile(at: url, contents: data, createIntermediateDirs: createIntermediateDirs)
    }

    struct StringDecodingError: Error {}
    struct StringEncodingError: Error {}

    /// Returns the decoded text at the specified url
    /// - Parameters:
    ///   - url: The url of the file whose contents you want.
    ///   - encoding: The string encoding of the file
    func textContents(of url: URL, encoding: String.Encoding) throws -> String {
        let data = try self.contents(of: url)

        guard let string = String(data: data, encoding: encoding) else {
            throw StringDecodingError()
        }

        return string
    }
}
