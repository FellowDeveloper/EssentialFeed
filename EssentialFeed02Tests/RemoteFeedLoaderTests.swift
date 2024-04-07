//
//  EssentialFeed02Tests.swift
//  EssentialFeed02Tests
//
//  Created by Anton Tugolukov on 4/5/24.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    let feedUrl: URL
    
    init(url: URL, client: HTTPClient) {
        self.feedUrl = url
        self.client = client
    }
    func load(){
        client.get(from: feedUrl)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}



final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (_, client) = makeSUT(url: url)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut: sut, client: client)
        
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}
