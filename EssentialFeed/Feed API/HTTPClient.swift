//
//  HTTPClient.swift
//  EssentialFeed02
//
//  Created by Anton Tugolukov on 5/4/24.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
