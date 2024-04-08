//
//  EssentialFeed02Tests.swift
//  EssentialFeed02Tests
//
//  Created by Anton Tugolukov on 4/5/24.
//

import XCTest

import EssentialFeed02

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (_, client) = makeSUT(url: url)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwise() {
        
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
        
    }
    
    func test_load_deliversFailureOnClientFailure() {
        let (sut, client) = makeSUT()
        
        var capturedError: RemoteFeedLoader.Error?
        client.error = NSError(domain: "TEST", code: 42)
        
        sut.load { error in capturedError = error}
        
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?
        
        func get(from url: URL, completion: @escaping (Error) -> Void ) {
            requestedURLs.append(url)
            if let error = error {
                completion(error)
            }
        }
    }
}
