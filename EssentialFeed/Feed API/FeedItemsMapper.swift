//
//  FeedItemsMapper.swift
//  EssentialFeed02
//
//  Created by Anton Tugolukov on 5/4/24.
//

import Foundation

final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]
        var feed: [FeedImage] {
            items.map { $0.feedItem }
        }
    }

    private struct Item: Decodable {
        public let id: UUID
        public let description: String?
        public let location: String?
        public let image: URL
        
        var feedItem: FeedImage {
            FeedImage(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data)  else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        return .success(root.feed)

    }
}

