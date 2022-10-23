//
//  StubURLSession.swift
//  AutocryptTests
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

final class StubURLSession: URLSessionable {
    
    enum ResponseState {
        case success
        case invalidStatusCode
        case invalidData
    }
    var dataTask: StubURLSessionDataTask?
    var responseState: ResponseState = .success
    
    init(responseState: ResponseState = .success) {
        self.responseState = responseState
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let endpoint = EndpointGenerator.fetchVaccinationList(page: "1")
        let successResponse = HTTPURLResponse(
            url: try! endpoint.url(),
            statusCode: 200,
            httpVersion: "1.1",
            headerFields: nil
        )
        let failureResponse = HTTPURLResponse(
            url: try! endpoint.url(),
            statusCode: 400,
            httpVersion: "1.1",
            headerFields: nil
        )
        
        let dataTask = StubURLSessionDataTask()
        self.dataTask = dataTask
        
        dataTask.resumeDidCall = {
            switch self.responseState {
            case .success:
                completionHandler(endpoint.testData!, successResponse, nil)
            case .invalidStatusCode:
                completionHandler(nil, failureResponse, nil)
            case .invalidData:
                completionHandler(nil, successResponse, nil)
            }
        }
        return dataTask
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = StubURLSessionDataTask()
        return dataTask
    }
    
}
