//
//  NewsMainVIewModel.swift
//  NewsViewer
//
//  Created by 송하민 on 1/19/24.
//

import Foundation
import ReactorKit

final class NewsMainReactor: Reactor {
  
  enum Action {
    case loadNews
  }
  
  enum Mutation {
    case setNews(news: NewsResponse?)
    case setError(Error)
  }
  
  struct State {
    var news: Pulse<NewsResponse?> = .init(wrappedValue: nil)
    var error: Pulse<Error?> = .init(wrappedValue: nil)
  }
  
  // MARK: - private properties
  
  private let newsUsecase: NewsUsecase
  
  
  // MARK: - internal properties
  
  var initialState: State = State()
  
  
  // MARK: - life cycle
  
  init(newsRepository: NewsRepository) {
    self.newsUsecase = NewsUsecase(newsRepository: newsRepository)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .loadNews:
        return Observable.create { [weak self] observer in
          Task { [weak self] in
            guard let self = self else {
              observer.onCompleted()
              return
            }
            do {
              let news = try await self.loadAllNews()
              observer.onNext(.setNews(news: news))
            } catch {
              observer.onNext(.setError(error))
            }
            observer.onCompleted()
          }
          return Disposables.create()
        }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      case .setNews(let news):
        newState.news.value = news
      case .setError(let error):
        newState.error.value = error
    }
    return newState
  }
  
  
  
  // MARK: - private methods
  
  private func loadAllNews() async throws -> NewsResponse {
    return try await self.newsUsecase.loadAllNews()
  }
  
  // MARK: - internal methods
}
