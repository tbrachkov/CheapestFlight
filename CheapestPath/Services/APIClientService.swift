//
//  APIClientService.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import Foundation

struct APIContants {
    static let baseURL = "https://raw.githubusercontent.com/punty/TUI-test/master"
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (self.dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask)
    }
}

struct APIClientService {
    typealias completeClosure = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
    
    private let session: URLSessionProtocol
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        let session = URLSession(configuration: configuration,
                                  delegate: nil,
                                  delegateQueue: OperationQueue.main)
        self.init(session: session)
    }
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func execute(urlRequest: URLRequest, callback: @escaping completeClosure) {
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            callback(data, response, error)
        }
        task.resume()
    }
    
    func getTripConnections(callback: @escaping (_ error: Error?, _ data: Data?) -> Void) {
        var request = URLRequest(url: URL(string: APIContants.baseURL)!.appendingPathComponent("connections.json"))
        request.httpMethod = "GET"
        getTripConnections(request: request, callback: callback)
    }
    
    func getTripConnections(request: URLRequest, callback: @escaping (_ error: Error?, _ data: Data?) -> Void) {
        self.execute(urlRequest: request) { (data, response, error) in
            callback(error, data)
        }
    }
}
