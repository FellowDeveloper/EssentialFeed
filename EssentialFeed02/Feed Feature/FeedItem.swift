//
//  FeedItem.swift
//  EssentialFeed02
//
//  Created by Anton Tugolukov on 4/5/24.
//

import Foundation

public struct FeedItem : Equatable {
    let id: UUID
    let descripion: String?
    let location: String?
    let imageURL: URL
}
