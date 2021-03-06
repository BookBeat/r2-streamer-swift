//
//  DirectoryContainer.swift
//  r2-streamer-swift
//
//  Created by Alexandre Camilleri on 2/15/17.
//
//  Copyright 2018 Readium Foundation. All rights reserved.
//  Use of this source code is governed by a BSD-style license which is detailed
//  in the LICENSE file present in the project repository where this source code is maintained.
//

import R2Shared

extension ContainerEpubDirectory: Loggable {}

/// Container for expended EPUB publications. (Directory)
public class ContainerEpubDirectory: DirectoryContainer {
    public var attribute: [FileAttributeKey : Any]?
    
    /// See `RootFile`.
    public var rootFile: RootFile
    public var drm: Drm?    

    /// Public failable initializer for the EpubDirectoryContainer class.
    ///
    /// - Parameter dirPath: The root directory path.
    public init?(directory path: String) {
        // FIXME: useless check probably. Always made before hand.
        guard FileManager.default.fileExists(atPath: path) else {
            ContainerEpubDirectory.log(level: .error, "File at \(path) not found.")
            return nil
        }
        rootFile = RootFile.init(rootPath: path)
    }
}
