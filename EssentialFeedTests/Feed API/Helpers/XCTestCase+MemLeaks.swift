//
//  XCTestCase+MemLeaks.swift
//  EssentialFeed02Tests
//
//  Created by Anton Tugolukov on 6/8/24.
//

import Foundation
import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
        }
    }
}
