//
//  BookSegment.swift
//  LibraryManager
//
//  Created by Nata Khurtsidze on 15.04.23.
//

import Foundation

// MARK: - Book Segment
public enum BookSegment: String, CaseIterable, Hashable {
    case library = "Library  ۫"
    case wishlist = "Wishlist  ۫"
    case queue = "Queue  ۫"
}
