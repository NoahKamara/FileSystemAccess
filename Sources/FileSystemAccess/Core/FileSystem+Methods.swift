//
//  File.swift
//  FSNamespace
//
//  Created by Noah Kamara on 27.02.2025.
//

import Foundation

public let slashCharSet = CharacterSet(charactersIn: "/")

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
        return try self.safeguard(url) { url, fileManager in
            try fileManager.contents(of: url)
        }
    }
}


// MARK: JSON Codable

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

// MARK: Text

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


//public extension FileSystemAccess {
//    func hierarchy() throws -> FSNode {
//        try safeguard(url) { url, fileManager in
//            try FSNode.buildTree(root: url, fileManager: fileManager)
//        }
//    }
//}
