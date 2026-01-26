//
//  PhotoEmptyView.swift
//  Chac
//
//  Created by 이원빈 on 1/14/26.
//

import SwiftUI

struct PhotoEmptyView: View {
    
    private enum Strings {
        static let noPhotosMessage = "정리할 사진이 없습니다.\n사진을 올리면 앨범을 착 정리할게요."
    }
    
    var body: some View {
        Text(Strings.noPhotosMessage)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    PhotoEmptyView()
}
