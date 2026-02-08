//
//  FontStyle.swift
//  Chac
//
//  Created by 이원빈 on 1/29/26.
//

import SwiftUI

enum Typeface {
    case pretandard /// 한글
    case montserrat /// 영문/숫자
    
    var prefix: String {
        switch self {
        case .pretandard: return "Pretendard"
        case .montserrat: return "Montserrat"
        }
    }
}

enum ChacScale {
    case headline_01, headline_02
    case title
    case sub_title_01, sub_title_02, sub_title_03
    case content_title
    case body
    case caption
    case btn, sub_btn
    case number
    case toast_body
    case sub_number
    case splash_name
    case date_text

    func generateFont() -> Font {
        switch self {
        case .headline_01:   return Font.custom("Pretendard-SemiBold", size: 20)
        case .headline_02:   return Font.custom("Pretendard-Bold", size: 18)
        case .title:         return Font.custom("Pretendard-Medium", size: 20)
        case .sub_title_01:  return Font.custom("Pretendard-Medium", size: 18)
        case .sub_title_02:  return Font.custom("Pretendard-Bold", size: 16)
        case .sub_title_03:  return Font.custom("Pretendard-Medium", size: 14)
        case .content_title: return Font.custom("Pretendard-Medium", size: 16)
        case .body:          return Font.custom("Pretendard-Regular", size: 15)
        case .caption:       return Font.custom("Pretendard-Medium", size: 12)
        case .btn:           return Font.custom("Pretendard-SemiBold", size: 16)
        case .sub_btn:       return Font.custom("Pretendard-Bold", size: 14)
        case .number:        return Font.custom("Montserrat-SemiBold", size: 14)
        case .toast_body:    return Font.custom("Pretendard-Regular", size: 14)
        case .sub_number:    return Font.custom("Montserrat-SemiBold", size: 13)
        case .splash_name:   return Font.custom("Montserrat-SemiBold", size: 38)
        case .date_text:     return Font.custom("Pretendard-Medium", size: 13)
        }
    }
}

extension View {
    func chacFont(_ scale: ChacScale) -> some View {
        return self
            .font(scale.generateFont())
    }
}
