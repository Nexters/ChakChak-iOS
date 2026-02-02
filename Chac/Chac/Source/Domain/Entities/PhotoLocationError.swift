//
//  PhotoLocationError.swift
//  Chac
//
//  Created by 가은 on 2/2/26.
//

import Foundation

enum PhotoLocationError: String {
    case network
    case foundNoResult
    
    var location: String {
        switch self {
        case .network:          return "알 수 없는 장소"
        case .foundNoResult:    return "어느 멋진 날의 추억"
        }
    }
}
