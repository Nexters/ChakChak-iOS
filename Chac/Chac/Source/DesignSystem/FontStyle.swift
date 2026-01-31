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

enum Scale {
    case headline_h1, headline_h2, headline_h3
    case sub_headline1, sub_headline2
    case body_large, body_medium, body_small1, body_small2
    case caption

    func generateFont(_ typeface: Typeface) -> Font {
        switch self {
        case .headline_h1:   return Font.custom("\(typeface.prefix)-Medium", size: 22)
        case .headline_h2:   return Font.custom("\(typeface.prefix)-Medium", size: 20)
        case .headline_h3:   return Font.custom("\(typeface.prefix)-Bold", size: 18)
        case .sub_headline1: return Font.custom("\(typeface.prefix)-Bold", size: 16)
        case .sub_headline2: return Font.custom("\(typeface.prefix)-Medium", size: 15)
        case .body_large:    return Font.custom("\(typeface.prefix)-Regular", size: 16)
        case .body_medium:   return Font.custom("\(typeface.prefix)-Regular", size: 15)
        case .body_small1:   return Font.custom("\(typeface.prefix)-Regular", size: 14)
        case .body_small2:   return Font.custom("\(typeface.prefix)-Regular", size: 13)
        case .caption:       return Font.custom("\(typeface.prefix)-Regular", size: 12)
        }
    }
}

extension View {
    func font(typeFace: Typeface, scale: Scale) -> some View {
        return self
            .font(scale.generateFont(typeFace))
    }
}
