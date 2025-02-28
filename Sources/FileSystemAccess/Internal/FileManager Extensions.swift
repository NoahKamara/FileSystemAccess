//
//  FileManager Extensions.swift
//
//  Copyright © 2024 Noah Kamara.
//

import Foundation

extension FileManager {
    /// Returns a Boolean value that indicates whether a directory exists at a specified path.
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory = ObjCBool(booleanLiteral: false)
        let fileExistsAtPath = fileExists(atPath: path, isDirectory: &isDirectory)
        return fileExistsAtPath && isDirectory.boolValue
    }

    // This method does n't exist on `FileManager`. There is a similar looking method but it doesn't
    // provide information about potential errors.
    func contents(of url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
}
