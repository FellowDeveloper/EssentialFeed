//
//  URLSessionHTTPClientTests.swift
//  EssentialFeed02Tests
//
//  Created by Anton Tugolukov on 5/27/24.
//

import XCTest
import EssentialFeed02

class URLSessionHTTPClient {
    private let session: HTTPSession
    
    init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> (Void)) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask
}

protocol HTTPSessionDataTask {
    func resume()
}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, with: task)
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "http://any-url.com")!
        let session = HTTPSessionSpy()
        let task = URLSessionDataTaskSpy()
        let error = NSError(domain: "any error", code: 42)
        session.stub(url: url, error: error)
        let sut = URLSessionHTTPClient(session: session)
        
        let expectation = XCTestExpectation(description: "Waiting for completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure. Got \(result) instead")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    private class HTTPSessionSpy: HTTPSession {
        private struct Stub {
            let task: HTTPSessionDataTask
            let error: Error?
            
            init(task: HTTPSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
                self.task = task
                self.error = error
            }
        }
        private var stubs = [URL:Stub]()
        
        func stub(url: URL, with task: HTTPSessionDataTask) {
            stubs[url] = Stub(task: task)
        }
        
        func stub(url: URL, error: Error) {
            stubs[url] = Stub(error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("No stub for url:\(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    private class FakeURLSessionDataTask: HTTPSessionDataTask {
        func resume() {}
    }
    private class URLSessionDataTaskSpy: HTTPSessionDataTask {
        var resumeCallCount = 0
        
        func resume() {
            resumeCallCount += 1
        }
    }
}
