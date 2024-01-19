//
//  NewsRepositoryImplement.swift
//  NewsViewer
//
//  Created by 송하민 on 1/19/24.
//

import Foundation
import Moya

final class NewsRepositoryImplement: NewsRepository {
  
  // MARK: - private properties
  
  private let provider = MoyaProvider<NewsAPI>()
  
  
  // MARK: - internal methos
  
  func loadAllNews() async throws -> NewsResponse {
    // FIXME: 의존성 주입할 것!!!!!!!
    return try await provider.async.request(.loadAllNews(accessToken: "fc5cdf67188f4f90a8c096db79216aa2", query: "apple", from: "2024-01-18", to: "2024-01-18", sort: "popularity"))
    // FIXME: 의존성 주입할 것!!!!!!!
  }
  
}
