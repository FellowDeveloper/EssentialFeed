//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Anton Tugolukov on 5/27/24.
//

import XCTest
import EssentialFeed

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startIntercepting()
    }
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopIntercepting()
    }
    
    func test_getFromURL_performsGETRequestWithGivenURL() {
        let url = anyURL()
        
        let exp = XCTestExpectation(description: "Wait for request")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        
        makeSUT().get(from: url, completion: { _ in })
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_getFromURL_performsGETRequestWithGivenURL3() {
        let url = anyURL()
        
        let exp = XCTestExpectation(description: "Wait for request")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        
        makeSUT().get(from: url, completion: { _ in })
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test_getFromURL_performsGETRequestWithGivenURL4() {
        let url = anyURL()
        
        let exp = XCTestExpectation(description: "Wait for request")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        
        makeSUT().get(from: url, completion: { _ in })
        
        wait(for: [exp], timeout: 0.01)
    }
    
    func test_getFromURL_performsGETRequestWithGivenURL5() {
        let url = anyURL()
        
        let exp = XCTestExpectation(description: "Wait for request")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        
        makeSUT().get(from: url, completion: { _ in })
        
        wait(for: [exp], timeout: 0.01)
    }
    
    
    
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = NSError(domain: "any error", code: 42)
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError) as? NSError
        
        XCTAssertEqual(receivedError?.code, requestError.code)
        XCTAssertEqual(receivedError?.domain, requestError.domain)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        
        let nonHTTPURLResponse = URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)

        XCTAssertNotNil(anyHTTPURLResponse)
        
        let anyError = NSError(domain: "any error", code: 0)
        
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyError))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyError))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse, error: nil))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: data, response: response, error: nil)
        
        XCTAssertEqual(data, receivedValues?.data)
        XCTAssertEqual(response.url, receivedValues?.response.url)
        XCTAssertEqual(response.statusCode, receivedValues?.response.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDAtaOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()
        
        let values = resultValuesFor(data: nil, response: response, error: nil)
        
        XCTAssertEqual(Data(), values?.data)
        XCTAssertEqual(response.url, values?.response.url)
        XCTAssertEqual(response.statusCode, values?.response.statusCode)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error?
    {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure. Got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (response: HTTPURLResponse, data:Data)?
    {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)
        switch result {
        case let .success(data, response):
            return (response:response, data: data)
        default:
            XCTFail("Expected success. Got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPClientResult
    {
        var capturedResult : HTTPClientResult!
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let expectation = XCTestExpectation(description: "Waiting for completion")
        makeSUT(file: file, line: line).get(from: anyURL()) { result in
            capturedResult = result
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
        return capturedResult
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyData() -> Data {
        Data("any data three".utf8)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion:nil, headerFields: nil)!
    }
}
