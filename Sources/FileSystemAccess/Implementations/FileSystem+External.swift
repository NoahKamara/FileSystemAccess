//
//  FileSystem+Methods.swift
//
//  Copyright © 2024 Noah Kamara.
//

import Foundation


// MARK: Copy External
extension FileSystem {
    public func copyExternalItem(at srcURL: URL, to dstURL: URL) throws {
        try safeguard(dstURL) { dstURL, fileManager in
            try fileManager.copyItem(at: srcURL, to: dstURL)
        }
    }
}
