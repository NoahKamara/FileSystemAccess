//
//  Utility.swift
//
//  Copyright © 2024 Noah Kamara.
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
        self.baseURL.appending(component: "filesystemaccess_test_" + id.uuidString)
    }

    func create() throws -> URL {
        let id = UUID()
        let url = self.makeURL(id: id)
        try self.fileManager.createDirectory(at: url, withIntermediateDirectories: false)
        self.items.insert(id)
        return url
    }

    func tearDown() throws {
        while let item = items.popFirst() {
            try self.fileManager.removeItem(at: self.makeURL(id: item))
        }
    }

    deinit {
        for item in items {
            let url = baseURL.appending(component: "filesystemaccess_test_" + item.uuidString)
            try! fileManager.removeItem(at: url)
        }
    }
}
