//
//  File.swift
//  FileSystemAccess
//
//  Created by Noah Kamara on 28.02.2025.
//

import Foundation
import Testing


extension Tag {
    @Tag static var fileSystemIO: Tag
}


final class TempDirRegistry {
    let baseURL = URL.temporaryDirectory

    let fileManager: FileManager = .default
    var items: Set<UUID> = .init()

    private func makeURL(id: UUID) -> URL {
        baseURL.appending(component: "filesystemaccess_test_" + id.uuidString)
    }

    func create() throws -> URL {
        let id = UUID()
        let url = makeURL(id: id)
        try fileManager.createDirectory(at: url, withIntermediateDirectories: false)
        items.insert(id)
        return url
    }

    func tearDown() throws {
        while let item = items.popFirst() {
            try fileManager.removeItem(at: makeURL(id: item))
        }
    }

    deinit {
        guard items.isEmpty else {
            for item in items {
                let url = baseURL.appending(component: "filesystemaccess_test_" + item.uuidString)
                try? fileManager.removeItem(at: url)
            }
            fatalError("Did not tearDown")
        }
    }
}
