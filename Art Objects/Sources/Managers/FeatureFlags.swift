//
//  FeatureFlags.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import Foundation

class FeatureFlags {
    static let shared = FeatureFlags()
    
    public var shouldPrintHTTPLogs: Bool {
        return false
    }
    
    public var shouldCollectLogs: Bool {
        return false
    }
    
    private init() {
    }
}
