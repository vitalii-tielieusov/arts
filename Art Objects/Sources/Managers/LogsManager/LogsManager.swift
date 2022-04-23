//
//  LogsManager.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 19.04.2021.
//

import Foundation
import RxSwift

protocol LogsHandler {
    var logs: Observable<String?> { get }
    
    func appendLogs(with string: String)
    func clearLogs()
}

class LogsManager: NSObject {
    
    static let `shared` = LogsManager()
    
    private let logsStream = MutableStream<String?>(value: nil)
    var logs: Observable<String?> {
        return logsStream.asObservable()
    }
    
    override init() {
        super.init()
    }
}

extension LogsManager: LogsHandler {
    func appendLogs(with string: String) {
        guard FeatureFlags.shared.shouldCollectLogs else { return }
        
        guard !string.isEmpty else { return }
        
        guard var logsValue = logsStream.value() else {
            logsStream.onNext("\n --- \(string)")
            return
        }
        
        logsValue.append("\n --- \(string)")
        logsStream.onNext(logsValue)
    }
    
    func clearLogs() {
        logsStream.onNext(nil)
    }
}

