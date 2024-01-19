//
//  NewsUsecase.swift
//  NewsViewer
//
//  Created by 송하민 on 1/19/24.
//

import Foundation

final class NewsUsecase {
  
  // MARK: - private properties
  
  private let repository: NewsRepository
  
  
  // MARK: - life cycle
  
  init(newsRepository: NewsRepository) {
    self.repository = newsRepository
  }
  
  
  // MARK: - internal methods
  
  func loadAllNews() async throws -> NewsResponse {
    return try await repository.loadAllNews()
  }
  
}
