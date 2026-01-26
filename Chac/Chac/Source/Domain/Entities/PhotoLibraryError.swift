//
//  PhotoLibraryError.swift
//  Chac
//
//  Created by 이원빈 on 1/22/26.
//

import Foundation

enum PhotoLibraryError: LocalizedError {
    case imageNotFound
    case cancelled
    case underlying(Error)
    
    var errorDescription: String? {
        switch self {
        case .imageNotFound:         return "[PhotoLibraryError] 이미지를 찾을 수 없습니다."
        case .cancelled:             return "[PhotoLibraryError] 요청이 취소되었습니다."
        case .underlying(let error): return "[PhotoLibraryError] \(error.localizedDescription)"
        }
    }
}
