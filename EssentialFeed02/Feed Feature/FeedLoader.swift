//
//  FeedLoader.swift
//  EssentialFeed02
//
//  Created by Anton Tugolukov on 4/5/24.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
