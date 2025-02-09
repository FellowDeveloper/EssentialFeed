//
//  FeedLoader.swift
//  EssentialFeed02
//
//  Created by Anton Tugolukov on 4/5/24.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
