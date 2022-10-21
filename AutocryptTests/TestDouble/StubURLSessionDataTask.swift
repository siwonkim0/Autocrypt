//
//  StubURLSessionDataTask.swift
//  AutocryptTests
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

final class StubURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
    
    override func cancel() { }
}
