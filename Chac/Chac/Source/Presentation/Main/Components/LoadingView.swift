//
//  LoadingView.swift
//  Chac
//
//  Created by 이원빈 on 1/14/26.
//

import SwiftUI

struct LoadingView: View {
    
    private enum Strings {
        static let loadingDescription = "앨범을 생성하는 중입니다.\n잠시만 기다려주세요!"
    }
    
    var body: some View {
        VStack {
            Image("loading_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 43.25, height: 38)
                .padding(.top, 40)
            
            Text(Strings.loadingDescription)
                .multilineTextAlignment(.center)
                .padding(.top, 14)
        }
    }
}

#Preview {
    LoadingView()
}
