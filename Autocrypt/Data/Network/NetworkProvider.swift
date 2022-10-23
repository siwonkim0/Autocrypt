//
//  NetworkProvider.swift
//  Autocrypt
//
//  Created by Siwon Kim on 2022/10/21.
//

import Foundation
import RxSwift

protocol NetworkProvidable {
    func request<E: RequestResponsable>(with endpoint: E, completion: @escaping (Result<E.Response, Error>) -> ())
    func request<E: RequestResponsable>(with endpoint: E) -> Observable<E.Response>
}

final class NetworkProvider: NetworkProvidable {
    private let session: URLSessionable
    private var task: URLSessionDataTask?
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func request<E: RequestResponsable>(with endpoint: E, completion: @escaping (Result<E.Response, Error>) -> ()) {
        do {
            let urlRequest = try endpoint.urlRequest()
            task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
                self?.check(data: data, response: response, error: error) { result in
                    switch result {
                    case .success(let data):
                        do {
                            let decodedData = try JSONDecoder().decode(E.Response.self, from: data)
                            completion(.success(decodedData))
                        } catch {
                            completion(.failure(NetworkError.decodingFailed))
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            task?.resume()
        } catch {
            completion(.failure(NetworkError.invalidRequest))
        }
    }
    
    private func check(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Data, Error>) -> ()) {
        if let error = error {
            completion(.failure(NetworkError.unknownError(error)))
            return
        }
        if let httpResponse = response as? HTTPURLResponse,
              !(200..<300).contains(httpResponse.statusCode) {
            completion(.failure(NetworkError.invalidHttpStatusCode(code: httpResponse.statusCode)))
            return
        }
        guard let data = data else {
            completion(.failure(NetworkError.invalidData))
            return
        }
        completion(.success(data))
    }
}

extension NetworkProvider {
    func request<E: RequestResponsable>(with endpoint: E) -> Observable<E.Response> {
        return Observable.create { [weak self] observer in
            self?.request(with: endpoint) { result in
                switch result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                self?.task?.cancel()
            }
        }
    }
}
