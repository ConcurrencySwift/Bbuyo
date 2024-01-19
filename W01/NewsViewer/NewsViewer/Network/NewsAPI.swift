//
//  NewsAPI.swift
//  NewsViewer
//
//  Created by 송하민 on 1/19/24.
//

import Foundation
import Moya

enum NewsAPI {
  case loadAllNews(accessToken: String, query: String, from: String, to: String, sort: String)
}

extension NewsAPI: TargetType {
  var baseURL: URL {
    return URL(string: RestAPIDefine.NEWS_DOMAIN_URL)!
  }
  
  var path: String {
    switch self {
      case .loadAllNews:
        return "/v2/everything"
    }
  }
  
  var method: Moya.Method {
    switch self {
      case .loadAllNews:
        return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
      case .loadAllNews(let accessToken, let query, let from, let to, let sort):
        let params: [String: String] = {
          let returnParams: [String: String] = [
            "q": query,
            "from": from,
            "to": to,
            "sortBy": sort,
            "apiKey": accessToken
          ]
          return returnParams
        }()
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    switch self {
      case .loadAllNews:
        return nil
    }
  }
  
  
}
