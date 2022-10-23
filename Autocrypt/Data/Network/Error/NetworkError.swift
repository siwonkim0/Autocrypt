//
//  NetworkError.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation

enum NetworkError: Error {
    case unknownError(_ error: Error)
    case invalidRequest
    case invalidHttpStatusCode(code: Int)
    case invalidData
    case invalidURL
    case decodingFailed
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknownError(let error):
            return "예상하지 못한 에러가 발생했습니다. \n네트워크 연결을 확인해주세요. \(error.localizedDescription)"
        case .invalidRequest:
            return "URL Request 관련 에러가 발생했습니다"
        case .invalidHttpStatusCode(let statusCode):
            return "Status 코드가 정상범위가 아닙니다. \(statusCode)"
        case .invalidData:
            return "유효한 데이터가 아닙니다"
        case .invalidURL:
            return "URL 관련 에러가 발생했습니다"
        case .decodingFailed:
            return "데이터 디코딩 에러가 발생했습니다"
        }
    }
}
