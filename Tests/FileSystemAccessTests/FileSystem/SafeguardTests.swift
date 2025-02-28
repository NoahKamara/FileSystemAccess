import Testing
@testable import FileSystemAccess
import Foundation

extension URL {
    static let devNull = URL(filePath: "/dev/null")
}

@Suite("Safeguard")
struct SafeguardTests {
    let fileSystem = FileSystem(realURL: URL.devNull)
    
    @Test(arguments: [
        // with leading slash
        "/",
        "/file",
        "/folder/",
        
        // without leading slash
        "",
        "file",
        "folder",
        "folder/file",
    ])
    func validPathAccess(path: String) async throws {
        try self.fileSystem.safeguard(path, access: { _, _ in })
    }
    
    @Test(arguments: [
        ("/folder/..", true),
        ("/folder/folder/../..", true),
        ("/..", false),
        ("/../file", false),
        ("/../..", false),
        ("/folder/../..", false),
        ("/folder/../../..", false),
        ("/folder/folder/../../..", false),
    ])
    func rootDirectoryHandling(path: String, isValid: Bool) async throws {
        if isValid {
            try self.fileSystem.safeguard(path, access: { _, _ in })
            return
        }
        
        #expect(performing: {
            try self.fileSystem.safeguard(path, access: { _, _ in })
        }, throws: { error in
            let expectedFailure = FileSystem.SafeguardFailure(accessPath: path)
            let failure = (error as? FileSystem.SafeguardFailure)
            return failure == expectedFailure
        })
    }
}
