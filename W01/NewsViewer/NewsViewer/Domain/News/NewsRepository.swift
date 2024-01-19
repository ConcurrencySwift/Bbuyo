//
//  NewsRepository.swift
//  NewsViewer
//
//  Created by 송하민 on 1/19/24.
//

import Foundation

protocol NewsRepository {
  func loadAllNews() async throws -> NewsResponse
}

struct NewsResponse: Codable {
  var status: String
  var totalResults: Int
  var articles: [Article]
}

struct Article: Codable {
  var source: Source?
  var author: String?
  var title: String?
  var description: String?
  var url: String?
  var urlToImage: URL?
  var publishedAt: String?
  var content: String?
}

struct Source: Codable {
  var id: String?
  var name: String
}
