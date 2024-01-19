//
//  MoyaProviderExtension.swift
//  NewsViewer
//
//  Created by 송하민 on 1/19/24.
//

import Foundation
import Moya

extension MoyaProvider {
  
  class MoyaConcurrency {
    
    private let provider: MoyaProvider
    
    init(provider: MoyaProvider) {
      self.provider = provider
    }
    
    func request<T: Decodable>(_ target: Target) async throws -> T {
      return try await withCheckedThrowingContinuation { continuation in
        provider.request(target) { result in
          switch result {
            case .success(let response):
              guard let res = try? JSONDecoder().decode(T.self, from: response.data) else {
                continuation.resume(throwing: MoyaError.jsonMapping(response))
                return
              }
              continuation.resume(returning: res)
            case .failure(let error):
              continuation.resume(throwing: error)
          }
        }
      }
    }
  }
  
  var async: MoyaConcurrency {
    MoyaConcurrency(provider: self)
  }
  
}
