//
//  Record.swift
//  RDViewer
//
//  Created by chas on 6/12/20.
//

import Foundation

struct Record: Codable {
    let id: String
    let title: String
    let author: String
    let thumbnail: String?
    let thumbnail_height: Int?
    let thumbnail_width: Int?
    let num_comments: Int?
}
