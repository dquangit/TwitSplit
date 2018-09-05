//
//  File.swift
//  TwitSplit
//
//  Created by thuydunq on 9/6/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import Foundation

protocol MessageLogic: class {
    
    /// Split message into chunks
    ///
    /// - Parameter message: need to split
    /// - Returns: chunk array whith indicator (if chunk array has more than 1 element),
    ///            each chunk is a string that it's size does not exccess `chunkCapacity` characters.
    ///            If array has only one chunk, no need to attach indicator.
    /// - Throws: `SplitMessageError.wordExcessedCapacity` if `message` contains at least one word exccess `chunkCapacity` character or the sum of indicator and word size excess `chunnkCapacity`
    func splitMessage(_ message: String!) throws -> [String]!
}

extension MessageLogic {
    
    static var chunkCapacity: Int {
        return 50
    }
}
