//
//  URLProtocolStub.swift
//  EssentialFeedTests
//
//  Created by Anton Tugolukov on 10/12/24.
//

import Foundation


class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestsObserver: ((URLRequest) -> (Void))?
    
    private struct Stub {
        let error: Error?
        let data: Data?
        let response: URLResponse?
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> (Void)) {
        requestsObserver = observer
    }
    
    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(error: error, data: data, response: response)
    }
    
    static func startIntercepting() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopIntercepting() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stub = nil
        requestsObserver = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        requestsObserver?(request)
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let requestObserver = URLProtocolStub.requestsObserver {
            client?.urlProtocolDidFinishLoading(self)
            return requestObserver(request)
        }
        
        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
