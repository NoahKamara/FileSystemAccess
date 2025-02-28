//
//  File.swift
//  FileSystemAccess
//
//  Created by Noah Kamara on 28.02.2025.
//

import Foundation

public extension FileSystem {
    /// Creates a file with the specified JSON content at the given location.
    /// - Parameters:
    ///   - url: The url for the new file.
    ///   - contents: An encodable value that will be encoded as contents of the new file.
    ///   - createIntermediateDirs: create intermediate directories if necessary
    func createJSON(
        at url: URL,
        contents: some Encodable,
        encoder: JSONEncoder = JSONEncoder(),
        createIntermediateDirs: Bool = false
    ) throws {
        let data = try encoder.encode(contents)
        try self.createFile(at: url, contents: data, createIntermediateDirs: createIntermediateDirs)
    }

    /// Returns the decoded contents at the specified url
    /// - Parameters:
    ///   - url: The url of the file whose contents you want.
    ///   - type: the type that should be decoded from the data at path
    ///   - decoder: the JSONDecoder to use for decoding
    func jsonContents<Value: Decodable>(
        of url: URL,
        type: Value.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> Value {
        let data = try contents(of: url)
        return try decoder.decode(Value.self, from: data)
    }
}
